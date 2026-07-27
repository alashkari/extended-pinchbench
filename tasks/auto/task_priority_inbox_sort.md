---
id: task_priority_inbox_sort
name: Priority Inbox Sort
category: productivity
grading_type: automated
timeout_seconds: 120
workspace_files:
  - path: "emails.json"
    content: |
      {
        "emails": [
          {
            "id": "e1",
            "subject": "Weekly newsletter",
            "from": "news@example.com",
            "urgency": "P3"
          },
          {
            "id": "e2",
            "subject": "Production outage",
            "from": "oncall@example.com",
            "urgency": "P0"
          },
          {
            "id": "e3",
            "subject": "Invoice reminder",
            "from": "billing@example.com",
            "urgency": "P2"
          },
          {
            "id": "e4",
            "subject": "Security patch needed today",
            "from": "sec@example.com",
            "urgency": "P1"
          },
          {
            "id": "e5",
            "subject": "Team lunch photo",
            "from": "fun@example.com",
            "urgency": "P3"
          }
        ]
      }
---

## Prompt

Read `emails.json`. Sort the emails by urgency priority with P0 first, then P1, P2, P3. For equal urgency, keep the original order (stable sort).

Write `prioritized_inbox.json` as:

```json
{
  "ordered_ids": ["e2", "e4", "e3", "e1", "e5"]
}
```

(Use the correct order for this fixture; the example above shows the expected order.)

## Expected Behavior

The agent parses urgency fields, sorts P0 → P1 → P2 → P3 with stable ordering within the same priority, and writes `ordered_ids` as `["e2", "e4", "e3", "e1", "e5"]`.

## Grading Criteria

- [ ] prioritized_inbox.json exists
- [ ] Valid JSON with ordered_ids
- [ ] First ID is e2 (P0)
- [ ] Full order matches expected sequence

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import json

    scores = {
        "file_created": 0.0,
        "valid_json": 0.0,
        "p0_first": 0.0,
        "order_correct": 0.0,
    }
    workspace = Path(workspace_path)
    path = workspace / "prioritized_inbox.json"
    if not path.exists():
        return scores

    scores["file_created"] = 1.0
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except Exception:
        return scores

    ordered = data.get("ordered_ids")
    if not isinstance(ordered, list):
        # also accept a bare list
        if isinstance(data, list):
            ordered = data
        else:
            return scores

    scores["valid_json"] = 1.0
    ordered = [str(x) for x in ordered]
    expected = ["e2", "e4", "e3", "e1", "e5"]

    if ordered and ordered[0] == "e2":
        scores["p0_first"] = 1.0

    if ordered == expected:
        scores["order_correct"] = 1.0

    return scores
```
