---
id: task_fix_rate_limiter
name: Fix Rate Limiter Implementation
category: coding
grading_type: automated
timeout_seconds: 180
workspace_files: []
---

## Prompt

Create a Python module `rate_limiter.py` that implements a simple rate limiter.

Requirements:

1. Define a class named `RateLimiter`
2. `__init__(self, max_calls: int, period_seconds: float)` stores the limits
3. Method `allow(self) -> bool` returns True if a call is permitted under a token-bucket or sliding-window policy, otherwise False
4. Use the `time` module (e.g. `time.time()` or `time.monotonic()`) in the implementation

Do not need to handle concurrency. Focus on a clear, working single-threaded design.

## Expected Behavior

The agent should write `rate_limiter.py` with a `RateLimiter` class exposing `allow()`, using time-based tracking of recent calls or tokens.

## Grading Criteria

- [ ] File `rate_limiter.py` created
- [ ] File parses as valid Python
- [ ] Defines class `RateLimiter`
- [ ] Defines method `allow`
- [ ] Uses the `time` module
- [ ] `__init__` accepts max_calls / period style parameters

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import ast
    import re

    scores = {
        "file_created": 0.0,
        "valid_python": 0.0,
        "has_class": 0.0,
        "has_allow": 0.0,
        "uses_time": 0.0,
        "has_init_params": 0.0,
    }
    path = Path(workspace_path) / "rate_limiter.py"
    if not path.exists():
        return scores
    scores["file_created"] = 1.0
    content = path.read_text()
    try:
        tree = ast.parse(content)
        scores["valid_python"] = 1.0
    except SyntaxError:
        return scores

    scores["has_class"] = 1.0 if re.search(r"class\s+RateLimiter\b", content) else 0.0
    scores["has_allow"] = 1.0 if re.search(r"def\s+allow\s*\(", content) else 0.0
    scores["uses_time"] = 1.0 if re.search(r"(import\s+time|from\s+time\s+import|time\.(time|monotonic))", content) else 0.0
    scores["has_init_params"] = 1.0 if re.search(
        r"def\s+__init__\s*\(.*max_calls|def\s+__init__\s*\(.*period|def\s+__init__\s*\(.*rate|def\s+__init__\s*\(.*capacity",
        content,
    ) else 0.0
    return scores
```
