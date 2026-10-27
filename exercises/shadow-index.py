#!/usr/bin/env python3
"""实现练习 ★★★（ch04）：影子索引维护——Store 铁律的微缩版。

任务：补全 ★ 标记的三处，守住唯一不变量：
  fts.rowid 与 chunks.rowid 永远对齐——任何路径下不产生幽灵块
  （索引里有、正文表里没有 = 幽灵；检索命中已删除内容，不报错）。

验收（跑本文件，四断言全过）：
  python3 exercises/shadow-index.py
"""
from __future__ import annotations

import sqlite3

SCHEMA = """
CREATE TABLE chunks(rowid INTEGER PRIMARY KEY, doc_id TEXT, t TEXT);
CREATE VIRTUAL TABLE fts USING fts5(c);
"""


class Shadow:
    def __init__(self, con: sqlite3.Connection) -> None:
        self.con = con
        con.executescript(SCHEMA)

    def add_chunk(self, doc_id: str, text: str) -> int:
        """★ 补全：chunks 与 fts 同 rowid 双写。返回 rowid。"""
        raise NotImplementedError

    def drop_chunk(self, rowid: int) -> None:
        """★ 补全：双清——fts 行与 chunks 行一起删，不留幽灵。"""
        raise NotImplementedError

    def reingest(self, doc_id: str, texts: list[str]) -> None:
        """★ 补全：同 doc 重灌 = drop-then-insert，包在同一个事务里
        （with self.con:）。想想 P1 事故：drop 与 insert 分属两个事务
        时，中间崩溃会发生什么（4.6 第一轮的雷）。"""
        raise NotImplementedError

    def search(self, q: str) -> list[tuple]:
        return self.con.execute(
            "SELECT rowid FROM fts WHERE fts MATCH ?", (q,)).fetchall()


def _main() -> None:
    sh = Shadow(sqlite3.connect(":memory:"))
    r1 = sh.add_chunk("A_2025FY", "营业收入 520,053,589.94")
    assert sh.search("营业收入") == [(r1,)], "新增应对齐"
    sh.drop_chunk(r1)
    assert sh.search("营业收入") == [], "删除应双清（无幽灵）"
    sh.add_chunk("A_2025FY", "旧内容")
    sh.reingest("A_2025FY", ["新内容 甲"])
    hits = sh.search("新内容")
    live = {r for (r,) in hits
            if sh.con.execute("SELECT 1 FROM chunks WHERE rowid=?", (r,)).fetchone()}
    assert len(hits) == len(live) == 1, "重灌无幽灵：每个 fts 命中都有活块"
    print("4/4 断言通过——影子索引维护完成。对照 store.py: add_doc 圈事务的手法。")


if __name__ == "__main__":
    _main()
