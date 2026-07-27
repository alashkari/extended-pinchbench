---
id: task_log_nginx_top_paths
name: Nginx Top Request Paths
category: log_analysis
grading_type: automated
timeout_seconds: 180
workspace_files:
  - source: logs/nginx_access_json.log
    dest: nginx_access_json.log
---

## Prompt

Each line of `nginx_access_json.log` is JSON with a `request` field like `GET /path HTTP/1.1`.

Find the most common request path (strip query string; use the path token from `request`).

Write `top_paths.json` with `top_path` and `count`, plus optional `top5` list.

## Expected Behavior

Expected top path is `/downloads/product_2` with count 520.

## Grading Criteria

- [ ] File created
- [ ] top_path is /downloads/product_2
- [ ] count is 520

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import json
    scores = {"file_created": 0.0, "path": 0.0, "count": 0.0}
    path = Path(workspace_path) / "top_paths.json"
    if not path.exists():
        return scores
    scores["file_created"] = 1.0
    try:
        data = json.loads(path.read_text())
        tp = str(data.get("top_path") or data.get("path") or "")
        scores["path"] = 1.0 if tp.rstrip("/") == "/downloads/product_2" or tp.endswith("product_2") else 0.0
        c = int(data.get("count") or 0)
        scores["count"] = 1.0 if c == 520 else (0.5 if abs(c-520)<=10 else 0.0)
    except Exception:
        pass
    return scores

```
