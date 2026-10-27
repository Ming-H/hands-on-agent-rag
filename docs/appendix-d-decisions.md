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

## 案例研究全量档案（正文压缩后的完整版收录）

> v0.6 起正文案例研究只留决策与数字，全量表与全文收纳于此。

### D-1 八守卫全表（graph.py: understand，第 9 章）

| # | 守卫 | 防的事故（实测）| 动作 |
|---|---|---|---|
| 1 | 趋势守卫 | 趋势问句判成 summary（单文档残渣）| summary→trend |
| 2 | 公司漏检 | compare 漏抽一家（多跳退化单查）| 规则子串结果补全 |
| 3 | 公司纠偏 | 抽出语料外幻觉公司 | 回退规则名单 |
| 4 | 意图守卫 | 「哪家赚得多」判 metric | ≥2 公司+对比词→compare |
| 5 | 期间覆盖 | 「半年度」抽成 FY（年报洪水）| 规则非空即覆盖 |
| 6 | trend 必要条件 | 「预计…多少」幻觉成 trend | 无趋势词降级 |
| 7 | 对称升级 | 单季差分题进 agent 环全灭（模型自己差不出 Q4=FY−Q3）| 规则判 trend 则升级 |
| 8 | 股价/涨跌拒答 | 拿财报数字答行情 | 归 other 拒答 |

### D-2 UNDERSTAND_PROMPT 全文（graph.py，模型实际收到）

```text
你是财报问答系统的查询理解器。从用户问题抽取 JSON：
{"intent":"metric|summary|compare|other",
 "companies":["公司名"],"period":"H1|Q1|Q3|FY|","reason":"一句话"}

规则：
companies 原样取自问题中的公司名（没有则空数组）；
period 按财报日历（一季度/一季报/Q1→Q1，半年度/中报/二季度→H1，
  三季→Q3，年度/年报/四季度→FY，仅提年份不提期间
  （如「2025 年营收」）也算 FY，未提及则空串）；
intent：
  metric   = 问具体数字/指标/事实/原因/归因（需要检索证据句）
  trend    = 跨期趋势/多期对比；问投资建议也归 trend
  summary  = 要整体概览/总结全篇
  compare  = 对比多家公司
  other    = 闲聊或超纲

注意「XX变动的原因」是 metric 不是 summary，
「最近几个季度的趋势」是 trend 不是 summary。
```

四要点：枚举白名单写进 prompt；口语映射表明说；边界反例钉最易
混处；失败抛 ValueError 退规则。

### D-3 五层口径防线全表与六对降权注释（第 7 章）

| 层 | 位置 | 防什么 | 代价 |
|---|---|---|---|
| ① stitch_adjacent 拼块 | 检索后 | 标签与数值分家 | 块变长 |
| ② 行级抽取+标签上下文 | trend pick | 「指标词后第一个大数」+前邻 20 字口径检查 | —— |
| ③ 配对口径降权 ×6 对 | answer.py | 问 X 时同胞指标 Y 的句子 ×0.3 | 规则维护 |
| ④ caliber_mismatch 数值闸 | graph.py（D22）| 问具名口径→大数必须在该口径标签行 | 误杀风险 |
| ⑤ forbid_keywords | evals/*.json | 评测层反向断言 | —— |

六对降权注释节选（注释即实测档案）：

```python
# tally/answer.py（节选）
# ① 问扣非：无「扣除/扣非」的净利润句是归母口径（茅台 2026H1 实测
#    445.17 亿散文句顶掉 44,464,207,646.01）
if (("扣非" in q_raw or "扣除非" in q_raw)
        and "净利润" in s and "扣除" not in s and "扣非" not in s):
    score *= 0.3
# ③ 问总收入：营业收入句是子口径不是总口径（真值 92,278,072,083.21
#    被营业收入行冒充，2026H1 p30）
if "总收入" in q_raw and "营业收入" in s and "总收入" not in s:
    score *= 0.3
```

设计取舍：降权不跳过（×0.3 而非 continue——双口径问句仍要看到
对方）；注释带实测数字（删规则前先跑注释里的案例）。

### D-4 抽取式打分四权重（answer.py，第 6 章）

```python
# extractive_answer（打分核心，节选）
overlap = len(q & stoks)                    # ① 查询 token 重叠；零重叠句出局
score = overlap * (1.4 if has_num else 1.0) + (0.2 if h.chunk.num_notes else 0.0)
# ② 数字句优先 ×1.4：财报问答多在问数字（条目序号要求 ≥2 位或小数）
if not has_num and any(w in state["query"] for w in ("多少", "几")):
    score *= 0.3
# ③ 数字问句下无数字句强降权：表头行词面完美却无值
# ④ 配对口径降权（见 D-3）
```

四个权重每条都是一次实测翻车后加的；抽取式不是「抄 top1」，是
带领域知识的打分器——「丑但真」却准的原因。

### D-5 事故档案（P1–P3）

| 事故 | 现象 | 根因 | 永久测试 |
|---|---|---|---|
| P1 幽灵块 | 重摄取后检索仍命中旧页眉块 | INSERT OR REPLACE 换 rowid，旧 fts 行没人清；首轮修复的两个事务间还有崩溃窗口 | test_readd_after_drop_no_ghost / test_add_doc_failure_is_atomic |
| P2 页眉空格漂移 | 页眉剥离对部分页失效 | PDF 抽取空格逐页漂移，逐字比对失效 | 归一化剥空白+数字（EXPLAINER）|
| P3 测试清库 | 测试跑完真实库被清 | 共享 DB 路径 | conftest 隔离 + TALLY_DB 纪律 |
