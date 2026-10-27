#!/usr/bin/env bash
# ch09：守卫链 trace + 白盒测试
# 前提：export TALLY_DIR=/path/to/tally（已 pip install -r requirements.txt）
set -euo pipefail
cd "$TALLY_DIR"
echo "== -v 看 understand/route =="
python -m tally.cli ask "欧科亿和海伦哲 2026 一季度哪家赚得多" --mode heuristic -v 2>&1 | grep -E "understand|route" | head -3
echo "== 白盒：假 LLM 回错期间，规则守卫纠正 =="
python -m pytest tests/test_duizhang.py -k "understand_period_override" -q
