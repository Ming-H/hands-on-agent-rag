# 动手学 Agentic RAG

<div class="tg-hero" markdown>

> **一本自足的 Agentic RAG 工程教程** · 案例载体：开源项目 [Tally](https://github.com/Ming-H/tally)

**每个答案都要能对账。**

这不是又一本「分块 → 向量库 → 生成」的 RAG 入门，也不是某个仓库的
源码精讲。本书按 Agent RAG 的知识体系组织——每章先是**可独立阅读的
原理**（失败模式、技术谱系、业界系统对比、设计原则），再把真实开源
项目 Tally 作为**案例研究**穿插进来。你要造的不是模型，是挽具
（harness）：**模型会换，闸门与评测沉淀。**

<div class="tg-badges" markdown>
**14 章** ｜ **16 个破坏性实验** ｜ **40 道真值题** ｜ 前半部零 key 可跑
</div>

</div>

<div class="tg-cards" markdown>

**第一部 · 全景**<br>
Agentic RAG 设计地图：四代谱系 · 三态出口 · 挽具立论<br>
→ [ch01 系统全景](ch01.md)

**第二部 · 语料与检索**<br>
摄取 · 切分 · 存储选型 · 词法与语义检索——构建证据层（五章）<br>
→ 从 [ch02 文档摄取](ch02.md) 到 ch05 ◆ 语料可检索

**第三部 · 生成与验证**<br>
引用契约 · 对账闸门 · 口径防线——答案有据可查（两章）<br>
→ 从 [ch06 生成与引用](ch06.md) ◆ 可信固定管线

**第四部 · Agent 架构**<br>
LLM 接入 · 路由 · 规划 · 工具循环 · 记忆——自主而不失控（五章）<br>
→ 从 [ch08 LLM 接入层](ch08.md) ◆ 四支柱齐备

**第五部 · 评测与可靠性**<br>
真值集 · CI 门槛 · 错误传播公理 · 系统总装——可度量才可控（两章）<br>
→ 从 [ch13 评测工程](ch13.md) ◆ 毕业设计

</div>

**教学签名：破坏性实验。** 每个设计决策都让你亲手拆一次、看指标
变坏、再装回去——第 1 章先造一个坏的（naive_rag 三类失败），第 14 章
带着[设计画布](appendix-f-design-canvas.md)造你自己的（毕业设计）。

## 阅读路径

| 路径 | 章 | 适合谁 |
|---|---|---|
| 通读 | ch01 → ch14 顺序 | 默认路径；每章实验跟着做 |
| RAG 面 | ch02–07 | 语料/检索/生成/验证一条龙，零 key 可跑全程 |
| Agent 面 | ch08–12 | 已有 RAG 基础，直奔四支柱 |
| 快线 | ch01 → 05 → 07 → 11 → 14 | 两小时搞懂这本书的主张 |

**先修**：会 Python、调过 LLM API、读过向量库 RAG。不讲什么是
embedding，讲你会在哪里撞墙。

## 开始

```bash
git clone https://github.com/Ming-H/tally.git && cd tally
pip install -r requirements.txt
python -m tally.cli ingest samples/
python -m tally.cli ask "欧科亿 2026 年半年度预计净利润多少"
```

先读 [前言](preface.md)（本书的写法），然后从 [第 1 章](ch01.md)
开始；术语速查见 [附录 A](appendix-a-glossary.md)，案例全量档案在
[附录 D](appendix-d-decisions.md)，毕业产物是
[附录 F 设计画布](appendix-f-design-canvas.md)。
