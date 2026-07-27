---
id: task_meeting_ntia_attendee_orgs
name: NTIA Attendee Organizations
category: meeting_analysis
grading_type: automated
timeout_seconds: 180
workspace_files:
  - source: meetings/2012-05-30-meeting-transcript-ntia-csmac.md
    dest: transcript.md
---

## Prompt

From the Members Present section of `transcript.md`, list organizations/affiliations mentioned for committee members.

Write `orgs.json` as a JSON list of organization name strings. Include at least: Verizon Wireless, AT&T, Intel, New America Foundation, Shared Spectrum Company.

## Expected Behavior

Agent extracts orgs from the attendee roster.

## Grading Criteria

- [ ] File created
- [ ] Includes Verizon
- [ ] Includes AT&T or ATT
- [ ] Includes Intel
- [ ] Includes New America or Shared Spectrum

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import json
    scores = {k: 0.0 for k in ["file_created","verizon","att","intel","other"]}
    path = Path(workspace_path) / "orgs.json"
    if not path.exists():
        return scores
    scores["file_created"] = 1.0
    try:
        blob = path.read_text().lower()
        scores["verizon"] = 1.0 if "verizon" in blob else 0.0
        scores["att"] = 1.0 if ("at&t" in blob or "at&amp;t" in blob or "att" in blob) else 0.0
        scores["intel"] = 1.0 if "intel" in blob else 0.0
        scores["other"] = 1.0 if ("new america" in blob or "shared spectrum" in blob) else 0.0
    except Exception:
        pass
    return scores

```
