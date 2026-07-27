---
id: task_integration_pagerduty_oncall
name: PagerDuty On-Call Lookup
category: integrations
grading_type: automated
timeout_seconds: 180
workspace_files:
  - path: "schedule.json"
    content: |
      {
        "schedule_name": "Platform Primary",
        "timezone": "UTC",
        "rotations": [
          {
            "user": "Sam Rivera",
            "start": "2026-07-20T00:00:00Z",
            "end": "2026-07-27T00:00:00Z"
          },
          {
            "user": "Jordan Blake",
            "start": "2026-07-27T00:00:00Z",
            "end": "2026-08-03T00:00:00Z"
          },
          {
            "user": "Casey Ng",
            "start": "2026-08-03T00:00:00Z",
            "end": "2026-08-10T00:00:00Z"
          }
        ]
      }
---

## Prompt

Read the on-call schedule at `schedule.json`. Using reference time **2026-07-27T15:00:00Z**, determine who is the current primary on-call.

A rotation is active when `start <= reference_time < end`.

Write only the primary person's name to `oncall.txt` (a single line, no extra labels required).

## Expected Behavior

At 2026-07-27T15:00:00Z, Jordan Blake's rotation is active. The agent writes `Jordan Blake` to `oncall.txt`.

## Grading Criteria

- [ ] oncall.txt exists
- [ ] Exact primary name Jordan Blake

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import re

    scores = {
        "file_created": 0.0,
        "primary_name": 0.0,
    }
    workspace = Path(workspace_path)
    path = workspace / "oncall.txt"
    if not path.exists():
        return scores

    scores["file_created"] = 1.0
    text = path.read_text(encoding="utf-8", errors="replace").strip()
    # Accept exact line or name appearing as the only/first person mentioned
    if re.fullmatch(r"Jordan\s+Blake", text, re.IGNORECASE):
        scores["primary_name"] = 1.0
    elif re.search(r"Jordan\s+Blake", text, re.IGNORECASE) and not re.search(
        r"Sam\s+Rivera|Casey\s+Ng", text, re.IGNORECASE
    ):
        scores["primary_name"] = 1.0

    return scores
```

## Additional Notes

- Fixture-only PagerDuty schedule; no live PagerDuty API.
- Reference time is fixed in the prompt: 2026-07-27T15:00:00Z.
