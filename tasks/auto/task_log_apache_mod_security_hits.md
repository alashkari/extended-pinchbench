---
id: task_log_apache_mod_security_hits
name: Apache Missing File Errors
category: log_analysis
grading_type: automated
timeout_seconds: 180
workspace_files:
  - source: logs/apache_error.log
    dest: apache_error.log
---

## Prompt

Count occurrences of the exact phrase `File does not exist` in `apache_error.log`.

Write `missing_files.json` with `file_does_not_exist_count`.

## Expected Behavior

Expected count is 295.

## Grading Criteria

- [ ] File created
- [ ] file_does_not_exist_count is 295

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import json
    scores = {"file_created": 0.0, "count": 0.0}
    path = Path(workspace_path) / "missing_files.json"
    alts = list(Path(workspace_path).glob("*missing*.json")) + list(Path(workspace_path).glob("*mod*sec*.json"))
    if not path.exists() and alts:
        path = alts[0]
    if not path.exists():
        return scores
    scores["file_created"] = 1.0
    try:
        data = json.loads(path.read_text())
        c = int(data.get("file_does_not_exist_count") or data.get("count") or -1)
        scores["count"] = 1.0 if c == 295 else (0.5 if abs(c-295)<=5 else 0.0)
    except Exception:
        pass
    return scores

```
