#!/usr/bin/env bash
# ch14：亲跑边界样本（gate ≠ correctness 活体）
# 前提：export TALLY_DIR=/path/to/tally（已 pip install -r requirements.txt）
set -euo pipefail
cd "$TALLY_DIR"
echo "== 边界账本样本（详见 DESIGN-v0.6 §9 与教程 ch13）=="
python -m tally.cli ask "中际旭创 2025 年第一季度扣非净利润是多少" --mode heuristic 2>/dev/null | head -4
echo "== 读边界账本原文 =="
sed -n '/## 9. 已知边界/,+12p' docs/DESIGN-v0.6.md
