#!/usr/bin/env bash
# ch12：记忆三层的行为观察（实测 2026-10-22 修正版）
# 关键事实：eval 默认隔离 L1 台账（防把检索能力测成记忆命中）——
# 在 eval 外面设 TALLY_MEMORY 开关不改变 eval 行为（作者亲踩）；
# 台账命中与未命中的头行指标相同是设计使然：读不豁免，命中拼出的
# 答案内联过 verify，serve 的是同一个已过闸事实。
# 前提：export TALLY_DIR=/path/to/tally
set -euo pipefail
cd "$TALLY_DIR"

echo "== ① 常态 ask：L1 台账在工作（trace 见 memory:hit）=="
python -m tally.cli ask "海伦哲2026年一季度营业收入多少" --mode heuristic -v 2>&1 \
  | grep -o "memory:[a-z]*" | head -1

echo "== ② eval 默认隔离台账（同一数据集两次跑，指标一致）=="
python -m tally.cli eval --mode heuristic --dataset multiturn 2>&1 | tail -1
TALLY_EVAL_MEMORY=on python -m tally.cli eval --mode heuristic --dataset multiturn 2>&1 | tail -1
echo "→ 放开后 citation_coverage 变化（部分题走台账命中），answer_hit 不变——"
echo "   命中的是同一个已过闸事实；隔离的意义是防止检索指标被记忆命中测虚高"

echo "== ③ 记忆总闸关：回退无记忆行为（ask 不再有 memory 标记）=="
TALLY_MEMORY=off python -m tally.cli ask "海伦哲2026年一季度营业收入多少" \
  --mode heuristic -v 2>&1 | grep -o "memory:[a-z]*" | head -1 || echo "（无 memory 标记——台账已关）"

echo "== ④ 投毒复现（幕二）：假事实写入台账 → 读命中 → verify 拦 =="
python -m pytest tests/test_v07.py::test_poisoned_fact_read_not_exempt -q 2>&1 | tail -1
echo "→ 绕过写闸 SQL 注入 9,999,999,999.99 假事实，读路径命中它，"
echo "   verify 对账证据池拦下——记忆是加速器，不是后门（12.3）"
