#!/usr/bin/env bash
# ch05 破坏性实验：复现 D19 向量三路消融（教程核心实验）
# 前提：tally 仓库已 clone、双语料已 ingest（见教程 ch01/ch05）
# 预期：双轨 1.00 vs 三路 0.833–0.926（DESIGN-v0.6 §8.3 原始数据）
set -euo pipefail
cd "${TALLY_DIR:?请先 export TALLY_DIR=/path/to/tally}"

echo "== 基线：词法双轨 =="
python -m tally.cli eval --mode heuristic --dataset innolight \
  --min-retrieval 1.0 --min-hit 1.0

echo "== 安装向量依赖并嵌入 =="
pip install -r requirements-vec.txt
python -m tally.cli embed

echo "== 三路（TALLY_VEC=on）重跑 =="
TALLY_VEC=on python -m tally.cli eval --mode heuristic --dataset innolight

echo "对比 answer_hit：低于 1.0 的降幅即向量轨挤掉精确命中的净负贡献。"
echo "（若过闸失败属预期——这就是 D19 默认关闭向量的实测依据。）"
