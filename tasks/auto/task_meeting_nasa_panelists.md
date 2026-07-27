---
id: task_meeting_nasa_panelists
name: NASA UAP Panelist Extraction
category: meeting_analysis
grading_type: automated
timeout_seconds: 180
workspace_files:
  - source: meetings/2025-07-30-nasa-holds-first-public-meeting-on-ufos-transcript.md
    dest: transcript.md
---

## Prompt

From `transcript.md`, extract the list of panelists introduced near the start (Dan Evans introduction).

Write `panelists.json` as a JSON list of full names. Must include David Spergel (chair), Nadia Drake, Scott Kelly, Mike Gold, and Shelley Wright.

## Expected Behavior

Expected panelists include those named in Evans' opening introduction.

## Grading Criteria

- [ ] File created
- [ ] Includes Spergel
- [ ] Includes Nadia Drake
- [ ] Includes Scott Kelly
- [ ] Includes Mike Gold
- [ ] Includes Shelley Wright

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import json
    scores = {k: 0.0 for k in ["file_created","spergel","drake","kelly","gold","wright"]}
    path = Path(workspace_path) / "panelists.json"
    if not path.exists():
        return scores
    scores["file_created"] = 1.0
    blob = path.read_text().lower()
    scores["spergel"] = 1.0 if "spergel" in blob else 0.0
    scores["drake"] = 1.0 if "drake" in blob else 0.0
    scores["kelly"] = 1.0 if "kelly" in blob else 0.0
    scores["gold"] = 1.0 if "gold" in blob else 0.0
    scores["wright"] = 1.0 if "wright" in blob else 0.0
    return scores

```
