#!/usr/bin/env bash
# ch09：口径防线——问扣非不含归母数
# 前提：export TALLY_DIR=/path/to/tally（已 pip install -r requirements.txt）
set -euo pipefail
cd "$TALLY_DIR"
A=$(python -m tally.cli ask "中际旭创 2025 年一季度扣除非经常性损益后的净利润多少" --mode heuristic 2>/dev/null)
echo "$A" | head -3
echo "$A" | grep -q "1,568,385,287" && echo "OK 含扣非真值"
if echo "$A" | grep -q "1,582,876,128"; then echo "FAIL 含归母姊妹数（防线失效）"; else echo "OK 不含归母姊妹数"; fi
