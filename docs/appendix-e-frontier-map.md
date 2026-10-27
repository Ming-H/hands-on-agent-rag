# 附录 E 业界前沿地图

> 这不是必读正文，是毕业后的按图索骥页：你想在某个机制上继续
> 深入时，先在这里找到它的**业界学名**与**一手出处**，再决定读
> 什么、做什么。所有出处经一手核实（论文给 arXiv/官方页，工程
> 给官方博客）；「继续做的方向」接 tally 的 roadmap。汇总口径：
> 各章知识点栏 + 五处完整前沿节（ch05/07/11/12/14）。

## E.1 全景与语料（ch01–ch05）

| Tally 锚点 | 业界术语 | 一手出处 | 继续做的方向 |
|---|---|---|---|
| 整个系统 | **agentic RAG**（2024–25 共识词条；护栏是定义性特征） | [Weaviate 定义](https://weaviate.io/blog/what-is-agentic-rag) · [LangChain](https://www.langchain.com/blog/agentic-rag-with-langgraph) | —— |
| 三态出口 / 拒答 | **abstention**（拒答优先） | [SQuAD 2.0](https://arxiv.org/abs/1806.03822) | 拒答文案质量评测 |
| 文件名元数据契约 | metadata-first ingestion（身份字段确定性来源） | [Unstructured](https://unstructured.io) · [LlamaIndex readers](https://docs.llamaindex.ai) | 新版式语料的契约扩展 |
| `num_notes` 数字注释 / `stitch_adjacent` | **Contextual Retrieval**（给块补上下文；top-20 失败率 5.7%→1.9%） | [Anthropic 2024](https://www.anthropic.com/research/contextual-retrieval) | 按需给高风险块生成上下文（成本/幻觉面评估） |
| 表格感知分块 | structure-aware chunking | [Unstructured 实践](https://unstructured.io/blog/chunking-for-rag-best-practices) · [Late Chunking](https://arxiv.org/abs/2409.04701) | 列头继承的通用化 |
| FTS5 六表 / 单写入口 | ——（工程实践，无 canonical 论文） | [SQLite FTS5](https://www.sqlite.org/fts5.html) | —— |
| 双轨 + RRF(k=60) | **hybrid retrieval + Reciprocal Rank Fusion** | [RRF, SIGIR'09](https://dl.acm.org/doi/10.1145/1571941.1572114)（不在 arXiv） · [Kuzi et al.](https://arxiv.org/abs/2010.01195) | —— |
| D19 向量消融（默认关） | **BM25 稳健基线**（精确匹配任务上词法胜稠密） | [BEIR, NeurIPS'21](https://arxiv.org/abs/2104.08663) | 向量轨只给语义问法开（roadmap 留的口子） |
| `ranking()` 空位 | **cross-encoder rerank**（召回→融合→精排） | [Cohere Rerank](https://docs.cohere.com/docs/rerank-overview) · [bge-reranker](https://github.com/FlagOpen/FlagEmbedding) | **roadmap 第一项**：实验设计见 ch05 §5.7 |
| （未采用）GraphRAG | 实体图谱 + 社区摘要（local/global 查询） | [arXiv:2404.16130](https://arxiv.org/abs/2404.16130) | 语料无硬结构时再考虑 |

## E.2 生成与验证（ch06–ch07）

| Tally 锚点 | 业界术语 | 一手出处 | 继续做的方向 |
|---|---|---|---|
| `page_evidence` 首命中页 ±2 | **sentence-window / small-to-big** | [LlamaIndex](https://developers.llamaindex.ai/python/examples/node_postprocessor/metadatareplacementdemo) | 窗口大小按语料版式实测 |
| 句级内联引用 | **Attributed QA**（答案+逐字引文） | [arXiv:2212.08037](https://arxiv.org/abs/2212.08037) · [AIS](https://arxiv.org/abs/2112.12870) · [ALCE](https://arxiv.org/abs/2305.14627) | —— |
| `verify_citations`（生成后自检） | 引用 grounding 的**平台侧**形态 | [Anthropic Citations API](https://platform.claude.com/docs/en/build-with-claude/citations) | API 版与自检版互补，不互替 |
| `citation_coverage` / `chunk P/R@8` | 无参考评估（faithfulness / context P-R） | [RAGAS](https://arxiv.org/abs/2309.15217) | RAGAS 式 NLI 当离线诊断（ch07 §7.8） |
| 口径五层闸 | ——（结构守卫，工程实践无 canonical 论文；BEIR 解释为什么需要） | [BEIR](https://arxiv.org/abs/2104.08663) + tally D22 实测 | 新口径家族 = 一条规则一道题 |
| guardrails 分层（事实 vs 话题） | guardrails 中间件 | [Llama Guard](https://arxiv.org/abs/2312.06674) · NeMo Guardrails | ——（互补不互替） |

## E.3 Agent 架构（ch08–ch12）

| Tally 锚点 | 业界术语 | 一手出处 | 继续做的方向 |
|---|---|---|---|
| `llm.py` 多通道（base_url 判定） | **OpenAI 兼容协议 = 事实标准** | [vLLM](https://arxiv.org/abs/2309.06180) · [Ollama](https://ollama.com) | Anthropic tool_use 接通（v1.1 挑战题，ch11） |
| `chat_json` 解析失败退规则 | **受限解码**（保证从 prompt 移进解码器） | [Ollama structured outputs](https://docs.ollama.com/capabilities/structured-outputs) · [vLLM](https://docs.vllm.ai/en/latest/features/structured_outputs) | 接 `format` 参数，消灭解析失败层 |
| understand 结构化抽取 + 守卫 | **Adaptive-RAG**（按复杂度分流） | [arXiv:2403.14403](https://arxiv.org/abs/2403.14403) | 复杂度信号增维 |
| grade ⇄ rewrite（有界 ≤1） | **CRAG / Self-RAG**（grade-and-retry） | [CRAG](https://arxiv.org/abs/2401.15884) · [Self-RAG](https://arxiv.org/abs/2310.11511) | ——（有界是刻意的） |
| `agent_research` 循环 | **ReAct**；Anthropic agent loop | [arXiv:2210.03629](https://arxiv.org/abs/2210.03629) · [Building Effective Agents](https://www.anthropic.com/engineering/building-effective-agents) | —— |
| 护栏四件套 | 工具设计三原则的运行时版 | [Anthropic define-tools](https://platform.claude.com/docs/en/agents-and-tools/tool-use/define-tools) · [OpenAI function calling](https://developers.openai.com/api/docs/guides/function-calling) | 工具描述重写实验（量尺 waste_rate，ch11 §11.9） |
| 注入面地图 | 间接提示注入（OWASP LLM Top 10） | [OWASP](https://genai.owasp.org/llm-top-10/) | 记忆写闸是深防御主通道（ch11 §11.6） |
| trend 不进 agent 环 | **workflows over agents** | [Building Effective Agents](https://www.anthropic.com/engineering/building-effective-agents) | —— |
| `plan` 节点 + 只删不造 | **Plan-and-Execute / Plan-and-Solve / ReWoo**；orchestrator-workers | [arXiv:2305.04091](https://arxiv.org/abs/2305.04091) · [ReWoo](https://arxiv.org/abs/2310.18389) · [LangChain](https://www.langchain.com/blog/plan-and-execute-agents) | 跨期对比分解（roadmap） |
| L0 轮摘要 | 记忆流 + 反思（generative agents） | [arXiv:2304.03442](https://arxiv.org/abs/2304.03442) | ——（只继承结构化字段是刻意的） |
| L1 键寻址台账 | 长期记忆分层（semantic/episodic/procedural） | [MemGPT](https://arxiv.org/abs/2310.08560)（→Letta） · [Mem0](https://mem0.ai) · [Zep](https://www.getzep.com) · [LangGraph memory](https://docs.langchain.com/oss/python/concepts/memory) · [Anthropic memory tool](https://platform.claude.com/docs/en/agents-and-tools/tool-use/memory-tool) | `cli facts` 审计视图（ch12 §12.2） |
| （明确不收）Reflexion | 跨试次语言自我改进 | [arXiv:2303.11366](https://arxiv.org/abs/2303.11366) | 不收——相关性风险（ch12 §12.2） |

## E.4 评测与可靠性（ch13–ch14）

| Tally 锚点 | 业界术语 | 一手出处 | 继续做的方向 |
|---|---|---|---|
| evalx | **评测 harness 四件套**（任务集+适配器+指标+可复跑） | [lm-evaluation-harness](https://github.com/EleutherAI/lm-evaluation-harness) · [HELM](https://crfm.stanford.edu/helm/) · [SWE-bench](https://arxiv.org/abs/2310.06770) | runs.jsonl 轨迹持久化 |
| 七指标真值集 | 无参考 vs 有参考评估的取舍 | [RAGAS](https://arxiv.org/abs/2309.15217) · [Hamel Husain, Evals](https://hamel.dev) | 语义 faithfulness 当离线诊断 |
| `_self_check` 非对称信任 | **LLM-as-judge** 偏差（位置/冗长/自增强） | [MT-Bench](https://arxiv.org/abs/2306.05685) | ——（veto-only 是刻意的） |
| eₖ·gₖ 公理 | **compounding errors** / 逐级不确定度传播 | [SAUP, ACL'25](https://arxiv.org/abs/2412.01033) · [Building Effective Agents](https://www.anthropic.com/engineering/building-effective-agents) | eₖ/gₖ 表按动作类型聚合进 CI（ch14 §14.7） |
| 四杠杆 | 多智能体失败分类学 | [MAST](https://arxiv.org/abs/2503.13657) | 14 类自查表（ch14 §14.7） |
| 事故 → D 记录 → 永久测试 | postmortem 文化 | [SRE Book](https://sre.google/sre-book/postmortem-culture/) | —— |

## E.5 业界共识与 Tally 的四个分歧

业界共识（agentic RAG 的定义性特征之一就是护栏）与 Tally 的
**刻意分歧**——改动这四条之前，先读对应的实测：

| 分歧 | 业界默认 | Tally 的选择 | 实测依据 |
|---|---|---|---|
| 向量检索 | dense 或 hybrid 默认开 | **默认关**（`TALLY_VEC` opt-in） | D19 消融：数字/口径任务词法双轨饱和、向量净负；BEIR 同现象 |
| 可自主的环节 | 能 agent 则 agent | **trend 确定性遍历**，永不进环 | 小模型自遍历漏期/循环（实测）；错误复利警告 |
| 质量守门 | LLM judge 可改写/解锁 | **确定性闸门在前，judge 只能否决** | MT-Bench 偏差清单；非对称信任 |
| 重试与自主 | 模型自定停 | **有界**（rewrite ≤1 / 步 ≤6 / 修复 ≤1） | 无界重试是状态机反模式 |

一句话：**分歧不是落后，是被实测押注的不同取舍**——每一条都
有数字在 DESIGN 文档里等着被挑战。
