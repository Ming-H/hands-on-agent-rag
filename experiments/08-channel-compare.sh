#!/usr/bin/env bash
# ch08：三档通道同 eval 对比（正确率 × 延迟；有 key 时可加成本列）
# 前提：export TALLY_DIR=/path/to/tally；可选 .env 配好远端通道
# 通道缺席时自动跳过（本地 Ollama 没起 / 没有 key 都不报错）
set -uo pipefail
cd "$TALLY_DIR"

run_channel() {  # run_channel <档名> <模式>
    local name="$1" mode="$2" out
    out=$(python -m tally.cli eval --mode "$mode" --json 2>/dev/null) || {
        echo "| $name | （通道不可用，跳过） | — | — |"; return; }
    python -c "
import json
s = json.loads('''$out''')
print(f\"| $name | {s['answer_hit']} / {s['retrieval_top3']} | cov={s['mean_coverage']} |\")" \
    || echo "| $name | （解析失败） | — | — |"
}

echo "== 三档通道对比：default 集（answer_hit / retrieval@3 / coverage）=="
echo "| 档位 | hit/ret | cov |"
echo "|---|---|---|"
run_channel "heuristic（规则脑基线）" heuristic
run_channel "llm 本地/远端（按 .env）" llm

echo
echo "== 延迟体感（单问 -v，两档各一问）=="
python -m tally.cli ask "欧科亿 2026 年半年度预计净利润多少" -v 2>&1 | grep -E "^trace" | tail -1 || true
echo "（llm 档同问自跑：把上面命令加 --mode llm；远端尾延迟 20s+ 属实测预期）"
