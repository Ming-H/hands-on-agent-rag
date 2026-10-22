#!/usr/bin/env bash
# ch12：★ 门槛通电——毁整组关键词触发 exit=1（实测）
# 前提：export TALLY_DIR=/path/to/tally（已 pip install -r requirements.txt）
set -euo pipefail
cd "$TALLY_DIR"
cp evals/dataset.json /tmp/ds.bak
python - <<'EOF'
import json
from pathlib import Path
p = Path("evals/dataset.json")
data = json.loads(p.read_text())
data[0]["expect_keywords"] = ["__被改坏的真值__"]
p.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n")
EOF
set +e
python -m tally.cli eval --mode heuristic --dataset default --min-hit 1.0 > /tmp/gate_out.txt 2>&1
rc=$?
set -e
echo "exit=$rc（预期 1）"
grep -m1 -A2 "门槛未过" /tmp/gate_out.txt || true
cp /tmp/ds.bak evals/dataset.json
python -m tally.cli eval --mode heuristic --dataset default --min-hit 1.0 > /dev/null 2>&1 && echo "还原后 exit=0 OK"
