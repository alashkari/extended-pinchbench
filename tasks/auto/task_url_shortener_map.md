---
id: task_url_shortener_map
name: URL Shortener Map
category: coding
grading_type: automated
timeout_seconds: 180
workspace_files: []
---

# URL Shortener Map

## Prompt

Implement an in-memory URL shortener in Python:

1. Create `shortener.py` with:
   - `shorten(url: str) -> str` — store the URL and return a short code
   - `expand(code: str) -> str` — return the original URL for a code
   - Use a dictionary (dict) as the backing store
2. Create `test_shortener.py` that imports from `shortener` and exercises both functions (assert or print-based checks are fine)

Codes may be generated however you like (hash, counter, random string) as long as `expand(shorten(url))` returns the original URL.

## Expected Behavior

The agent should:

1. Write `shortener.py` with `shorten` and `expand` functions backed by a dict
2. Write `test_shortener.py` that imports the shortener module and calls both functions
3. Keep the mapping in memory (no database required)

## Grading Criteria

- [ ] File `shortener.py` exists
- [ ] File `test_shortener.py` exists
- [ ] `shortener.py` is valid Python
- [ ] Defines `shorten` function
- [ ] Defines `expand` function
- [ ] Uses a dict for storage
- [ ] Test file imports shortener

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import ast
    import re

    scores = {
        "shortener_exists": 0.0,
        "test_exists": 0.0,
        "valid_python": 0.0,
        "has_shorten": 0.0,
        "has_expand": 0.0,
        "uses_dict": 0.0,
        "test_imports_shortener": 0.0,
    }

    workspace = Path(workspace_path)
    shortener = workspace / "shortener.py"
    test_file = workspace / "test_shortener.py"

    if shortener.exists():
        scores["shortener_exists"] = 1.0
    if test_file.exists():
        scores["test_exists"] = 1.0

    if not shortener.exists():
        return scores

    content = shortener.read_text(encoding="utf-8")
    try:
        tree = ast.parse(content)
        scores["valid_python"] = 1.0
    except SyntaxError:
        return scores

    func_names = {
        node.name for node in ast.walk(tree) if isinstance(node, ast.FunctionDef)
    }
    if "shorten" in func_names:
        scores["has_shorten"] = 1.0
    if "expand" in func_names:
        scores["has_expand"] = 1.0

    if re.search(r"\{\}|dict\s*\(|Dict\[|= \{\}", content) or re.search(
        r"\bdict\b", content
    ):
        scores["uses_dict"] = 1.0

    if test_file.exists():
        test_content = test_file.read_text(encoding="utf-8")
        if re.search(
            r"import\s+shortener|from\s+shortener\s+import", test_content
        ):
            scores["test_imports_shortener"] = 1.0

    return scores
```

## Additional Notes

- Both production and test modules are required.
- Dict may be module-level or encapsulated in a class; graders look for dict usage patterns.
