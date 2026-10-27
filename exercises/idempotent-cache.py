#!/usr/bin/env python3
"""实现练习 ★★★（ch11）：幂等缓存骨架——agent 环护栏第一件。

任务：补全 ★ 标记的两处。对照 tally/graph.py: agent_research 的
seen 字典（生产实现），回答章末两问：
  ① key() 的去重键该含什么、不该含什么？（提示：同一工具同一参数
    = 同一观测——键之外的字段变了算重复吗？）
  ② 重复调用为什么要回「缓存 + 一句话」而不是静默回缓存？

验收（跑本文件，三断言全过）：
  python3 exercises/idempotent-cache.py
"""
from __future__ import annotations


class Seen:
    """幂等缓存：同 (tool, args) 二次调用不触达工具函数。"""

    def __init__(self) -> None:
        self._cache: dict[str, str] = {}
        self.tool_calls = 0          # 工具真实触达计数（验收用）

    def key(self, tool: str, args: dict) -> str:
        """★ 补全：规范化参数并生成去重键。
        要求：args 的键序不该影响判定（{"a":1,"b":2} 与 {"b":2,"a":1}
        是同一次调用）。提示：json.dumps 的 sort_keys 参数。"""
        raise NotImplementedError

    def call(self, tool: str, args: dict, run) -> str:
        """查缓存 → 未命中则真调工具；命中则回缓存 + 换角度提示。"""
        k = self.key(tool, args)
        if k in self._cache:
            # ★ 补全：返回缓存观测 + 「（重复检索：结果同上。请换检索
            # 角度或停止调用工具。）」——想想为什么不是静默回缓存。
            raise NotImplementedError
        self.tool_calls += 1
        self._cache[k] = run(args)
        return self._cache[k]


def _main() -> None:
    seen = Seen()
    fake_search = lambda a: f"[{a['company']} {a['period']}] 3 hits"   # noqa: E731

    a1 = seen.call("search", {"company": "欧科亿", "period": "Q1"}, fake_search)
    a2 = seen.call("search", {"period": "Q1", "company": "欧科亿"}, fake_search)  # 键序不同
    assert seen.tool_calls == 1, "同参数（键序不同）二次调用不应触达工具"
    assert "重复" in a2, "重复调用应带换角度提示"
    seen.call("search", {"company": "海伦哲", "period": "Q1"}, fake_search)
    assert seen.tool_calls == 2, "不同参数应真实触达"
    print("3/3 断言通过——幂等缓存骨架完成。对照 graph.py 回答两问。")


if __name__ == "__main__":
    _main()
