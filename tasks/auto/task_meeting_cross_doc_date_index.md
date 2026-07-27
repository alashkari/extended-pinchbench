---
id: task_meeting_cross_doc_date_index
name: Cross-Meeting Date Index
category: meeting_analysis
grading_type: automated
timeout_seconds: 240
workspace_files:
  - source: meetings/2026-04-02-tampa-city-council-transcript.md
    dest: tampa.md
  - source: meetings/2021-06-28-gitlab-product-marketing-meeting.md
    dest: gitlab.md
  - source: meetings/2012-05-30-meeting-transcript-ntia-csmac.md
    dest: ntia.md
  - source: meetings/2025-07-30-nasa-holds-first-public-meeting-on-ufos-transcript.md
    dest: nasa.md
---

## Prompt

You have four meeting transcripts: `tampa.md`, `gitlab.md`, `ntia.md`, `nasa.md`.

Build `date_index.json` mapping each filename to the primary meeting date in YYYY-MM-DD when possible:
- tampa → 2026-04-02
- gitlab → 2021-06-28
- ntia → 2012-05-30
- nasa → use 2025-07-30 if stated in filename/metadata (or the retrieved meeting date if clearly present)

## Expected Behavior

Agent should extract dates from titles/headers/filenames consistently as YYYY-MM-DD.

## Grading Criteria

- [ ] File created
- [ ] tampa date 2026-04-02
- [ ] gitlab date 2021-06-28
- [ ] ntia date 2012-05-30
- [ ] nasa date 2025-07-30

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import json
    scores = {k: 0.0 for k in ["file_created","tampa","gitlab","ntia","nasa"]}
    path = Path(workspace_path) / "date_index.json"
    if not path.exists():
        return scores
    scores["file_created"] = 1.0
    try:
        data = json.loads(path.read_text())
        blob = {str(k).lower(): str(v) for k,v in data.items()} if isinstance(data, dict) else {}
        def get(*keys):
            for k,v in blob.items():
                for key in keys:
                    if key in k:
                        return v
            return ""
        scores["tampa"] = 1.0 if "2026-04-02" in get("tampa") else 0.0
        scores["gitlab"] = 1.0 if "2021-06-28" in get("gitlab") else 0.0
        scores["ntia"] = 1.0 if "2012-05-30" in get("ntia") else 0.0
        scores["nasa"] = 1.0 if "2025-07-30" in get("nasa") else 0.0
    except Exception:
        pass
    return scores

```
