# 附录 D：决策记录索引（D1–D26）

Tally 的每个设计决策都有编号与原文（`docs/DESIGN-*.md`），这里给
速查索引——正文引用处以 D 编号溯源。

| 编号 | 主题 | 原文 |
|---|---|---|
| D1–D6 | Agentic 基础：LLM 上驾驶位、理解驱动检索、双脑纪律、纠错环 | DESIGN-v0.5 |
| D7 | Ollama 三通道实测（think 被忽略/软开关失效/thinking 饿死正文）| DESIGN-v0.5 |
| D8 | v0.5 收尾决策 | DESIGN-v0.5 |
| D9–D12 | Agent 环与小模型护栏（理解先验/证据轮转/预算上限）| DESIGN-v0.6 §2 |
| D13 | 引用匹配空白归一（小模型引用格式漂移）| DESIGN-v0.6 §7 |
| D14–D15 | innolight 真值修复批 | DESIGN-v0.6 §7 |
| D16 | stitch_adjacent 表块拼接（标签/数值分家）| DESIGN-v0.6 §7 |
| D17 | （v0.6 真值批）| DESIGN-v0.6 §7 |
| D18 | 裸年份默认 FY（期间过滤互斥匹配）| DESIGN-v0.6 §7 |
| D19 | **向量三路消融：净负，默认关** | DESIGN-v0.6 §8.3 |
| D20 | 简称双向子串归一（茅台→贵州茅台）| DESIGN-v0.6 §10 |
| D21 | 行级 trend 抽取 | DESIGN-v0.6 §10 |
| D22 | **口径数值闸**（gate≠correctness 第一处收口）| DESIGN-v0.6 §10 |
| D23–D25 | 边界知识沉淀 / trace 标记诚实性 / 工具参数简称归一（记录于 v0.6.5 源仓库线，断号说明见 DESIGN-v0.6 §13）| DESIGN-v0.6 §13 |
| D26 | Q3 双列行锚定（累计列）| v0.6.5 线 |

另有三条事故复盘（P1 幽灵块 / P2 页眉空格漂移 / P3 测试清库）在
`docs/EXPLAINER.md`——每条配一个永久回归测试名。
