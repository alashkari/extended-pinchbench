---
id: task_integration_webhook_replay
name: Webhook Replay Normalization
category: integrations
grading_type: automated
timeout_seconds: 180
workspace_files:
  - path: "webhooks.jsonl"
    content: |
      {"event": {"type": "invoice.paid", "id": "evt_1001", "created": "2026-07-20T10:00:00Z", "amount": 4999}}
      {"event": {"type": "customer.created", "id": "evt_1002", "created": "2026-07-20T11:30:00Z", "email": "a@example.com"}}
      {"event": {"type": "invoice.paid", "id": "evt_1003", "created": "2026-07-21T09:15:00Z", "amount": 1200}}
      {"event": {"type": "charge.failed", "id": "evt_1004", "created": "2026-07-21T14:00:00Z", "reason": "card_declined"}}
      {"event": {"type": "subscription.updated", "id": "evt_1005", "created": "2026-07-22T08:45:00Z", "plan": "pro"}}
---

## Prompt

You have a webhook replay dump at `webhooks.jsonl` (one JSON object per line). Each line wraps a payload under the key `event`.

Normalize every event into a flat object with exactly these fields:
- `type` — from `event.type`
- `id` — from `event.id`
- `timestamp` — from `event.created`

Write the result as a JSON array to `normalized_events.json` in the workspace root. Preserve the original line order.

## Expected Behavior

The agent reads each JSONL line, extracts `type`, `id`, and `created` (as `timestamp`), and writes a JSON array of five objects in order.

## Grading Criteria

- [ ] normalized_events.json exists
- [ ] Valid JSON array with 5 events
- [ ] First event id is evt_1001 with type invoice.paid
- [ ] Event evt_1004 has type charge.failed
- [ ] Last event id is evt_1005

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import json

    scores = {
        "file_created": 0.0,
        "count_five": 0.0,
        "first_event": 0.0,
        "charge_failed": 0.0,
        "last_event": 0.0,
    }
    workspace = Path(workspace_path)
    path = workspace / "normalized_events.json"
    if not path.exists():
        return scores

    scores["file_created"] = 1.0
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except Exception:
        return scores

    if not isinstance(data, list):
        return scores

    if len(data) == 5:
        scores["count_five"] = 1.0

    def _get(obj, *keys):
        if not isinstance(obj, dict):
            return None
        for k in keys:
            if k in obj:
                return obj[k]
        return None

    if data:
        first = data[0]
        if _get(first, "id") == "evt_1001" and _get(first, "type") == "invoice.paid":
            scores["first_event"] = 1.0

    for item in data:
        if _get(item, "id") == "evt_1004" and _get(item, "type") == "charge.failed":
            scores["charge_failed"] = 1.0
            break

    if data and _get(data[-1], "id") == "evt_1005":
        scores["last_event"] = 1.0

    return scores
```

## Additional Notes

- Fixture-only simulation; no live webhook endpoint.
- Extra fields in output objects are acceptable; grading checks id/type/count.
