---
id: task_meeting_action_owner_table
name: GitLab Action Owner Table
category: meeting_analysis
grading_type: automated
timeout_seconds: 180
workspace_files:
  - source: meetings/2021-06-28-gitlab-product-marketing-meeting.md
    dest: transcript.md
---

## Prompt

From `transcript.md`, create `action_owners.csv` with headers `owner,action` containing at least 3 rows. Include rows that attribute work to Samia (competitive analysis) and William (messaging/tagline).

## Expected Behavior

Extract action-like items with owners Samia and William among others.

## Grading Criteria

- [ ] CSV created
- [ ] Has header owner/action
- [ ] Mentions Samia
- [ ] Mentions William
- [ ] At least 3 data rows

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    scores = {k: 0.0 for k in ["file_created","header","samia","william","rows"]}
    path = Path(workspace_path) / "action_owners.csv"
    if not path.exists():
        return scores
    scores["file_created"] = 1.0
    text = path.read_text()
    low = text.lower()
    lines = [l for l in text.splitlines() if l.strip()]
    scores["header"] = 1.0 if ("owner" in low and "action" in low) else 0.0
    scores["samia"] = 1.0 if "samia" in low else 0.0
    scores["william"] = 1.0 if "william" in low else 0.0
    scores["rows"] = 1.0 if len(lines) >= 4 else (0.5 if len(lines) >= 2 else 0.0)
    return scores

```
