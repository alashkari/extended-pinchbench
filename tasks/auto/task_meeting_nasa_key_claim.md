---
id: task_meeting_nasa_key_claim
name: NASA Meeting Roadmap Objective
category: meeting_analysis
grading_type: automated
timeout_seconds: 180
workspace_files:
  - source: meetings/2025-07-30-nasa-holds-first-public-meeting-on-ufos-transcript.md
    dest: transcript.md
---

## Prompt

According to `transcript.md`, what is the primary deliverable/objective of the UAP independent study team emphasized in opening remarks (not reviewing grainy footage)?

Write `key_claim.txt` stating the objective. It should mention a **roadmap** for future analysis/data collection.

## Expected Behavior

Openers emphasize producing a scientific roadmap rather than re-analyzing old footage.

## Grading Criteria

- [ ] File created
- [ ] Mentions roadmap
- [ ] Mentions UAP or anomalous
- [ ] Mentions science or scientific or data

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    scores = {k: 0.0 for k in ["file_created","roadmap","uap","science"]}
    path = Path(workspace_path) / "key_claim.txt"
    if not path.exists():
        return scores
    scores["file_created"] = 1.0
    text = path.read_text().lower()
    scores["roadmap"] = 1.0 if "roadmap" in text else 0.0
    scores["uap"] = 1.0 if ("uap" in text or "anomalous" in text or "ufo" in text) else 0.0
    scores["science"] = 1.0 if ("science" in text or "scientific" in text or "data" in text) else 0.0
    return scores

```
