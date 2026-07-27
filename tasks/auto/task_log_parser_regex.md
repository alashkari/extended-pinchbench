---
id: task_log_parser_regex
name: Log Parser with Regex
category: coding
grading_type: automated
timeout_seconds: 240
workspace_files:
  - path: "sample.log"
    content: |
      192.168.1.10 - - [27/Jul/2026:10:15:32 +0000] "GET /index.html HTTP/1.1" 200 1234
      10.0.0.5 - - [27/Jul/2026:10:16:01 +0000] "POST /api/login HTTP/1.1" 401 89
      203.0.113.42 - - [27/Jul/2026:10:16:45 +0000] "GET /assets/app.js HTTP/1.1" 304 0
      192.168.1.10 - - [27/Jul/2026:10:17:12 +0000] "GET /missing HTTP/1.1" 404 210
---

# Log Parser with Regex

## Prompt

The workspace contains `sample.log` with Apache/Nginx-style access log lines.

Write `parse_logs.py` that:

1. Reads `sample.log`
2. Parses each line to extract `ip`, `status`, and `path` using regular expressions (`re`)
3. Writes `parsed.json` containing a JSON list of objects, each shaped like `{"ip": "...", "status": ..., "path": "..."}`

Example output element: `{"ip": "192.168.1.10", "status": 200, "path": "/index.html"}`

## Expected Behavior

The agent should create `parse_logs.py` that uses `re` to extract IP address, HTTP status code, and request path, then dump a list of dicts to `parsed.json` via the `json` module.

## Grading Criteria

- [ ] File `parse_logs.py` exists
- [ ] File contains valid Python syntax
- [ ] Uses the `re` module
- [ ] Has regex patterns for IP and status
- [ ] Writes or dumps JSON (json.dump / dumps)
- [ ] References `parsed.json` or creates that output

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
        "uses_re": 0.0,
        "ip_and_status_patterns": 0.0,
        "json_dump": 0.0,
        "output_or_parsed_ref": 0.0,
    }

    workspace = Path(workspace_path)
    script = workspace / "parse_logs.py"
    if not script.exists():
        return scores

    scores["script_exists"] = 1.0
    content = script.read_text(encoding="utf-8")

    try:
        ast.parse(content)
        scores["valid_python"] = 1.0
    except SyntaxError:
        return scores

    if re.search(r"import\s+re|from\s+re\s+import", content):
        scores["uses_re"] = 1.0

    has_ip = bool(
        re.search(
            r"\\d\{1,3\}(?:\\.\\d\{1,3\})\{3\}|\\d\+\\.\\d\+\\.\\d\+\\.\\d\+|ip",
            content,
            re.IGNORECASE,
        )
    )
    has_status = bool(
        re.search(r"\\d\{3\}|status", content, re.IGNORECASE)
    )
    if has_ip and has_status:
        scores["ip_and_status_patterns"] = 1.0
    elif has_ip or has_status:
        scores["ip_and_status_patterns"] = 0.5

    if re.search(r"json\.dump|json\.dumps", content):
        scores["json_dump"] = 1.0

    parsed = workspace / "parsed.json"
    if parsed.exists():
        try:
            data = json.loads(parsed.read_text(encoding="utf-8"))
            if isinstance(data, list) and data and all(
                isinstance(x, dict) and {"ip", "status", "path"} <= set(x.keys())
                for x in data
            ):
                scores["output_or_parsed_ref"] = 1.0
            else:
                scores["output_or_parsed_ref"] = 0.5
        except Exception:
            scores["output_or_parsed_ref"] = 0.25
    elif re.search(r"parsed\.json", content):
        scores["output_or_parsed_ref"] = 0.75

    return scores
```

## Additional Notes

- Prefer grading script content for `re` patterns and `json.dump`; output file is a bonus if the agent ran the script.
- Four sample log lines cover 200, 401, 304, and 404 statuses.
