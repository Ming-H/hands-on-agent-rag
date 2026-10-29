#!/usr/bin/env bash
# ch02：文件名契约拒收（三类垃圾身份）+ 空文档闸门
# 前提：export TALLY_DIR=/path/to/tally（已 pip install -r requirements.txt）
set -euo pipefail
cd "$TALLY_DIR"
python - <<'EOF'
from tally.ingest import parse_filename

# ① 纯数字主干（P0.5 事故形态：日期开头的外部分析 md）
try:
    parse_filename("/tmp/20261009_某公司分析.md")
    print("!! 未拒收——闸门失效")
except ValueError as e:
    print("OK 拒收:", e)

# ② 无主体财报名：期间解析对了、公司剥成空串（2026-10 闸门审计补的洞）
try:
    parse_filename("/tmp/2026年半年度报告.pdf")
    print("!! 未拒收——闸门失效")
except ValueError as e:
    print("OK 拒收:", e)

# ③ 兜底通道只收 md/txt：CJK 主干的非财报命名 PDF 不得拿 period='MD' 入库
try:
    parse_filename("/tmp/某公司分析.pdf")
    print("!! 未拒收——闸门失效")
except ValueError as e:
    print("OK 拒收:", e)

# ④ 空文档闸门：3 页全空白的 PDF，摄取出 0 块——显式拒收
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
