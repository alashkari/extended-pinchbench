---
id: task_timezone_meeting_ics
name: Timezone Meeting ICS (UTC)
category: productivity
grading_type: automated
timeout_seconds: 120
workspace_files: []
---

## Prompt

You do not have access to a real calendar. Create an ICS file in the workspace for this meeting.

Meeting details:
- Title: "Board Call"
- Local time: 2026-09-15 at 09:00 America/New_York
- Write DTSTART in UTC using the Z suffix (EDT is UTC-4 on that date, so 09:00 EDT = 13:00 UTC)

Example expected form: `DTSTART:20260915T130000Z`

Save the file as something like `board_call.ics` in the workspace root.

## Expected Behavior

The agent should create an ICS VEVENT with SUMMARY "Board Call" and DTSTART expressed as UTC `20260915T130000Z` (or equivalent with seconds). It should not leave the start time as 09:00 local without converting to UTC when using the Z form.

## Grading Criteria

- [ ] ICS file created
- [ ] SUMMARY is Board Call
- [ ] DTSTART is 20260915T130000Z (UTC)

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import re

    scores = {
        "file_created": 0.0,
        "title_correct": 0.0,
        "utc_time_correct": 0.0,
    }
    workspace = Path(workspace_path)
    ics_files = list(workspace.glob("*.ics"))
    if not ics_files:
        ics_files = list(workspace.rglob("*.ics"))
    if not ics_files:
        return scores

    scores["file_created"] = 1.0
    content = ics_files[0].read_text(encoding="utf-8", errors="replace")

    if re.search(r"SUMMARY\s*:\s*Board Call", content, re.IGNORECASE):
        scores["title_correct"] = 1.0

    if re.search(r"DTSTART(?:;[^:]*)?:\s*20260915T1300\d{2}Z", content):
        scores["utc_time_correct"] = 1.0

    return scores
```
