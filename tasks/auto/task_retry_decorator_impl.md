---
id: task_retry_decorator_impl
name: Retry Decorator Implementation
category: coding
grading_type: automated
timeout_seconds: 180
workspace_files: []
---

# Retry Decorator Implementation

## Prompt

Write a Python module named `retry_utils.py` that provides a `retry` decorator with the following behavior:

1. Accept a parameter `max_attempts` (integer, number of tries including the first call)
2. On failure (exception), retry the wrapped function up to `max_attempts` times
3. Use exponential backoff between retries: sleep duration doubles each time (e.g. start with a base delay such as 0.1 or 1 second, then `sleep *= 2` or use `2 ** attempt`)
4. If all attempts fail, re-raise the last exception

Example usage shape:

```python
@retry(max_attempts=3)
def flaky():
    ...
```

## Expected Behavior

The agent should implement `retry_utils.py` containing a decorator factory named `retry` that:

1. Is defined as a function (`def retry`)
2. Accepts `max_attempts` (or equivalently named attempts parameter)
3. Calls `time.sleep` (or similar) between retries
4. Implements exponential backoff via `2 ** n`, `*= 2`, or equivalent doubling

## Grading Criteria

- [ ] File `retry_utils.py` exists
- [ ] File contains valid Python syntax
- [ ] Defines a `retry` function
- [ ] Accepts max_attempts or attempts parameter
- [ ] Uses sleep for backoff
- [ ] Implements exponential backoff (2** or *=2)

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import ast
    import re

    scores = {
        "file_exists": 0.0,
        "valid_python": 0.0,
        "defines_retry": 0.0,
        "attempts_param": 0.0,
        "uses_sleep": 0.0,
        "exponential_backoff": 0.0,
    }

    workspace = Path(workspace_path)
    script = workspace / "retry_utils.py"
    if not script.exists():
        return scores

    scores["file_exists"] = 1.0
    content = script.read_text(encoding="utf-8")

    try:
        tree = ast.parse(content)
        scores["valid_python"] = 1.0
    except SyntaxError:
        return scores

    func_names = {
        node.name for node in ast.walk(tree) if isinstance(node, ast.FunctionDef)
    }
    if "retry" in func_names:
        scores["defines_retry"] = 1.0

    if re.search(r"max_attempts|max_retries|attempts\s*=", content):
        scores["attempts_param"] = 1.0

    if re.search(r"time\.sleep|from\s+time\s+import\s+sleep|\bsleep\s*\(", content):
        scores["uses_sleep"] = 1.0

    if re.search(r"2\s*\*\*|<<=|\*=\s*2|delay\s*\*\s*2|backoff\s*\*\s*2", content):
        scores["exponential_backoff"] = 1.0

    return scores
```

## Additional Notes

- No workspace fixtures; agent creates the module from scratch.
- Grading is static (ast/re); the decorator is not executed against a flaky function.
