# 动手学 Agent RAG

[![Deploy Pages](https://github.com/Ming-H/hands-on-agent-rag/actions/workflows/deploy.yml/badge.svg)](https://github.com/Ming-H/hands-on-agent-rag/actions/workflows/deploy.yml)
[![Site](https://img.shields.io/badge/site-ming--h.github.io-brown.svg)](https://ming-h.github.io/hands-on-agent-rag/)

> 基于开源项目 [Tally](https://github.com/Ming-H/tally) 的证据式问答系统教程
> —— 14 章 · 16 个破坏性实验 · 40 道真值题

**每个答案都要能对账。** 这不是又一本「分块 → 向量库 → 生成」的 RAG 入门：
本教程按 Agent RAG 知识体系组织（语料与检索/生成与验证/Agent 四支柱/评测与可靠性），以开源项目 Tally 为贯穿案例，带你走完
PDF 语料 → 双轨检索 → 对账闸门 → Agent 四支柱 → 评测体系的完整链路——
**每个设计决策，都让你亲手把它拆掉一次、亲眼看指标变坏，再装回去。**

## 读者契约

读完你能：

1. 说清每个环节的选型依据和被否决的备选（26 个决策记录 D1–D26）；
2. 在真实仓库上做「破坏性实验」，验证每个护栏的必要性；
3. 把这套评测与护栏方法论搬到你自己的 RAG 项目上。

**先修**：会 Python、调过 LLM API、做过（或读过）向量库 RAG——我们不讲
什么是 embedding，我们讲「你会在哪里撞墙」。

## 目录

| 部分 | 章 | 主题 |
|---|---|---|
| 全景 | 1 | 系统全景：从 RAG 到 Agentic RAG（naive_rag 先造坏）|
| 语料与检索 | 2 | 文档摄取：从原始文件到可信语料 |
| 语料与检索 | 3 | 文本切分：语义单元与表格保全 |
| 语料与检索 | 4 | 存储与索引：选型方法与工程不变量 |
| 语料与检索 | 5 | 检索设计：词法、语义与 RRF 融合 ◆ 语料可检索 |
| 生成与验证 | 6 | 生成与引用：让每个答案可对账 |
| 生成与验证 | 7 | 出口验证：三态闸门与口径防线 ★ 灵魂章 ◆ 固定管线 |
| Agent 架构 | 8 | LLM 接入层：模型选型与多通道适配 |
| Agent 架构 | 9 | 查询理解与路由：LLM 提议，规则裁决 |
| Agent 架构 | 10 | 任务规划：多跳分解与只删不造 |
| Agent 架构 | 11 | 工具调用与 Agent 循环：护栏工程（含注入面失败卡）|
| Agent 架构 | 12 | 记忆系统：三层设计与读写闸门 ◆ Agent 完全体 |
| 评测与可靠性 | 13 | 评测工程：真值集、LLM 裁判与 CI 门槛（三种假绿）|
| 评测与可靠性 | 14 | 可靠性与系统总装：错误传播、安全失败与设计迁移 ◆ 毕业 |

## 如何使用本教程

```bash
# 1. clone 代码仓库（教程的实验场）
git clone https://github.com/Ming-H/tally.git && cd tally
pip install -r requirements.txt
python -m tally.cli ingest samples/          # 30 秒跑起来

# 2. 按章阅读本教程，每章末的「破坏性实验」在 tally 仓库里做
```

教程只贴**关键代码片段**（文件名 + 函数名锚定），完整代码以 Tally
仓库为准（锁定 v0.7+ tag）。所有实验结果被 Tally 的 CI 与 40 道
人工核对真值题锁死——**人人可复现**。

## 进度

- [x] **v0.7 深度版**：每章 X.1 深度讲解（机制/一手论文实测数字/代码级模式——短期记忆三方式、ANN 一族、AIS 判定等级、MCP 架构、置信区间、0.95²⁰ 账本）+ 案例研究回归真实代码段（写闸/守卫/词法双轨/验证骨架/归一化）——全书 3168 行
- [x] **v0.6 知识主体化**：每章四段模板（X.1 问题与原理 / X.2 案例研究 / X.3 动手 / 收尾）——知识段自足可脱离仓库阅读，Tally 降为贯穿案例；全量档案（八守卫/prompt 全文/五层防线/打分权重）移附录 D；动效架构图按作者裁定全部移除
- [x] **v0.5 结构重排：五部 14 章**（13→14：Agent 面 2 章扩成 5 章——LLM 接入/路由/规划/工具/记忆各一章；验证+口径合并为三态闸门章；全章三栏模板「知识点/本项目/动手」+ 迁移盒/失败卡/分级练习；naive_rag.py 先造坏开篇；「挽具」立论贯穿 ch1→ch13→ch14）
- [x] **实验脚本 16 个**（留 5 / 移改 8 / 新增 3：01-naive-rag-failures、08-channel-compare、10-plan-checkpoint；新 naive_rag 与幽灵块复现与 plan 白盒已在作者机实测跑通）
- [x] **实现练习骨架 ×2**（exercises/：影子索引维护 ★★★、幂等缓存 ★★★）+ 附录 F《Agentic RAG 设计画布》（14 格毕业产物）+ 附录 G《从原型到生产》
- [x] 关键实验实测坐实（沿用 v0.3 验证 + 新增实测）：ch03 表格崩塌（innolight 1.0→0.778）/ ch07 阈值两极端 / ch12 记忆隔离 + 投毒 / ch13 门槛通电 / naive_rag 三类失败（张冠李戴/兄弟数冒充/无据硬答）
- [x] mkdocs `--strict` 构建零警告（mermaid 支持接入）；LICENSE（CC BY-SA 4.0）
- [x] 前沿知识配层沿用（五完整节 ch05/07/11/12/14）+ 附录 E 五部分组重排；出处全部一手核实
- [ ] 三章试水发布（ch01/05/07）+ 掘金/知乎连载
- [ ] GitHub Pages 部署 + 防漂移 CI 启用（schedule 打开）

## License

- 教程文本：CC BY-SA 4.0
- 所引 Tally 代码：MIT（见 [tally](https://github.com/Ming-H/tally) 仓库）