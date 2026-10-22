#!/usr/bin/env bash
# ch11：L0 继承链开关对比（multiturn 10 轮）
# 前提：export TALLY_DIR=/path/to/tally（已 pip install -r requirements.txt）
set -euo pipefail
cd "$TALLY_DIR"
echo "== 记忆开（默认）=="
python -m tally.cli eval --mode heuristic --dataset multiturn 2>&1 | tail -1
echo "== 记忆关（裸追问断链）=="
TALLY_MEMORY=off python -m tally.cli eval --mode heuristic --dataset multiturn 2>&1 | tail -1
