---
id: task_integration_jira_status_board
name: Jira Status Board Grouping
category: integrations
grading_type: automated
timeout_seconds: 180
workspace_files:
  - path: "issues.json"
    content: |
      {
        "issues": [
          {"key": "PLAT-101", "summary": "Add retry metrics", "status": "To Do"},
          {"key": "PLAT-108", "summary": "Fix queue lag alert", "status": "In Progress"},
          {"key": "PLAT-112", "summary": "Document webhook secrets", "status": "Done"},
          {"key": "PLAT-115", "summary": "Rotate API tokens", "status": "To Do"},
          {"key": "PLAT-120", "summary": "Ship canary dashboard", "status": "In Progress"},
          {"key": "PLAT-124", "summary": "Archive old runbooks", "status": "Done"}
        ]
      }
---

## Prompt

Read `issues.json`. Build a status board by grouping issue keys under their status.

Write `board.json` with this shape:

```json
{
  "To Do": ["PLAT-101", "PLAT-115"],
  "In Progress": ["PLAT-108", "PLAT-120"],
  "Done": ["PLAT-112", "PLAT-124"]
}
```

Use the exact status strings from the fixture as object keys. Within each status, preserve the order issues appear in `issues.json`.

## Expected Behavior

The agent groups keys by status into `board.json` with the three buckets above.

## Grading Criteria

- [ ] board.json exists and is valid JSON
- [ ] To Do contains PLAT-101 and PLAT-115
- [ ] In Progress contains PLAT-108 and PLAT-120
- [ ] Done contains PLAT-112 and PLAT-124

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import json

    scores = {
        "file_valid": 0.0,
        "todo_keys": 0.0,
        "in_progress_keys": 0.0,
        "done_keys": 0.0,
    }
    workspace = Path(workspace_path)
    path = workspace / "board.json"
    if not path.exists():
        return scores

    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except Exception:
        return scores

    if not isinstance(data, dict):
        return scores

    scores["file_valid"] = 1.0

    def _keys_for(*status_names):
        for name in status_names:
            if name in data and isinstance(data[name], list):
                return [str(x) for x in data[name]]
        # case-insensitive fallback
        lowered = {str(k).lower(): v for k, v in data.items()}
        for name in status_names:
            v = lowered.get(name.lower())
            if isinstance(v, list):
                return [str(x) for x in v]
        return []

    todo = _keys_for("To Do", "Todo", "TO DO")
    if "PLAT-101" in todo and "PLAT-115" in todo:
        scores["todo_keys"] = 1.0

    progress = _keys_for("In Progress", "In-Progress", "IN PROGRESS")
    if "PLAT-108" in progress and "PLAT-120" in progress:
        scores["in_progress_keys"] = 1.0

    done = _keys_for("Done", "DONE")
    if "PLAT-112" in done and "PLAT-124" in done:
        scores["done_keys"] = 1.0

    return scores
```

## Additional Notes

- Fixture-only Jira issues; no live Jira API.
