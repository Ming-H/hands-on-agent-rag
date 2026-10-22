#!/usr/bin/env bash
# ch10：ReAct 步级观测（只读；远端通道预期 agent:fallback——见 DESIGN-v0.7 §8）
# 前提：export TALLY_DIR=/path/to/tally
set -euo pipefail
cd "$TALLY_DIR"
echo "== llm 模式 -v 读 agent 步级（本地通道=四元组；远端=fallback，都是有效观察）=="
python -m tally.cli ask "对比欧科亿和海伦哲 2026 一季度谁赚得多" --mode llm -v 2>&1 | grep -E "agent|verify" | head -4
echo "== 白盒回放五场景（零成本验证护栏）=="
python -m pytest tests/test_duizhang.py -k "agent" -q
