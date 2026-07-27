---
id: task_log_nginx_peak_minute
name: Nginx Peak Request Minute
category: log_analysis
grading_type: automated
timeout_seconds: 180
workspace_files:
  - source: logs/nginx_access_json.log
    dest: nginx_access_json.log
---

## Prompt

Each JSON line has `time` like `17/May/2015:08:05:32 +0000`. Bucket requests by minute (`DD/Mon/YYYY:HH:MM`) and find the peak minute.

Write `peak_minute.json` with `minute` and `count`.

## Expected Behavior

Expected peak minute is `17/May/2015:15:05` with count 130.

## Grading Criteria

- [ ] File created
- [ ] minute is 17/May/2015:15:05
- [ ] count is 130

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import json
    scores = {"file_created": 0.0, "minute": 0.0, "count": 0.0}
    path = Path(workspace_path) / "peak_minute.json"
    if not path.exists():
        return scores
    scores["file_created"] = 1.0
    try:
        data = json.loads(path.read_text())
        m = str(data.get("minute") or data.get("peak_minute") or "")
        scores["minute"] = 1.0 if "17/May/2015:15:05" in m else 0.0
        c = int(data.get("count") or 0)
        scores["count"] = 1.0 if c == 130 else (0.5 if abs(c-130)<=5 else 0.0)
    except Exception:
        pass
    return scores

```
