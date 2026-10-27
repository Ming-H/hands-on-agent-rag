#!/usr/bin/env bash
# ch07：★ 阈值两极端（0.0 无感 / 1.0 降级 93% 仍全对）
# 前提：export TALLY_DIR=/path/to/tally（已 pip install -r requirements.txt）
set -euo pipefail
cd "$TALLY_DIR"
cp tally/answer.py /tmp/answer.bak
for v in 0.45 0.0 1.0; do
  python - <<EOF
from pathlib import Path
import re
p = Path("tally/answer.py"); s = p.read_text()
p.write_text(re.sub(r"COVERAGE_THRESHOLD = [0-9.]+", "COVERAGE_THRESHOLD = $v", s))
EOF
  echo "== 阈值 $v =="
  python -m tally.cli eval --mode heuristic --dataset innolight 2>&1 | tail -1
done
cp /tmp/answer.bak tally/answer.py
echo "== 已还原 =="
