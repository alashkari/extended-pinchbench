---
id: task_meeting_invite_email
name: Meeting Invite Email
category: writing
grading_type: automated
timeout_seconds: 120
workspace_files: []
---

# Meeting Invite Email

## Prompt

Write a meeting invite email for **Project Review** and save it to `invite.txt`.

Details to include:

- Date: **2026-08-20**
- Time: **14:00 UTC**
- Zoom link: `https://zoom.example/j/123`
- An agenda with **exactly three** bullet points (use `-`, `*`, or `•`)

Include a Subject line and keep the invite professional.

## Expected Behavior

The agent should create `invite.txt` containing:

- The meeting date 2026-08-20
- The time 14:00 UTC (or equivalent wording)
- The exact Zoom URL
- Three agenda bullets

## Grading Criteria

- [ ] File `invite.txt` is created
- [ ] Mentions date 2026-08-20
- [ ] Mentions time 14:00 UTC
- [ ] Includes Zoom link
- [ ] Has at least three bullet-like agenda lines

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import re

    scores = {
        "file_created": 0.0,
        "has_date": 0.0,
        "has_time": 0.0,
        "has_zoom_link": 0.0,
        "has_three_bullets": 0.0,
    }

    workspace = Path(workspace_path)
    path = workspace / "invite.txt"
    if not path.exists():
        return scores

    scores["file_created"] = 1.0
    content = path.read_text(encoding="utf-8", errors="replace")
    lower = content.lower()

    if "2026-08-20" in content or "2026/08/20" in content or re.search(r"august\s+20,?\s+2026", lower):
        scores["has_date"] = 1.0

    if re.search(r"14:00\s*utc|2:00\s*pm\s*utc|1400\s*utc", lower) or (
        "14:00" in content and "utc" in lower
    ):
        scores["has_time"] = 1.0

    if "https://zoom.example/j/123" in content:
        scores["has_zoom_link"] = 1.0

    bullets = re.findall(r"(?m)^\s*[-*•]\s+\S+", content)
    if len(bullets) >= 3:
        scores["has_three_bullets"] = 1.0
    elif len(bullets) >= 1:
        scores["has_three_bullets"] = 0.5

    return scores
```

## Additional Notes

- Grades date, time, link keywords, and bullet structure only.
