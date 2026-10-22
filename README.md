# 动手学 Agent RAG

[![Deploy Pages](https://github.com/Ming-H/hands-on-agent-rag/actions/workflows/deploy.yml/badge.svg)](https://github.com/Ming-H/hands-on-agent-rag/actions/workflows/deploy.yml)
[![Site](https://img.shields.io/badge/site-ming--h.github.io-brown.svg)](https://ming-h.github.io/hands-on-agent-rag/)

> 基于开源项目 [Tally](https://github.com/Ming-H/tally) 的证据式问答系统教程
> —— 13 章 · 13 个破坏性实验 · 40 道真值题

**每个答案都要能对账。** 这不是又一本「分块 → 向量库 → 生成」的 RAG 入门：
本教程以一个真实开源项目（Tally，财报事实 Agent）为唯一载体，带你走完
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

| 部 | 章 | 主题 |
|---|---|---|
| 一 | 1 | 开篇：为什么你的 RAG Demo 上不了线 |
| 一 | 2 | PDF → 大模型可读的内容：元数据契约 / 页眉剥离 / 扫描版拒收 |
| 一 | 3 | 切分：表格感知分块——毁掉证据的 N 种方式 |
| 一 | 4 | 存储选型：SQLite FTS5 vs 向量库 vs ES |
| 一 | 5 | 检索：双轨 FTS + RRF，以及「要不要 embedding」 |
| 二 | 6 | 查询理解与路由：LLM 当大脑、规则当防线 |
| 二 | 7 | 生成与引用：grounded generation |
| 二 | 8 | 对账闸门：verify / 降级 / 拒答 ★ 灵魂章 |
| 二 | 9 | 口径守卫：问扣非为什么不能答归母 |
| 三 | 10 | ReAct 工具环：白名单 / 步级观测 / 重复收手 |
| 三 | 11 | Planner 与 Memory：只删不造 / 三层记忆 |
| 四 | 12 | 评测即测试：真值集 / 陷阱题 / CI 门槛 |
| 四 | 13 | 边界账本：系统管不住什么 + 可靠性公理 |

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

- [x] 全 13 章 **v0.3 加厚版**（约 12 万字：每章导读框/代码逐段走读/RRF 手算实例/八守卫全表/抽取式打分走读/小结与分层习题；49 处核实引用）
- [x] **实验脚本 13 个，12 个已在本机跑通验证**（ch01–ch04/ch06–ch13；ch05 为讲解型实验——嵌入耗内存大，不在作者机重跑，数字引 DESIGN-v0.6 §8.3 D19 实测存档）
- [x] **关键实验实测坐实**：ch03 表格崩塌（innolight 1.0→0.778）/ ch08 阈值两极端（0.0 潜伏无感、1.0 降级 93% 仍全对）/ ch11 记忆隔离真相（eval 默认强制隔离；命中指标不变=读不豁免的设计结果）/ ch12 门槛通电（exit=1 + 失败题点名）——真数字全部写回章节
- [x] mkdocs `--strict` 构建零警告；LICENSE（CC BY-SA 4.0）
- [ ] 三章试水发布（ch01/05/08）+ 掘金/知乎连载
- [ ] GitHub Pages 部署 + 防漂移 CI 启用（schedule 打开）

## License

- 教程文本：CC BY-SA 4.0
- 所引 Tally 代码：MIT（见 [tally](https://github.com/Ming-H/tally) 仓库）
