# 附录 C：Tally 代码地图

约 4,700 行源码 + 2,300 行测试。函数名是本书的引用锚点（行号随版本漂移，函数名稳定）。

**计数口径**：`tally/` 下全部 **14 个 `.py`**（含 `__init__.py` 包入口，
下表略）——ch01 总图与 ch14 总装走读用同一口径。

| 文件 | 行数 | 职责 | 本书章节 |
|---|---|---|---|
| `schemas.py` | 125 | 数据模型 + GraphState 窄接口 | ch9 |
| `source.py` | ~60 | 扫描与三态 diff；SHA-256 指纹 | ch2 |
| `ingest.py` | 269 | 文件名元数据/页眉剥离/表格分块/数字归一/查询扩展 | ch2, ch3, ch9 |
| `store.py` | 303 | **唯一写入口**：六表事务、fts rowid 对齐、vecs 级联 | ch4 |
| `index.py` | 98 | 分词原语 + 瘦身 Corpus | ch5 |
| `fts.py` | 139 | 双轨 FTS5 + RRF 融合 | ch5 |
| `embed.py` | 98 | 可选向量第三路（默认关，D19）| ch5 |
| `answer.py` | 272 | 抽取式生成、口径降权、引用覆盖率 verify | ch6, ch7 |
| `graph.py` | 2,367 | LangGraph 状态机：14 节点（understand 八守卫/route/plan/agent_research/trend/verify_citations…）| ch7, ch9–ch11 |
| `llm.py` | 290 | 多通道接入：判定/容错解析/工具消息归一化/thinking 分层 | ch8, ch11 |
| `memory.py` | 216 | L0 继承 / L1 台账五算子 / L2 资产 | ch12 |
| `evalx.py` | 204+ | judge 纯函数 / summarize / gate_failures | ch13 |
| `cli.py` | 309+ | ingest/ask/chat/eval/docs 命令；--min-* 门槛 | ch2, ch13 |
| `tests/` | ~2,300 | 135 用例：conftest 封网；agent/plan 白盒回放 | 全书实验 |

测试文件与本书实验的对应：`test_store.py`（ch4 两个事故测试）、
`test_duizhang.py`（ch9 守卫/ch10 plan/ch11 agent 五场景）、
`test_evalx.py`（ch13 judge 演进）、`test_v07.py`（ch12 记忆投毒/
写闸）、`test_llm.py`（ch8 通道与归一化）。
