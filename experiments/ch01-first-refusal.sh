#!/usr/bin/env bash
# ch01：跑通 + 第一次被拒答（期间守卫）
# 前提：export TALLY_DIR=/path/to/tally（已 pip install -r requirements.txt）
set -euo pipefail
cd "$TALLY_DIR"
python -m tally.cli ingest samples/
python -m tally.cli ask "欧科亿 2026 年半年度预计净利润多少"
python -m tally.cli ask "欧科亿 2030 年净利润预测"
