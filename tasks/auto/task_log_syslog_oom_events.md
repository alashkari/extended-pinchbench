---
id: task_log_syslog_oom_events
name: Syslog Authentication Failure Count
category: log_analysis
grading_type: automated
timeout_seconds: 180
workspace_files:
  - source: logs/linux_syslog.log
    dest: linux_syslog.log
---

## Prompt

Count case-insensitive occurrences of the phrase `authentication failure` in `linux_syslog.log`.

Write `auth_failure_count.json` with `authentication_failure_count`.

(Note: this log may not contain OOM killer events; focus on authentication failures.)

## Expected Behavior

Expected count is 1229.

## Grading Criteria

- [ ] File created
- [ ] authentication_failure_count is 1229

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import json
    scores = {"file_created": 0.0, "count": 0.0}
    path = Path(workspace_path) / "auth_failure_count.json"
    alts = list(Path(workspace_path).glob("*auth*fail*.json")) + list(Path(workspace_path).glob("*oom*.json"))
    if not path.exists() and alts:
        path = alts[0]
    if not path.exists():
        return scores
    scores["file_created"] = 1.0
    try:
        data = json.loads(path.read_text())
        c = int(data.get("authentication_failure_count") or data.get("count") or data.get("oom_count") or -1)
        scores["count"] = 1.0 if c == 1229 else (0.5 if abs(c-1229)<=10 else 0.0)
    except Exception:
        pass
    return scores

```
