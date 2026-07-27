---
id: task_conference_cfp_deadline_format
name: PinchConf CFP Deadline Extraction
category: research
grading_type: automated
timeout_seconds: 120
workspace_files:
  - path: "cfp_announcement.md"
    content: |
      # PinchConf 2026 — Call for Papers

      PinchConf 2026 invites submissions on agent benchmarks, tool use, and
      evaluation methodology.

      **Conference dates:** December 8–10, 2026  
      **Location:** Virtual + satellite hubs

      ## Important dates

      - Abstract registration: 2026-10-01
      - Full paper CFP deadline: **2026-11-15**
      - Author notification: 2026-12-01
      - Camera-ready: 2026-12-05

      Submit via the conference portal. Late submissions will not be considered.
---

## Prompt

Read `cfp_announcement.md` in the workspace. Extract the full paper CFP deadline for PinchConf 2026 and save it to `deadline.txt`.

## Expected Behavior

The agent should:

1. Open and read the provided `cfp_announcement.md`
2. Identify the full paper CFP deadline as 2026-11-15
3. Write that date to `deadline.txt`

No live web research is required; the announcement is already in the workspace.

## Grading Criteria

- [ ] File `deadline.txt` created
- [ ] File contains 2026-11-15
- [ ] File does not confuse the deadline with other dates (optional soft check)
- [ ] Answer is concise

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import re

    scores = {
        "file_created": 0.0,
        "deadline_correct": 0.0,
        "not_wrong_date_only": 0.0,
        "concise": 0.0,
    }

    deadline_file = Path(workspace_path) / "deadline.txt"
    if not deadline_file.exists():
        return scores

    content = deadline_file.read_text(encoding="utf-8", errors="ignore")
    scores["file_created"] = 1.0

    if "2026-11-15" in content:
        scores["deadline_correct"] = 1.0

    # Soft check: if other announcement dates appear without the CFP deadline, fail
    other_dates = {"2026-10-01", "2026-12-01", "2026-12-05"}
    has_other = any(d in content for d in other_dates)
    if "2026-11-15" in content or not has_other:
        scores["not_wrong_date_only"] = 1.0

    if 8 <= len(content.strip()) <= 80:
        scores["concise"] = 1.0

    return scores
```
