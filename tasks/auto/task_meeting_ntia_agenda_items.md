---
id: task_meeting_ntia_agenda_items
name: NTIA CSMAC Meeting Metadata
category: meeting_analysis
grading_type: automated
timeout_seconds: 180
workspace_files:
  - source: meetings/2012-05-30-meeting-transcript-ntia-csmac.md
    dest: transcript.md
---

## Prompt

From `transcript.md` (CSMAC meeting), extract:
- meeting_date (May 30, 2012)
- chair name (Brian Fontes)
- location building (Herbert C. Hoover Building)

Write `meeting_meta.json` with keys `meeting_date`, `chair`, `building`.

## Expected Behavior

Expected chair Brian Fontes; building Herbert C. Hoover Building; date May 30, 2012.

## Grading Criteria

- [ ] File created
- [ ] chair includes Fontes
- [ ] building includes Hoover
- [ ] date mentions 2012 and May/30

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import json
    scores = {k: 0.0 for k in ["file_created","chair","building","date"]}
    path = Path(workspace_path) / "meeting_meta.json"
    if not path.exists():
        return scores
    scores["file_created"] = 1.0
    try:
        data = json.loads(path.read_text())
        blob = json.dumps(data).lower()
        scores["chair"] = 1.0 if "fontes" in blob else 0.0
        scores["building"] = 1.0 if "hoover" in blob else 0.0
        scores["date"] = 1.0 if ("2012" in blob and ("may" in blob or "05" in blob or "30" in blob)) else 0.0
    except Exception:
        pass
    return scores

```
