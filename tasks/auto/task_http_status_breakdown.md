---
id: task_http_status_breakdown
name: HTTP Status Code Histogram
category: analysis
grading_type: automated
timeout_seconds: 180
workspace_files:
  - path: "access_snippet.log"
    content: |
      192.168.1.10 - - [10/Mar/2026:08:01:12 +0000] "GET /index.html HTTP/1.1" 200 1234
      192.168.1.11 - - [10/Mar/2026:08:01:15 +0000] "GET /api/users HTTP/1.1" 200 456
      192.168.1.12 - - [10/Mar/2026:08:01:18 +0000] "GET /missing HTTP/1.1" 404 89
      192.168.1.13 - - [10/Mar/2026:08:01:22 +0000] "POST /api/login HTTP/1.1" 401 32
      192.168.1.14 - - [10/Mar/2026:08:01:25 +0000] "GET /assets/app.js HTTP/1.1" 200 9981
      192.168.1.15 - - [10/Mar/2026:08:01:30 +0000] "GET /missing HTTP/1.1" 404 89
      192.168.1.16 - - [10/Mar/2026:08:01:33 +0000] "GET /health HTTP/1.1" 200 2
      192.168.1.17 - - [10/Mar/2026:08:01:40 +0000] "GET /api/boom HTTP/1.1" 500 120
      192.168.1.18 - - [10/Mar/2026:08:01:44 +0000] "GET /favicon.ico HTTP/1.1" 404 0
      192.168.1.19 - - [10/Mar/2026:08:01:50 +0000] "GET /index.html HTTP/1.1" 200 1234
---

## Prompt

Parse `access_snippet.log` (Combined Log Format). Extract the HTTP status code from each line and count occurrences.

Write `status_histogram.json` mapping status code → count:

```json
{
  "200": 5,
  "401": 1,
  "404": 3,
  "500": 1
}
```

Keys may be strings or integers. Counts must be exact.

## Expected Behavior

From the 10 log lines:

- 200 appears 5 times
- 401 appears 1 time
- 404 appears 3 times
- 500 appears 1 time

## Grading Criteria

- [ ] `status_histogram.json` created
- [ ] Valid JSON
- [ ] Count for 200 is 5
- [ ] Count for 404 is 3
- [ ] Count for 401 is 1
- [ ] Count for 500 is 1

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import json

    scores = {
        "file_created": 0.0,
        "valid_json": 0.0,
        "count_200": 0.0,
        "count_404": 0.0,
        "count_401": 0.0,
        "count_500": 0.0,
    }
    workspace = Path(workspace_path)
    path = workspace / "status_histogram.json"
    if not path.exists():
        return scores

    scores["file_created"] = 1.0
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except Exception:
        return scores

    if not isinstance(data, dict):
        return scores

    # Unwrap nesting
    for key in ("histogram", "status_histogram", "counts", "status"):
        if key in data and isinstance(data[key], dict):
            data = data[key]
            break

    scores["valid_json"] = 1.0

    def get_count(code):
        for k in (code, str(code), int(code) if str(code).isdigit() else code):
            if k in data:
                try:
                    return float(data[k])
                except (TypeError, ValueError):
                    return None
        return None

    expected = {"200": 5, "404": 3, "401": 1, "500": 1}
    key_map = {
        "200": "count_200",
        "404": "count_404",
        "401": "count_401",
        "500": "count_500",
    }
    for code, exp in expected.items():
        got = get_count(code)
        if got is not None and abs(got - exp) < 0.01:
            scores[key_map[code]] = 1.0
    return scores
```
