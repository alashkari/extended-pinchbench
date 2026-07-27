---
id: task_meeting_room_booking
name: Meeting Room Allocation
category: productivity
grading_type: automated
timeout_seconds: 180
workspace_files:
  - path: "rooms.json"
    content: |
      {
        "rooms": [
          {"id": "R1", "name": "Atlas", "capacity": 4},
          {"id": "R2", "name": "Beacon", "capacity": 8},
          {"id": "R3", "name": "Cedar", "capacity": 12}
        ]
      }
  - path: "meetings.json"
    content: |
      {
        "meetings": [
          {
            "id": "M1",
            "title": "1:1 Coaching",
            "attendees": 2,
            "start": "2026-08-12T09:00:00",
            "end": "2026-08-12T09:30:00"
          },
          {
            "id": "M2",
            "title": "Sprint Planning",
            "attendees": 7,
            "start": "2026-08-12T09:00:00",
            "end": "2026-08-12T10:00:00"
          },
          {
            "id": "M3",
            "title": "All Hands Prep",
            "attendees": 10,
            "start": "2026-08-12T10:00:00",
            "end": "2026-08-12T11:00:00"
          }
        ]
      }
---

## Prompt

Assign each meeting in `meetings.json` to a room in `rooms.json` such that:
1. Room capacity >= number of attendees
2. No two meetings share a room if their time ranges overlap

Treat intervals as half-open `[start, end)` so a meeting ending at 10:00 does not conflict with one starting at 10:00.

Write `allocation.json`:

```json
{
  "assignments": [
    {"meeting_id": "M1", "room_id": "R1"},
    {"meeting_id": "M2", "room_id": "R2"},
    {"meeting_id": "M3", "room_id": "R3"}
  ]
}
```

The unique feasible assignment for this fixture is M1→R1, M2→R2, M3→R3.

## Expected Behavior

The agent solves the capacity + non-overlap constraints and writes assignments M1→R1, M2→R2, M3→R3.

## Grading Criteria

- [ ] allocation.json exists
- [ ] Valid JSON with assignments
- [ ] M1 assigned to R1
- [ ] M2 assigned to R2
- [ ] M3 assigned to R3

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import json

    scores = {
        "file_created": 0.0,
        "valid_json": 0.0,
        "m1_r1": 0.0,
        "m2_r2": 0.0,
        "m3_r3": 0.0,
    }
    workspace = Path(workspace_path)
    path = workspace / "allocation.json"
    if not path.exists():
        return scores

    scores["file_created"] = 1.0
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except Exception:
        return scores

    assignments = data.get("assignments")
    if not isinstance(assignments, list):
        return scores
    scores["valid_json"] = 1.0

    by_meeting = {}
    for a in assignments:
        if isinstance(a, dict) and "meeting_id" in a and "room_id" in a:
            by_meeting[str(a["meeting_id"])] = str(a["room_id"])

    if by_meeting.get("M1") == "R1":
        scores["m1_r1"] = 1.0
    if by_meeting.get("M2") == "R2":
        scores["m2_r2"] = 1.0
    if by_meeting.get("M3") == "R3":
        scores["m3_r3"] = 1.0

    return scores
```
