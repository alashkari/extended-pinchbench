---
id: task_recurring_event_ics
name: Recurring Weekly Event ICS
category: productivity
grading_type: automated
timeout_seconds: 120
workspace_files: []
---

## Prompt

You do not have access to a real calendar. Create an ICS (iCalendar) file in the workspace that represents this recurring meeting.

Requirements:
- Summary/title: "Team Sync"
- Recurrence: weekly every Wednesday for 8 weeks (use RRULE with FREQ=WEEKLY)
- First occurrence: 2026-08-05 at 10:00 (local, no timezone conversion needed — use floating local time)
- Attendee: team@example.com
- Duration: 1 hour is fine

Write the file as something like `team_sync.ics` in the workspace root.

## Expected Behavior

The agent should write a valid ICS file containing a VEVENT with:
1. SUMMARY of Team Sync
2. RRULE with FREQ=WEEKLY (and ideally COUNT=8 or UNTIL covering 8 weeks)
3. DTSTART on 2026-08-05 at 10:00 (20260805T100000)
4. ATTENDEE including team@example.com

## Grading Criteria

- [ ] ICS file created
- [ ] SUMMARY is Team Sync
- [ ] RRULE includes FREQ=WEEKLY
- [ ] DTSTART date/time is 2026-08-05 10:00
- [ ] ATTENDEE team@example.com is present

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import re

    scores = {
        "file_created": 0.0,
        "summary_correct": 0.0,
        "rrule_weekly": 0.0,
        "dtstart_correct": 0.0,
        "attendee_present": 0.0,
    }
    workspace = Path(workspace_path)
    ics_files = list(workspace.glob("*.ics"))
    if not ics_files:
        ics_files = list(workspace.rglob("*.ics"))
    if not ics_files:
        return scores

    scores["file_created"] = 1.0
    content = ics_files[0].read_text(encoding="utf-8", errors="replace")

    if re.search(r"SUMMARY\s*:\s*Team Sync", content, re.IGNORECASE):
        scores["summary_correct"] = 1.0

    if re.search(r"RRULE\s*:.*FREQ=WEEKLY", content, re.IGNORECASE):
        scores["rrule_weekly"] = 1.0

    if re.search(r"DTSTART(?:;[^:]*)?:\s*20260805T1000\d{2}", content):
        scores["dtstart_correct"] = 1.0

    if re.search(r"ATTENDEE.*team@example\.com", content, re.IGNORECASE):
        scores["attendee_present"] = 1.0

    return scores
```
