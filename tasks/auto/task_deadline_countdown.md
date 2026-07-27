---
id: task_deadline_countdown
name: Deadline Countdown Calculator
category: productivity
grading_type: automated
timeout_seconds: 120
workspace_files:
  - path: "deadlines.json"
    content: |
      {
        "items": [
          {"id": "d1", "title": "Submit tax forms", "due_date": "2026-07-30"},
          {"id": "d2", "title": "Ship v2.1", "due_date": "2026-08-10"},
          {"id": "d3", "title": "Renew domain", "due_date": "2026-07-27"},
          {"id": "d4", "title": "Board packet", "due_date": "2026-08-03"}
        ]
      }
---

## Prompt

Use reference date **2026-07-27** (do not use today's real clock date).

Read `deadlines.json` and compute `days_remaining` for each item as `(due_date - reference_date).days` (integer, can be 0).

Write `countdown.json` like:

```json
{
  "reference_date": "2026-07-27",
  "items": [
    {"id": "d1", "days_remaining": 3},
    {"id": "d2", "days_remaining": 14},
    {"id": "d3", "days_remaining": 0},
    {"id": "d4", "days_remaining": 7}
  ]
}
```

Order of items does not matter; IDs and day counts must be correct.

## Expected Behavior

The agent computes day deltas from 2026-07-27:
- d1 → 3
- d2 → 14
- d3 → 0
- d4 → 7

and writes them to `countdown.json`.

## Grading Criteria

- [ ] countdown.json exists
- [ ] Valid JSON structure
- [ ] d1 days_remaining is 3
- [ ] d2 days_remaining is 14
- [ ] d3 days_remaining is 0

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import json

    scores = {
        "file_created": 0.0,
        "valid_json": 0.0,
        "d1_correct": 0.0,
        "d2_correct": 0.0,
        "d3_correct": 0.0,
    }
    workspace = Path(workspace_path)
    path = workspace / "countdown.json"
    if not path.exists():
        return scores

    scores["file_created"] = 1.0
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except Exception:
        return scores

    items = data.get("items")
    if not isinstance(items, list):
        return scores
    scores["valid_json"] = 1.0

    by_id = {}
    for item in items:
        if isinstance(item, dict) and "id" in item:
            by_id[str(item["id"])] = item.get("days_remaining")

    if by_id.get("d1") == 3:
        scores["d1_correct"] = 1.0
    if by_id.get("d2") == 14:
        scores["d2_correct"] = 1.0
    if by_id.get("d3") == 0:
        scores["d3_correct"] = 1.0

    return scores
```
