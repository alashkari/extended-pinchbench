---
id: task_integration_stripe_refunds_report
name: Stripe Refunds Report
category: integrations
grading_type: automated
timeout_seconds: 180
workspace_files:
  - path: "charges.csv"
    content: |
      charge_id,amount,currency,refunded
      ch_01,4999,usd,true
      ch_02,1200,usd,false
      ch_03,2500,usd,true
      ch_04,999,usd,false
      ch_05,7500,usd,true
      ch_06,300,usd,false
---

## Prompt

Read `charges.csv`. Amounts are in cents. The `refunded` column is a boolean (`true`/`false`).

Compute:
- `total_refunded_cents` — sum of `amount` for rows where `refunded` is true
- `count` — number of refunded charges

Write `refunds_report.json` as:

```json
{
  "total_refunded_cents": 14999,
  "count": 3
}
```

(Use the correct totals for this fixture.)

## Expected Behavior

Refunded charges are ch_01 (4999), ch_03 (2500), and ch_05 (7500). Total is 14999 cents across 3 charges.

## Grading Criteria

- [ ] refunds_report.json exists
- [ ] Valid JSON
- [ ] total_refunded_cents is 14999
- [ ] count is 3

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import json

    scores = {
        "file_created": 0.0,
        "valid_json": 0.0,
        "total_refunded_cents": 0.0,
        "count": 0.0,
    }
    workspace = Path(workspace_path)
    path = workspace / "refunds_report.json"
    if not path.exists():
        return scores

    scores["file_created"] = 1.0
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except Exception:
        return scores

    if not isinstance(data, dict):
        return scores

    scores["valid_json"] = 1.0

    total = data.get("total_refunded_cents", data.get("total_refunded"))
    try:
        if int(total) == 14999:
            scores["total_refunded_cents"] = 1.0
    except (TypeError, ValueError):
        pass

    count = data.get("count", data.get("refund_count"))
    try:
        if int(count) == 3:
            scores["count"] = 1.0
    except (TypeError, ValueError):
        pass

    return scores
```

## Additional Notes

- Fixture-only Stripe charges CSV; no live Stripe API.
