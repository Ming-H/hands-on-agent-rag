#!/usr/bin/env python3
"""naive_rag.py — 第 1 章「先造坏」教具：一个没有闸门的 naive 检索直答。

刻意不用 Tally 的任何智能——双轨 FTS、期间过滤、口径守卫、引用对账、
拒答路径一概没有。这就是你在「10 分钟 RAG Demo」教程里会写出来的东西：
关键词打分取 top-1 块，从里面抠一个带数字的句子当答案，永不拒答。

跑三条问题，亲手撞出三类失败（与 Tally 同题对照）：

  失败① 检索失败  问「原因」，检索/抽取只会找数字句——错块错形态
  失败② 口径失败  问「扣非净利润」，答案句抓到「归母净利润」
  失败③ 无据硬答  语料里根本没有 2030 年，照样抠个数回答

用法（tally 仓库根目录，或设 TALLY_DB 指向库文件）：
  python3 naive_rag.py [--db tally.db]
"""
from __future__ import annotations

import os
import re
import sqlite3
import sys

# ---------------------------------------------------------------- 检索：词面打分
def terms(query: str) -> list[str]:
    """把 query 切成语词条：CJK 滑动二元组 + 数字串。没有 jieba（无词典
    分词），没有同义映射（「赚」→「净利润」这种事 naive 管线不会做）。"""
    toks: list[str] = []
    for run in re.findall(r"[一-鿿]+|\d[\d,，.]*亿?万?", query):
        if run[0].isdigit():
            toks.append(run)
        elif len(run) <= 2:
            toks.append(run)
        else:  # 长段切滑动二元组——「营收变动的主要原因」→ 营收/收变/变动/…
            toks += [run[i:i + 2] for i in range(len(run) - 1)]
    stop = {"多少", "怎么", "什么", "说了", "预测", "的原", "原因", "主要"}
    return [t for t in toks if t not in stop]


def naive_retrieve(conn: sqlite3.Connection, query: str, k: int = 3):
    """LIKE 子串打分（不是 BM25，没有词频/IDF/字轨兜底）。"""
    score: dict[str, float] = {}
    meta: dict[str, tuple] = {}
    for t in terms(query):
        for cid, doc, page, text in conn.execute(
            "SELECT chunk_id, doc_id, page, text FROM chunks WHERE text LIKE ?",
            (f"%{t}%",),
        ):
            score[cid] = score.get(cid, 0) + len(t)  # 长词权重高——仅此而已
            meta[cid] = (doc, page, text)
    top = sorted(score, key=score.get, reverse=True)[:k]
    return [(cid, *meta[cid]) for cid in top]


# ---------------------------------------------------------------- 生成：抠数字句
def naive_answer(chunk_text: str) -> str:
    """从 top-1 块里抠第一个带数字的句子当答案；抠不到就硬返回开头
    60 字——**没有拒答路径**是 naive 管线的本体特征。"""
    for sent in re.split(r"[。；;\n]", chunk_text):
        if re.search(r"\d", sent) and len(sent.strip()) > 4:
            return sent.strip()
    return chunk_text[:60].strip() + "……"


# ---------------------------------------------------------------- 演示三题
DEMO = [
    (
        "海伦哲营收变动的主要原因",
        "失败① 检索失败（张冠李戴）",
        "真值句是海伦哲的「主要系……」；naive 没有公司/期间过滤，"
        "答成了中际旭创 2024 年报的现金流变动原因——公司、指标全错。",
        ["主要系"],
    ),
    (
        "欧科亿 2026 年半年度扣除非经常性损益的净利润",
        "失败② 口径失败（兄弟数冒充）",
        "真值 ≈ -1,914.72 万元（欧科亿扣非口径）；naive 连公司都没锁住，"
        "答成日联科技预告的同比增加数——检索、口径双失败。",
        ["-1,914", "1,914"],
    ),
    (
        "欧科亿 2030 年净利润预测",
        "失败③ 无据硬答（永不拒答）",
        "语料里没有 2030 年——Tally 期间守卫直接拒答；naive 没有拒答"
        "路径，硬抠了个公告头（证券代码 688308）当答案。",
        None,  # expect_refused
    ),
]


def main() -> None:
    db = sys.argv[sys.argv.index("--db") + 1] if "--db" in sys.argv else \
        os.environ.get("TALLY_DB", "tally.db")
    conn = sqlite3.connect(db)
    print(f"== naive_rag：没有闸门的检索直答（库：{db}）==\n")
    for query, label, why, expect in DEMO:
        hits = naive_retrieve(conn, query)
        print(f"Q：{query}\n   期望：{why}")
        if not hits:
            print("   检索：零命中（naive 仍会硬答——见下）")
            ans = "（无块可抠，返回空）"
            src = "—"
        else:
            for cid, doc, page, text in hits:
                prev = re.sub(r"\s+", " ", text)[:40]
                print(f"   检索：{doc} 第{page}页 …{prev}")
            cid, doc, page, text = hits[0]
            ans = naive_answer(text)
            src = f"{doc} 第{page}页"
        print(f"   回答：{ans}\n   出处：{src}   ←挂着出处，但没有任何东西校验它\n")
        if expect is None:
            print("   对照：Tally 对此题拒答（期间守卫）——naive 给了个数。\n")
        print("-" * 64 + "\n")


if __name__ == "__main__":
    main()
