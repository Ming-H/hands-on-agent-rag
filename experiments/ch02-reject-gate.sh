#!/usr/bin/env bash
# ch02：文件名契约拒收 + 空文档闸门
# 前提：export TALLY_DIR=/path/to/tally（已 pip install -r requirements.txt）
set -euo pipefail
cd "$TALLY_DIR"
python - <<'EOF'
from tally.ingest import parse_filename
try:
    parse_filename("/tmp/20261009_某公司分析.md")
    print("!! 未拒收——闸门失效")
except ValueError as e:
    print("OK 拒收:", e)
from pypdf import PdfWriter
w = PdfWriter()
for _ in range(3):
    w.add_blank_page(width=595, height=842)
w.write("/tmp/空壳公司_2025年年度报告.pdf")
from tally.ingest import ingest_file
try:
    ingest_file("/tmp/空壳公司_2025年年度报告.pdf")
    print("!! 未拒收——闸门失效")
except ValueError as e:
    print("OK 拒收:", e)
EOF
