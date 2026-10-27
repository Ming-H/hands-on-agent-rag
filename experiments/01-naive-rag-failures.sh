#!/usr/bin/env bash
# ch01：先造坏——naive 检索直答亲手跑出三类失败，再与 Tally 同题对照
# 前提：export TALLY_DIR=/path/to/tally（已 pip install -r requirements.txt，且已 ingest samples/）
set -euo pipefail
cd "$TALLY_DIR"

echo "== ① naive_rag：没有闸门的检索直答（三类失败）=="
python3 "$OLDPWD/experiments/naive_rag.py" --db tally.db || \
python3 "$(dirname "$0")/naive_rag.py" --db tally.db

echo "== ② 同题对照：Tally 怎么答 =="
python -m tally.cli ask "欧科亿 2030 年净利润预测"          # 期间守卫拒答
python -m tally.cli ask "欧科亿 2026 年半年度扣除非经常性损益的净利润"  # 逐句带引用
