---
id: task_integration_calendar_gcal_ics_sync
name: Calendar ICS Merge Sync
category: integrations
grading_type: automated
timeout_seconds: 240
workspace_files:
  - path: "cal_a.ics"
    content: |
      BEGIN:VCALENDAR
      VERSION:2.0
      PRODID:-//PinchBench//CalA//EN
      BEGIN:VEVENT
      UID:meeting-standup-a@example.com
      DTSTART:20260728T150000Z
      DTEND:20260728T153000Z
      SUMMARY:Standup A
      END:VEVENT
      BEGIN:VEVENT
      UID:shared-kickoff@example.com
      DTSTART:20260729T170000Z
      DTEND:20260729T180000Z
      SUMMARY:Kickoff
      END:VEVENT
      END:VCALENDAR
  - path: "cal_b.ics"
    content: |
      BEGIN:VCALENDAR
      VERSION:2.0
      PRODID:-//PinchBench//CalB//EN
      BEGIN:VEVENT
      UID:shared-kickoff@example.com
      DTSTART:20260729T170000Z
      DTEND:20260729T180000Z
      SUMMARY:Kickoff
      END:VEVENT
      BEGIN:VEVENT
      UID:design-review-b@example.com
      DTSTART:20260730T190000Z
      DTEND:20260730T200000Z
      SUMMARY:Design Review B
      END:VEVENT
      END:VCALENDAR
---

## Prompt

You have two calendar exports: `cal_a.ics` and `cal_b.ics`. Merge them into a single ICS file `merged.ics` that:

1. Is a valid `VCALENDAR` document (`BEGIN:VCALENDAR` … `END:VCALENDAR`)
2. Contains all **unique** event UIDs from both files (dedupe by UID — the shared kickoff UID should appear only once)

Do not call any live Google Calendar or GWS APIs; work only from these fixture files.

## Expected Behavior

The merged calendar includes three unique UIDs:
- `meeting-standup-a@example.com` (from A)
- `shared-kickoff@example.com` (present in both; once in output)
- `design-review-b@example.com` (from B)

## Grading Criteria

- [ ] merged.ics exists
- [ ] Has VCALENDAR begin/end structure
- [ ] Contains UID meeting-standup-a@example.com
- [ ] Contains UID shared-kickoff@example.com
- [ ] Contains UID design-review-b@example.com
- [ ] Shared kickoff UID appears only once

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import re

    scores = {
        "file_created": 0.0,
        "vcalendar_structure": 0.0,
        "uid_standup": 0.0,
        "uid_kickoff": 0.0,
        "uid_design_review": 0.0,
        "kickoff_unique": 0.0,
    }
    workspace = Path(workspace_path)
    path = workspace / "merged.ics"
    if not path.exists():
        return scores

    scores["file_created"] = 1.0
    content = path.read_text(encoding="utf-8", errors="replace")

    has_begin = bool(re.search(r"BEGIN:VCALENDAR", content, re.IGNORECASE))
    has_end = bool(re.search(r"END:VCALENDAR", content, re.IGNORECASE))
    if has_begin and has_end:
        scores["vcalendar_structure"] = 1.0

    uid_standup = "meeting-standup-a@example.com"
    uid_kickoff = "shared-kickoff@example.com"
    uid_design = "design-review-b@example.com"

    if re.search(re.escape(uid_standup), content, re.IGNORECASE):
        scores["uid_standup"] = 1.0
    if re.search(re.escape(uid_kickoff), content, re.IGNORECASE):
        scores["uid_kickoff"] = 1.0
    if re.search(re.escape(uid_design), content, re.IGNORECASE):
        scores["uid_design_review"] = 1.0

    kickoff_hits = len(re.findall(re.escape(uid_kickoff), content, re.IGNORECASE))
    if kickoff_hits == 1:
        scores["kickoff_unique"] = 1.0

    return scores
```

## Additional Notes

- Fixture-only ICS merge; no live GWS/Google Calendar.
- Duplicate UID across inputs must appear once in the merge.
