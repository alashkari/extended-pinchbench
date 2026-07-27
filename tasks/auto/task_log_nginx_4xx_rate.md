---
id: task_log_nginx_4xx_rate
name: Nginx 4xx Error Rate
category: log_analysis
grading_type: automated
timeout_seconds: 180
workspace_files:
  - source: logs/nginx_access_json.log
    dest: nginx_access_json.log
---

## Prompt

Using `nginx_access_json.log`, compute the percentage of requests whose `response` status is in the 4xx range (400–499).

Write `fourxx_rate.json` with `fourxx_count`, `total`, and `rate_pct`.

## Expected Behavior

Expected: 690 of 1000 requests are 4xx → 69.0%.

## Grading Criteria

- [ ] File created
- [ ] fourxx_count is 690
- [ ] total is 1000
- [ ] rate_pct approximately 69

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import json
    scores = {k: 0.0 for k in ["file_created","fourxx","total","rate"]}
    path = Path(workspace_path) / "fourxx_rate.json"
    if not path.exists():
        return scores
    scores["file_created"] = 1.0
    try:
        data = json.loads(path.read_text())
        scores["fourxx"] = 1.0 if int(data.get("fourxx_count") or data.get("count") or 0) == 690 else 0.0
        scores["total"] = 1.0 if int(data.get("total") or 0) == 1000 else 0.0
        rate = float(data.get("rate_pct") or data.get("rate") or -1)
        scores["rate"] = 1.0 if abs(rate - 69.0) < 0.5 else (0.5 if abs(rate-69)<2 else 0.0)
    except Exception:
        pass
    return scores

```
