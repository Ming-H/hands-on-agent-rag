#!/usr/bin/env bash
# ch06：引用结构与漂移容忍（D13）
# 前提：export TALLY_DIR=/path/to/tally（已 pip install -r requirements.txt）
set -euo pipefail
cd "$TALLY_DIR"
python -m tally.cli ask "欧科亿 2026 年半年度预计净利润多少" --mode heuristic --json 2>/dev/null | python -c "import json,sys; st=json.load(sys.stdin); print('citations:', st['citations'])"
echo "== 空白归一：引用两侧加空格仍判在场 =="
python - <<'EOF'
from tally.answer import has_citation
from tally.schemas import Chunk, Retrieved
h = [Retrieved(chunk=Chunk(chunk_id="c1", doc_id="d_2026H1E", page=8, seq=0,
        text="净利润 41,922.46 万元。", is_table=False, num_notes=[]), score=.1, rank=1)]
print("粘连 True:", has_citation("净利 41,922.46 万元 [d_2026H1E第8页]", h))
print("加空格 True:", has_citation("净利 41,922.46 万元 [d_2026H1E 第 8 页]", h))
EOF
