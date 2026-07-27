---
id: task_habit_streak_tracker
name: Habit Streak Tracker
category: productivity
grading_type: automated
timeout_seconds: 120
workspace_files:
  - path: "habit_log.json"
    content: |
      {
        "habit": "morning_run",
        "days": [
          true,
          true,
          true,
          false,
          true,
          true,
          true,
          true,
          true,
          false,
          true,
          true
        ]
      }
---

## Prompt

Read `habit_log.json`. The `days` array is chronological oldest → newest (last element is the most recent day).

Compute:
- `current_streak`: consecutive `true` values counting backward from the end
- `longest_streak`: longest run of consecutive `true` values anywhere in the array

Write `streaks.json`:

```json
{
  "current_streak": 2,
  "longest_streak": 5
}
```

For this fixture: ending `true, true` → current_streak=2; the run of five trues after the first false → longest_streak=5.

## Expected Behavior

The agent scans the boolean log and writes current_streak=2 and longest_streak=5.

## Grading Criteria

- [ ] streaks.json exists
- [ ] Valid JSON
- [ ] current_streak is 2
- [ ] longest_streak is 5

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import json

    scores = {
        "file_created": 0.0,
        "valid_json": 0.0,
        "current_streak": 0.0,
        "longest_streak": 0.0,
    }
    workspace = Path(workspace_path)
    path = workspace / "streaks.json"
    if not path.exists():
        return scores

    scores["file_created"] = 1.0
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except Exception:
        return scores

    if not isinstance(data, dict):
        return scores
    scores["valid_json"] = 1.0

    if data.get("current_streak") == 2:
        scores["current_streak"] = 1.0
    if data.get("longest_streak") == 5:
        scores["longest_streak"] = 1.0

    return scores
```
