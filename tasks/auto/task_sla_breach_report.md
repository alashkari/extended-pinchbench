---
id: task_sla_breach_report
name: SLA Breach Ticket Report
category: analysis
grading_type: automated
timeout_seconds: 180
workspace_files:
  - path: "tickets.json"
    content: |
      {
        "tickets": [
          {
            "id": "T-401",
            "created": "2026-03-10T09:00:00",
            "resolved": "2026-03-10T12:00:00",
            "sla_hours": 4
          },
          {
            "id": "T-402",
            "created": "2026-03-10T08:00:00",
            "resolved": "2026-03-10T14:30:00",
            "sla_hours": 4
          },
          {
            "id": "T-403",
            "created": "2026-03-11T10:00:00",
            "resolved": "2026-03-11T11:00:00",
            "sla_hours": 2
          },
          {
            "id": "T-404",
            "created": "2026-03-11T09:00:00",
            "resolved": "2026-03-12T10:00:00",
            "sla_hours": 24
          }
        ]
      }
---

## Prompt

Review support tickets in `tickets.json`. Each ticket has `created`, `resolved` (ISO timestamps), and `sla_hours`.

A ticket **breaches SLA** when the elapsed time from created to resolved is strictly greater than `sla_hours`.

Write `breaches.json` listing the breached ticket ids:

```json
{
  "breached_ids": ["T-402", "T-404"]
}
```

Order does not matter. Include only tickets that exceeded their SLA.

## Expected Behavior

- T-401: 3 hours ≤ 4 → OK
- T-402: 6.5 hours > 4 → breach
- T-403: 1 hour ≤ 2 → OK
- T-404: 25 hours > 24 → breach

Expected ids: `T-402`, `T-404`.

## Grading Criteria

- [ ] `breaches.json` created
- [ ] Valid JSON with a list of ids
- [ ] T-402 is included
- [ ] T-404 is included
- [ ] No false positives (T-401 / T-403 excluded)

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import json

    scores = {
        "file_created": 0.0,
        "valid_json": 0.0,
        "t402_included": 0.0,
        "t404_included": 0.0,
        "no_false_positives": 0.0,
    }
    workspace = Path(workspace_path)
    path = workspace / "breaches.json"
    if not path.exists():
        return scores

    scores["file_created"] = 1.0
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except Exception:
        return scores

    ids = []
    if isinstance(data, dict):
        raw = data.get("breached_ids", data.get("breaches", data.get("ids", [])))
        if isinstance(raw, list):
            for item in raw:
                if isinstance(item, str):
                    ids.append(item)
                elif isinstance(item, dict):
                    ids.append(str(item.get("id", item.get("ticket_id", ""))))
    elif isinstance(data, list):
        for item in data:
            if isinstance(item, str):
                ids.append(item)
            elif isinstance(item, dict):
                ids.append(str(item.get("id", item.get("ticket_id", ""))))

    scores["valid_json"] = 1.0
    id_set = set(ids)

    scores["t402_included"] = 1.0 if "T-402" in id_set else 0.0
    scores["t404_included"] = 1.0 if "T-404" in id_set else 0.0
    scores["no_false_positives"] = (
        1.0 if ("T-401" not in id_set and "T-403" not in id_set) else 0.0
    )
    return scores
```
