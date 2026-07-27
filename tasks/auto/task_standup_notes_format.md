---
id: task_standup_notes_format
name: Standup Notes Formatter
category: productivity
grading_type: automated
timeout_seconds: 120
workspace_files:
  - path: "raw_notes.txt"
    content: |
      yesterday: finished auth middleware; reviewed PR #88
      today: start payment webhook; meet with design at 2pm
      blockers: waiting on staging credentials from devops
---

## Prompt

Read `raw_notes.txt` and rewrite it as a markdown standup file named `standup.md` with exactly these section headers (level-2):

```markdown
## Yesterday
## Today
## Blockers
```

Under each section, include the relevant items from the notes (bullet points preferred). Preserve the key facts: auth middleware, PR #88, payment webhook, design meeting, and staging credentials.

## Expected Behavior

The agent creates `standup.md` with the three required `##` headers and places yesterday/today/blocker content under the correct sections so graders can find the key phrases.

## Grading Criteria

- [ ] standup.md exists
- [ ] Has ## Yesterday header
- [ ] Has ## Today header
- [ ] Has ## Blockers header
- [ ] Mentions auth middleware and PR #88
- [ ] Mentions payment webhook
- [ ] Mentions staging credentials

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import re

    scores = {
        "file_created": 0.0,
        "header_yesterday": 0.0,
        "header_today": 0.0,
        "header_blockers": 0.0,
        "yesterday_items": 0.0,
        "today_items": 0.0,
        "blocker_items": 0.0,
    }
    workspace = Path(workspace_path)
    path = workspace / "standup.md"
    if not path.exists():
        return scores

    scores["file_created"] = 1.0
    content = path.read_text(encoding="utf-8", errors="replace")

    if re.search(r"^##\s+Yesterday\s*$", content, re.MULTILINE | re.IGNORECASE):
        scores["header_yesterday"] = 1.0
    if re.search(r"^##\s+Today\s*$", content, re.MULTILINE | re.IGNORECASE):
        scores["header_today"] = 1.0
    if re.search(r"^##\s+Blockers\s*$", content, re.MULTILINE | re.IGNORECASE):
        scores["header_blockers"] = 1.0

    yesterday_ok = (
        re.search(r"auth\s+middleware", content, re.IGNORECASE)
        and re.search(r"PR\s*#?\s*88", content, re.IGNORECASE)
    )
    if yesterday_ok:
        scores["yesterday_items"] = 1.0

    if re.search(r"payment\s+webhook", content, re.IGNORECASE):
        scores["today_items"] = 1.0

    if re.search(r"staging\s+credentials", content, re.IGNORECASE):
        scores["blocker_items"] = 1.0

    return scores
```
