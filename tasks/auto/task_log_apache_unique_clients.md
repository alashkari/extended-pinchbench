---
id: task_log_apache_unique_clients
name: Apache Unique Client IPs
category: log_analysis
grading_type: automated
timeout_seconds: 180
workspace_files:
  - source: logs/apache_error.log
    dest: apache_error.log
---

## Prompt

Analyze `apache_error.log` and count the number of unique client addresses appearing in `[client ...]` fields.

Write `unique_clients.json` with `unique_client_count`.

## Expected Behavior

Expected unique client count is 159.

## Grading Criteria

- [ ] File created
- [ ] unique_client_count is 159

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import json
    scores = {"file_created": 0.0, "count": 0.0}
    path = Path(workspace_path) / "unique_clients.json"
    if not path.exists():
        return scores
    scores["file_created"] = 1.0
    try:
        data = json.loads(path.read_text())
        c = int(data.get("unique_client_count") or data.get("count") or -1)
        scores["count"] = 1.0 if c == 159 else (0.5 if abs(c-159) <= 5 else 0.0)
    except Exception:
        pass
    return scores

```
