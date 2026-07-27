---
id: task_weekly_agenda_builder
name: Weekly Agenda Builder
category: productivity
grading_type: automated
timeout_seconds: 180
workspace_files:
  - path: "tasks.json"
    content: |
      {
        "tasks": [
          {"id": "t1", "title": "Draft Q3 roadmap", "day": "Mon"},
          {"id": "t2", "title": "Send invoices", "day": "Wed"},
          {"id": "t3", "title": "Grocery run", "day": "Sat"}
        ]
      }
  - path: "events.json"
    content: |
      {
        "events": [
          {"id": "e1", "title": "Team Sync", "day": "Wed", "time": "10:00"},
          {"id": "e2", "title": "Dentist", "day": "Fri", "time": "15:00"},
          {"id": "e3", "title": "Family dinner", "day": "Sun", "time": "18:00"}
        ]
      }
---

## Prompt

Build a weekly agenda markdown file `agenda.md` for the week of **2026-08-03** (Monday) through **2026-08-09** (Sunday).

Combine items from `tasks.json` and `events.json`. Use these exact day headings (level-2):

```markdown
## Mon
## Tue
## Wed
## Thu
## Fri
## Sat
## Sun
```

Under each day, list that day's tasks and events (bullets are fine). Empty days may have no bullets or an explicit "none".

Key items that must appear somewhere under the correct days:
- Draft Q3 roadmap (Mon)
- Team Sync (Wed)
- Dentist (Fri)
- Family dinner (Sun)

## Expected Behavior

The agent merges tasks and events into `agenda.md` with Mon–Sun headers and places key items under the matching day sections.

## Grading Criteria

- [ ] agenda.md exists
- [ ] Contains ## Mon through ## Sun headers
- [ ] Mentions Draft Q3 roadmap
- [ ] Mentions Team Sync
- [ ] Mentions Dentist
- [ ] Mentions Family dinner

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import re

    scores = {
        "file_created": 0.0,
        "day_headers": 0.0,
        "item_roadmap": 0.0,
        "item_team_sync": 0.0,
        "item_dentist": 0.0,
        "item_family_dinner": 0.0,
    }
    workspace = Path(workspace_path)
    path = workspace / "agenda.md"
    if not path.exists():
        return scores

    scores["file_created"] = 1.0
    content = path.read_text(encoding="utf-8", errors="replace")

    days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    found = 0
    for d in days:
        if re.search(rf"^##\s+{d}\s*$", content, re.MULTILINE | re.IGNORECASE):
            found += 1
    if found == 7:
        scores["day_headers"] = 1.0
    elif found >= 5:
        scores["day_headers"] = 0.5

    if re.search(r"Draft\s+Q3\s+roadmap", content, re.IGNORECASE):
        scores["item_roadmap"] = 1.0
    if re.search(r"Team\s+Sync", content, re.IGNORECASE):
        scores["item_team_sync"] = 1.0
    if re.search(r"Dentist", content, re.IGNORECASE):
        scores["item_dentist"] = 1.0
    if re.search(r"Family\s+dinner", content, re.IGNORECASE):
        scores["item_family_dinner"] = 1.0

    return scores
```
