---
id: task_conflict_detect_calendar
name: Calendar Conflict Detection
category: productivity
grading_type: automated
timeout_seconds: 180
workspace_files:
  - path: "events.json"
    content: |
      {
        "events": [
          {
            "id": "A",
            "title": "Design Review",
            "start": "2026-08-10T10:00:00",
            "end": "2026-08-10T11:00:00"
          },
          {
            "id": "B",
            "title": "Client Call",
            "start": "2026-08-10T10:30:00",
            "end": "2026-08-10T11:30:00"
          },
          {
            "id": "C",
            "title": "Lunch",
            "start": "2026-08-10T12:00:00",
            "end": "2026-08-10T13:00:00"
          }
        ]
      }
---

## Prompt

Read `events.json` in the workspace. Detect pairs of events whose time ranges overlap (half-open or closed intervals both fine as long as A overlaps B and C does not overlap either).

Write `conflicts.json` with this structure:

```json
{
  "conflicts": [
    {"event_ids": ["A", "B"]}
  ]
}
```

Rules:
- Only list pairs that actually overlap.
- Event IDs in each pair may be in either order.
- There should be exactly one conflict pair for this fixture: A and B.

## Expected Behavior

The agent loads the three events, detects that A (10:00–11:00) overlaps B (10:30–11:30), and that C (12:00–13:00) overlaps neither. It writes `conflicts.json` listing the single overlapping pair with IDs A and B.

## Grading Criteria

- [ ] conflicts.json exists
- [ ] Output is valid JSON with a conflicts list
- [ ] Conflict pair A and B is detected
- [ ] No spurious conflict involving C

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import json

    scores = {
        "file_created": 0.0,
        "valid_json": 0.0,
        "correct_pair": 0.0,
        "no_spurious_c": 0.0,
    }
    workspace = Path(workspace_path)
    path = workspace / "conflicts.json"
    if not path.exists():
        return scores

    scores["file_created"] = 1.0
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except Exception:
        return scores

    conflicts = data.get("conflicts")
    if not isinstance(conflicts, list):
        return scores
    scores["valid_json"] = 1.0

    pairs = []
    for item in conflicts:
        if isinstance(item, dict) and "event_ids" in item:
            ids = item["event_ids"]
        elif isinstance(item, (list, tuple)):
            ids = item
        else:
            continue
        if len(ids) >= 2:
            pairs.append(frozenset(str(x) for x in ids[:2]))

    expected = frozenset(["A", "B"])
    if expected in pairs:
        scores["correct_pair"] = 1.0

    involves_c = any("C" in p for p in pairs)
    if scores["correct_pair"] == 1.0 and not involves_c:
        scores["no_spurious_c"] = 1.0
    elif not pairs:
        scores["no_spurious_c"] = 0.0
    elif not involves_c:
        scores["no_spurious_c"] = 1.0

    return scores
```
