---
id: task_log_ssh_geo_like_ip_groups
name: SSH Top Source IP
category: log_analysis
grading_type: automated
timeout_seconds: 180
workspace_files:
  - source: logs/openssh_auth.log
    dest: openssh_auth.log
---

## Prompt

From `openssh_auth.log`, extract IPv4 addresses appearing after `from ` and find the most frequent source IP.

Write `top_source_ip.json` with `ip` and `count`.

## Expected Behavior

Expected top IP is 183.62.140.253 with count 307.

## Grading Criteria

- [ ] File created
- [ ] ip is 183.62.140.253
- [ ] count is 307

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import json
    scores = {"file_created": 0.0, "ip": 0.0, "count": 0.0}
    path = Path(workspace_path) / "top_source_ip.json"
    if not path.exists():
        return scores
    scores["file_created"] = 1.0
    try:
        data = json.loads(path.read_text())
        scores["ip"] = 1.0 if str(data.get("ip") or "") == "183.62.140.253" else 0.0
        c = int(data.get("count") or 0)
        scores["count"] = 1.0 if c == 307 else (0.5 if abs(c-307)<=5 else 0.0)
    except Exception:
        pass
    return scores

```
