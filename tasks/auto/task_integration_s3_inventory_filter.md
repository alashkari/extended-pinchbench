---
id: task_integration_s3_inventory_filter
name: S3 Inventory Prefix Filter
category: integrations
grading_type: automated
timeout_seconds: 180
workspace_files:
  - path: "inventory.csv"
    content: |
      bucket,key,size,storage_class
      my-logs,logs/2026/01/app.log.gz,1200,STANDARD
      my-logs,logs/2025/12/app.log.gz,1100,STANDARD
      my-logs,logs/2026/02/metrics.json,800,STANDARD
      my-logs,logs/2026/03/access.log.gz,2400,STANDARD
      my-logs,archive/2026/dump.tar.gz,9000,GLACIER
      my-logs,logs/2026/04/debug.txt,400,STANDARD
      my-logs,logs/2026/04/error.log.gz,1500,STANDARD
      my-logs,tmp/scratch.gz,50,STANDARD
---

## Prompt

Read `inventory.csv`. Filter object keys that:
1. Start with prefix `logs/2026/`
2. End with suffix `.gz`

Write matching keys to `matches.txt`, one key per line, in the same order they appear in the CSV.

## Expected Behavior

Matching keys:
- `logs/2026/01/app.log.gz`
- `logs/2026/03/access.log.gz`
- `logs/2026/04/error.log.gz`

Non-matches include 2025 prefix, non-`.gz` under 2026, and `.gz` outside the prefix.

## Grading Criteria

- [ ] matches.txt exists
- [ ] Contains logs/2026/01/app.log.gz
- [ ] Contains logs/2026/03/access.log.gz
- [ ] Contains logs/2026/04/error.log.gz
- [ ] Does not contain logs/2025/12/app.log.gz
- [ ] Does not contain archive/2026/dump.tar.gz

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path

    scores = {
        "file_created": 0.0,
        "has_jan": 0.0,
        "has_mar": 0.0,
        "has_apr": 0.0,
        "absent_2025": 0.0,
        "absent_archive": 0.0,
    }
    workspace = Path(workspace_path)
    path = workspace / "matches.txt"
    if not path.exists():
        return scores

    scores["file_created"] = 1.0
    text = path.read_text(encoding="utf-8", errors="replace")
    lines = {ln.strip() for ln in text.splitlines() if ln.strip()}

    if "logs/2026/01/app.log.gz" in lines or "logs/2026/01/app.log.gz" in text:
        scores["has_jan"] = 1.0
    if "logs/2026/03/access.log.gz" in lines or "logs/2026/03/access.log.gz" in text:
        scores["has_mar"] = 1.0
    if "logs/2026/04/error.log.gz" in lines or "logs/2026/04/error.log.gz" in text:
        scores["has_apr"] = 1.0

    if "logs/2025/12/app.log.gz" not in text:
        scores["absent_2025"] = 1.0
    if "archive/2026/dump.tar.gz" not in text:
        scores["absent_archive"] = 1.0

    return scores
```

## Additional Notes

- Fixture-only S3 inventory CSV; no live AWS.
