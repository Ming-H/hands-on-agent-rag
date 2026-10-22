# 附录 B：环境与通道配置

## 安装

```bash
git clone https://github.com/Ming-H/tally.git && cd tally
python 3.12 -m venv venv && source venv/bin/activate   # 或 uv venv
pip install -r requirements.txt        # 精确复现已测环境用 requirements.lock.txt
python -m tally.cli ingest samples/    # 30 秒验证装好了
```

## LLM 三档通道（`.env`，已 gitignore）

| 档位 | 端点 | 需要 | 说明 |
|---|---|---|---|
| 0（默认）| `http://localhost:11434/v1` | Ollama ≥0.40 + pull 模型 | 零 key 零费用零外呼；**ReAct 工具环仅此档生效** |
| 1 | 任意 OpenAI 兼容端点 | `TALLY_LLM_API_KEY` + `TALLY_LLM_BASE_URL` | 智谱/deepseek/gpt 等 |
| 2 | Anthropic 兼容端点 | 同上 | thinking 计入 max_tokens → 预算 ×8 |

```bash
cp .env.example .env    # 按注释填三行即可切档；本地档连 .env 都不需要
```

## 环境变量全表

| 变量 | 默认 | 说明 |
|---|---|---|
| `TALLY_LLM_API_KEY` | 空 | 只放 `.env`；本地端点免 key |
| `TALLY_LLM_BASE_URL` | localhost:11434 | 通道识别 |
| `TALLY_LLM_MODEL` | qwen3.5:0.8b | 档位不绑假设——换大档叙述上移，闸门兜底不变 |
| `TALLY_LLM_MAX_TOKENS` | 按档位 | 生成预算 |
| `TALLY_LLM_THINKING` | disabled | 仅影响生成；结构化调用永远关 |
| `TALLY_DB` | ./tally.db | SQLite 库路径（测试/实验用 /tmp 隔离！）|
| `TALLY_TREND_ANALYSIS` | 未设=叙述开 | 三态：双闸兜底 / enabled 深度分析 / off 骨架直出 |
| `TALLY_SELF_CHECK` | 开 | trend 叙述的 LLM 裁判（非对称信任：只能否决）|
| `TALLY_VEC` | 关 | 向量第三路（需 requirements-vec.txt + embed）|
| `TALLY_MEMORY` | 开 | 三层记忆总闸 |
| `TALLY_EVAL_MEMORY` | 隔离 | eval 内默认隔离台账，`on` 显式放开（ch11 详述）|

## 常见问题

- **测试把真实库清了？** 用 `TALLY_DB=/tmp/xxx.db` 隔离（Tally 的
  P3 事故就是这么来的——任何会写持久状态的代码，测试必须显式隔离）。
- **远端通道 agent:fallback？** 正常：`chat_with_tools` 仅本地通道
  （ch10），远端 metric/compare 自动走固定管线兜底，答案无损。
- **改了代码指标变了？** 跑 `python -m tally.cli eval --mode heuristic`
  对照基线（auto 模式在本地 Ollama 在线时会悄悄走 llm 加方差）。
