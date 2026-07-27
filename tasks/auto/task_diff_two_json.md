---
id: task_diff_two_json
name: Diff Two JSON Files
category: coding
grading_type: automated
timeout_seconds: 240
workspace_files:
  - path: "a.json"
    content: |
      {
        "shared": "old-value",
        "only_a": 1,
        "nested": {"keep": true, "flip": false}
      }
  - path: "b.json"
    content: |
      {
        "shared": "new-value",
        "only_b": 2,
        "nested": {"keep": true, "flip": true}
      }
---

# Diff Two JSON Files

## Prompt

The workspace contains `a.json` and `b.json`.

Write `diff_json.py` that compares the two files (top-level keys are enough; nested diffs are a bonus) and writes `diff_report.json` with at least these keys:

- `added`: keys present in `b.json` but not in `a.json` (expect `only_b`)
- `removed`: keys present in `a.json` but not in `b.json` (expect `only_a`)
- `changed`: keys present in both whose values differ (expect `shared`, and possibly `nested`)

You may represent `added`/`removed`/`changed` as lists of key names or richer objects. Run the script so `diff_report.json` is produced.

## Expected Behavior

The agent should:

1. Create `diff_json.py`
2. Load both JSON files
3. Compute added / removed / changed key sets
4. Write `diff_report.json`
5. Ideally run the script so the report exists with the expected keys for these fixtures

## Grading Criteria

- [ ] File `diff_json.py` exists
- [ ] File contains valid Python syntax
- [ ] Script references `a.json` and `b.json`
- [ ] Script writes or references `diff_report.json`
- [ ] Mentions added/removed/changed
- [ ] Report file has expected keys when present (`only_a` removed, `only_b` added, `shared` changed)

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import ast
    import re
    import json

    scores = {
        "script_exists": 0.0,
        "valid_python": 0.0,
        "references_inputs": 0.0,
        "references_report": 0.0,
        "mentions_diff_keys": 0.0,
        "report_expected_keys": 0.0,
    }

    workspace = Path(workspace_path)
    script = workspace / "diff_json.py"
    if not script.exists():
        return scores

    scores["script_exists"] = 1.0
    content = script.read_text(encoding="utf-8")

    try:
        ast.parse(content)
        scores["valid_python"] = 1.0
    except SyntaxError:
        return scores

    if re.search(r"a\.json", content) and re.search(r"b\.json", content):
        scores["references_inputs"] = 1.0

    if re.search(r"diff_report\.json", content):
        scores["references_report"] = 1.0

    if re.search(r"added", content, re.IGNORECASE) and re.search(
        r"removed", content, re.IGNORECASE
    ) and re.search(r"changed", content, re.IGNORECASE):
        scores["mentions_diff_keys"] = 1.0

    report = workspace / "diff_report.json"
    if report.exists():
        try:
            data = json.loads(report.read_text(encoding="utf-8"))
            blob = json.dumps(data)
            has_added = "only_b" in blob
            has_removed = "only_a" in blob
            has_changed = "shared" in blob
            if has_added and has_removed and has_changed:
                scores["report_expected_keys"] = 1.0
            elif has_added or has_removed or has_changed:
                scores["report_expected_keys"] = 0.5
        except Exception:
            scores["report_expected_keys"] = 0.0

    return scores
```

## Additional Notes

- Fixtures: `a` has `only_a`; `b` has `only_b`; both have `shared` with different values; `nested.flip` also differs.
- Partial credit if the report exists but is incomplete.
