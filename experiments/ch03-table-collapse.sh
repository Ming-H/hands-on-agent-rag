#!/usr/bin/env bash
# ch03：★ 关闭表格感知，表格重语料崩塌（实测 1.0→0.778）
# 前提：export TALLY_DIR=/path/to/tally（已 pip install -r requirements.txt）
set -euo pipefail
cd "$TALLY_DIR"
cp tally/ingest.py /tmp/ingest.bak
python - <<'EOF'
from pathlib import Path
p = Path("tally/ingest.py"); s = p.read_text()
s = s.replace("""def _is_table_line(line: str) -> bool:
    s = line.strip()""", """def _is_table_line(line: str) -> bool:
    return False  # ch03 破坏性实验
    s = line.strip()""")
p.write_text(s)
EOF
rm -f /tmp/ch03.db /tmp/ch03.db-wal /tmp/ch03.db-shm
TALLY_DB=/tmp/ch03.db python -m tally.cli ingest samples/
TALLY_DB=/tmp/ch03.db python -m tally.cli ingest data/中际旭创
echo "== 关闭表格感知（innolight 31 题；基线 1.0/1.0）=="
set +e
TALLY_DB=/tmp/ch03.db python -m tally.cli eval --mode heuristic --dataset innolight --min-retrieval 1.0 --min-hit 1.0
rc=$?
set -e
echo "exit=${rc}（预期 1：门槛拦住退化）"
cp /tmp/ingest.bak tally/ingest.py
rm -f /tmp/ch03.db /tmp/ch03.db-wal /tmp/ch03.db-shm
echo "== 已还原 =="
