---
id: task_meeting_tampa_mayor_mentions
name: Tampa Mayor Mention Count
category: meeting_analysis
grading_type: automated
timeout_seconds: 180
workspace_files:
  - source: meetings/2026-04-02-tampa-city-council-transcript.md
    dest: transcript.md
---

## Prompt

In `transcript.md`, count case-insensitive occurrences of the whole word `mayor`.

Write `mayor_mentions.json` with `mayor_count`.

## Expected Behavior

Expected mayor_count is 30.

## Grading Criteria

- [ ] File created
- [ ] mayor_count is 30

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import json
    scores = {"file_created": 0.0, "count": 0.0}
    path = Path(workspace_path) / "mayor_mentions.json"
    if not path.exists():
        return scores
    scores["file_created"] = 1.0
    try:
        data = json.loads(path.read_text())
        c = int(data.get("mayor_count") or data.get("count") or -1)
        scores["count"] = 1.0 if c == 30 else (0.5 if abs(c-30) <= 2 else 0.0)
    except Exception:
        pass
    return scores

```
