# 动手学 Agent RAG

> 一本自足的 Agentic RAG 工程教程 · 14 章 · 16 个破坏性实验 · 40 道真值题
> 案例载体：开源项目 [Tally](https://github.com/Ming-H/tally)

**每个答案都要能对账。**

这不是又一本「分块 → 向量库 → 生成」的 RAG 入门，也不是某个仓库
的源码精讲。本书按 Agent RAG 的知识体系组织——语料与检索、生成
与验证、LLM 接入与四支柱（规划/工具/记忆/路由）、评测与可靠性
——每章先是**可独立阅读的原理**（失败模式、技术谱系、业界系统
对比、设计原则），再把真实开源项目 Tally 作为**案例研究**穿插
进来。你要造的不是模型，是挽具（harness）：模型会换，闸门与
评测沉淀。

```
第一部分 全景          Agentic RAG 设计地图：四代谱系/三态出口/挽具立论 （ch1）
第二部分 语料与检索    摄取/切分/存储/检索——构建证据层            （ch2–5）
第三部分 生成与验证    引用/对账闸门/口径防线——答案有据可查       （ch6–7）
第四部分 Agent 架构    LLM 接入/路由/规划/工具/记忆——自主不失控   （ch8–12）
第五部分 评测与可靠性  真值集/CI 门槛/错误传播/总装——可度量才可控 （ch13–14）
```

**教学签名：破坏性实验。**每个设计决策都让你亲手拆一次、看指标
变坏、再装回去——第 1 章先造一个坏的（naive_rag 三类失败），第
14 章带着设计画布造你自己的（毕业设计）。

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
