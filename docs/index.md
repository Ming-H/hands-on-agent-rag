# 动手学 Agent RAG

> 基于开源项目 [Tally](https://github.com/Ming-H/tally) 的证据式问答系统教程
> —— 13 章 · 13 个破坏性实验 · 40 道真值题

**每个答案都要能对账。**

这不是又一本「分块 → 向量库 → 生成」的 RAG 入门。本教程以一个真实
开源项目（Tally，中文财报事实 Agent）为唯一载体，带你走完：

```
第一部 知识入库    PDF 怎么变成可检索的证据        （ch1–5）
第二部 求证闸门    答案凭什么出门                  （ch6–9）
第三部 Agent 化    ReAct / Planner / Memory 四支柱 （ch10–11）
第四部 诚实        评测体系与边界账本              （ch12–13）
```

**教学签名：破坏性实验。** 每个设计决策，都让你亲手把它拆掉一次、
亲眼看 eval 指标变坏，再装回去——护栏的必要性不是听来的，是撞出来的。

**先修**：会 Python、调过 LLM API、读过向量库 RAG。我们不讲什么是
embedding，我们讲你会在哪里撞墙。

## 开始

```bash
git clone https://github.com/Ming-H/tally.git && cd tally
pip install -r requirements.txt
python -m tally.cli ingest samples/
python -m tally.cli ask "欧科亿 2026 年半年度预计净利润多少"
```

然后从 [第 1 章](ch01.md) 开始。
