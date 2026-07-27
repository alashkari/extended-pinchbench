---
id: task_meeting_gitlab_owner_names
name: GitLab Meeting Owner Names Present
category: meeting_analysis
grading_type: automated
timeout_seconds: 180
workspace_files:
  - source: meetings/2021-06-28-gitlab-product-marketing-meeting.md
    dest: transcript.md
---

## Prompt

Read the GitLab product marketing meeting transcript in `transcript.md`.

Write `owners.json` listing the names of people who appear to own action items / speak as owners. Include at least: Samia, William, Cormac, Cindy, Brian, Tai (when present in the transcript).

The file should be a JSON list of strings or an object with an `owners` array.

## Expected Behavior

Agent should extract owner/participant names mentioned in action-item context. Graded on presence of known names from the transcript.

## Grading Criteria

- [ ] File created
- [ ] Mentions Samia
- [ ] Mentions William
- [ ] Mentions at least 2 of Cormac/Cindy/Brian/Tai

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import json
    scores = {k: 0.0 for k in ["file_created","samia","william","others"]}
    path = Path(workspace_path) / "owners.json"
    if not path.exists():
        return scores
    scores["file_created"] = 1.0
    try:
        raw = path.read_text().lower()
        data = json.loads(path.read_text())
        blob = raw
        if isinstance(data, dict):
            blob = json.dumps(data).lower()
        elif isinstance(data, list):
            blob = json.dumps(data).lower()
        scores["samia"] = 1.0 if "samia" in blob else 0.0
        scores["william"] = 1.0 if "william" in blob else 0.0
        others = sum(1 for n in ["cormac","cindy","brian","tai"] if n in blob)
        scores["others"] = 1.0 if others >= 2 else (0.5 if others == 1 else 0.0)
    except Exception:
        pass
    return scores

```
