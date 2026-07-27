---
id: task_meeting_tampa_motion_count
name: Tampa Council Motion Word Count
category: meeting_analysis
grading_type: automated
timeout_seconds: 180
workspace_files:
  - source: meetings/2026-04-02-tampa-city-council-transcript.md
    dest: transcript.md
---

## Prompt

In `transcript.md` (Tampa City Council, April 2, 2026), count case-insensitive occurrences of the whole word `motion`.

Write `motion_count.json` with `motion_count`.

## Expected Behavior

Expected motion_count is 84.

## Grading Criteria

- [ ] File created
- [ ] motion_count is 84

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import json
    scores = {"file_created": 0.0, "count": 0.0}
    path = Path(workspace_path) / "motion_count.json"
    if not path.exists():
        return scores
    scores["file_created"] = 1.0
    try:
        data = json.loads(path.read_text())
        c = int(data.get("motion_count") or data.get("count") or -1)
        scores["count"] = 1.0 if c == 84 else (0.5 if abs(c-84) <= 3 else 0.0)
    except Exception:
        pass
    return scores

```
