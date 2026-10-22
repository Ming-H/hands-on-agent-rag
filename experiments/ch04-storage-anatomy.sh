#!/usr/bin/env bash
# ch04：六表 schema + 索引与查询计划
# 前提：export TALLY_DIR=/path/to/tally（已 pip install -r requirements.txt）
set -euo pipefail
cd "$TALLY_DIR"
sqlite3 tally.db ".schema chunks" | head -8
echo "== 索引命中（预期 SEARCH ... USING INDEX idx_chunks_doc）=="
sqlite3 tally.db "EXPLAIN QUERY PLAN SELECT chunk_id FROM chunks WHERE doc_id='欧科亿_2026H1E';"
