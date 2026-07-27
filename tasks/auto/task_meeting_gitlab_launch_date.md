---
id: task_meeting_gitlab_launch_date
name: GitLab Meeting Source Date
category: meeting_analysis
grading_type: automated
timeout_seconds: 180
workspace_files:
  - source: meetings/2021-06-28-gitlab-product-marketing-meeting.md
    dest: transcript.md
---

## Prompt

From `transcript.md`, extract the meeting date as stated in the title/header (weekly product marketing meeting).

Write `meeting_date.txt` containing the date in YYYY-MM-DD form.

## Expected Behavior

Expected date is 2021-06-28.

## Grading Criteria

- [ ] File created
- [ ] Contains 2021-06-28

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    scores = {"file_created": 0.0, "date": 0.0}
    path = Path(workspace_path) / "meeting_date.txt"
    alts = list(Path(workspace_path).glob("*date*"))
    if not path.exists() and alts:
        path = alts[0]
    if not path.exists():
        return scores
    scores["file_created"] = 1.0
    text = path.read_text()
    scores["date"] = 1.0 if "2021-06-28" in text else 0.0
    return scores

```
