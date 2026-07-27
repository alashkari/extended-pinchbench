---
id: task_log_ssh_root_attempts
name: SSH Failed Root Password Attempts
category: log_analysis
grading_type: automated
timeout_seconds: 180
workspace_files:
  - source: logs/openssh_auth.log
    dest: openssh_auth.log
---

## Prompt

Count lines in `openssh_auth.log` matching failed password attempts for root (`Failed password for root`).

Write `root_attempts.json` with `failed_root_password_count`.

## Expected Behavior

Expected count is 231.

## Grading Criteria

- [ ] File created
- [ ] failed_root_password_count is 231

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import json
    scores = {"file_created": 0.0, "count": 0.0}
    path = Path(workspace_path) / "root_attempts.json"
    if not path.exists():
        return scores
    scores["file_created"] = 1.0
    try:
        data = json.loads(path.read_text())
        c = int(data.get("failed_root_password_count") or data.get("count") or -1)
        scores["count"] = 1.0 if c == 231 else (0.5 if abs(c-231)<=5 else 0.0)
    except Exception:
        pass
    return scores

```
