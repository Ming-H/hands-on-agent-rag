#!/usr/bin/env bash
# ch10：多跳规划全链——子目标 → 只删不造校验 → 检查点 → 缺口声明
# 前提：export TALLY_DIR=/path/to/tally（规划节点是 llm 模式机制；
# 本脚本 ①②③ 全部确定性：①白盒信号 ②白盒检查点 ③heuristic 的 multihop 对照）
set -euo pipefail
cd "$TALLY_DIR"

echo "== ① 多跳信号白盒（三家/跨年 → 触发 plan；两家 → 不触发）=="
python - <<'EOF'
from tally.graph import _wants_plan
q3 = "对比欧科亿、海伦哲、日联科技 2025 和 2026 的营收和净利润"
u3 = {"companies": ["欧科亿", "海伦哲", "日联科技"]}
print("三家公司跨年：", "触发 plan" if _wants_plan(q3, u3) else "不触发（意外！）")
q2 = "对比欧科亿和海伦哲 2026 一季度谁赚得多"
u2 = {"companies": ["欧科亿", "海伦哲"]}
print("两家对比：  ", "触发 plan" if _wants_plan(q2, u2) else "不触发（走 decompose）")
EOF

echo "== ② 检查点白盒：数字在场 ∧ 指标词命中，缺一即不过 =="
python -m pytest tests/test_v07.py -k "plan or ckpt or validate" -q 2>&1 | tail -2

echo "== ③ 缺口声明对照：multihop 集（heuristic 确定性）=="
python -m tally.cli eval --mode heuristic --dataset multihop --json 2>/dev/null | \
  python -c "import json,sys; s=json.load(sys.stdin); print(
    f\"multihop: hit={s['answer_hit']} ret={s['retrieval_top3']} —— 多跳走 decompose+derive 确定性路径；\"
    f\"llm 模式下同一批题过 plan 节点，未覆盖子目标显式声明（10.4）\")"
