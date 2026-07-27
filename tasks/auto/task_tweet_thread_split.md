---
id: task_tweet_thread_split
name: Tweet Thread Split
category: writing
grading_type: automated
timeout_seconds: 120
workspace_files:
  - path: "long_post.txt"
    content: |
      Shipping observability developers actually use needs three non-negotiables: low-latency ingest, queryable high-cardinality tags, and dashboards that load in under two seconds. Last quarter we cut median query time from 4.8s to 1.1s by rewriting the hot path and adding columnar compression. The surprising win was deleting 37% of never-queried tags and teaching onboarding to pick the five labels that matter. If metrics noise is drowning you, measure which tags are read in production, kill the rest, and put a hard SLO on dashboard p95 load time. Share your before/after — we will spotlight the best teardown next week.
---

# Tweet Thread Split

## Prompt

Read `long_post.txt` (~600 characters) and split it into a Twitter/X thread. Save the result as `thread.json`: a JSON **array of strings**.

Requirements:

1. Each string must be ≤ **280** characters.
2. The array must have **at least 3** tweets (or tweets clearly numbered in content).
3. Preserve key phrases from the original, including mentions of **high-cardinality**, **1.1s** (or median query time improvement), and **37%** (or unused/never-queried tags).

## Expected Behavior

The agent should produce a JSON array like `["...", "...", "..."]` where each element is a tweet-sized chunk covering the original points about observability, query latency improvement, and tag pruning.

## Grading Criteria

- [ ] File `thread.json` is created and is a JSON array
- [ ] Array length is ≥ 3 (or numbered tweets present)
- [ ] Every tweet is ≤ 280 characters
- [ ] Covers key phrase: high-cardinality
- [ ] Covers key phrase: 1.1s / query time improvement
- [ ] Covers key phrase: 37% / unused tags

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import json
    import re

    scores = {
        "file_created": 0.0,
        "valid_array": 0.0,
        "length_or_numbered": 0.0,
        "each_within_280": 0.0,
        "covers_high_cardinality": 0.0,
        "covers_latency": 0.0,
        "covers_tag_pruning": 0.0,
    }

    workspace = Path(workspace_path)
    path = workspace / "thread.json"
    if not path.exists():
        return scores

    scores["file_created"] = 1.0

    try:
        data = json.loads(path.read_text(encoding="utf-8", errors="replace"))
    except (json.JSONDecodeError, Exception):
        return scores

    if not isinstance(data, list) or not data:
        return scores

    if not all(isinstance(x, str) for x in data):
        return scores

    scores["valid_array"] = 1.0

    joined = "\n".join(data)
    numbered = len(re.findall(r"(?m)^\s*\d+[\./:]|\b\d+/\d+\b", joined)) >= 3
    if len(data) >= 3 or numbered:
        scores["length_or_numbered"] = 1.0

    if all(len(t) <= 280 for t in data):
        scores["each_within_280"] = 1.0

    lower = joined.lower()
    if "high-cardinality" in lower or "high cardinality" in lower:
        scores["covers_high_cardinality"] = 1.0

    if "1.1s" in lower or "1.1 s" in lower or re.search(r"median query time|query time", lower):
        scores["covers_latency"] = 1.0

    if "37%" in joined or "never-queried" in lower or ("unused" in lower and "tag" in lower):
        scores["covers_tag_pruning"] = 1.0

    return scores
```

## Additional Notes

- Character limits and keyword coverage are graded; stylistic quality of the thread is not.
