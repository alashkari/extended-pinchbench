---
id: task_invoice_total_reconcile
name: Invoice Total Reconciliation
category: analysis
grading_type: automated
timeout_seconds: 180
workspace_files:
  - path: "invoices.json"
    content: |
      {
        "invoices": [
          {
            "id": "INV-1001",
            "total": 150.00,
            "lines": [
              {"description": "Widget A", "amount": 100.00},
              {"description": "Widget B", "amount": 50.00}
            ]
          },
          {
            "id": "INV-1002",
            "total": 200.00,
            "lines": [
              {"description": "Service retainer", "amount": 75.00},
              {"description": "Rush fee", "amount": 100.00}
            ]
          },
          {
            "id": "INV-1003",
            "total": 80.00,
            "lines": [
              {"description": "Shipping", "amount": 80.00}
            ]
          }
        ]
      }
---

## Prompt

Reconcile the invoices in `invoices.json`. For each invoice, compare the `total` field to the sum of its line-item `amount` values.

Write `mismatch_report.json` listing every invoice whose line-item sum does **not** equal `total`:

```json
{
  "mismatched_ids": ["INV-1002"]
}
```

Use the invoice `id` values exactly as given. If every invoice matches, write an empty list.

## Expected Behavior

The agent reads `invoices.json`, sums each invoice's line amounts, and compares to `total`.

- INV-1001: 100 + 50 = 150 (matches)
- INV-1002: 75 + 100 = 175 ≠ 200 (mismatch)
- INV-1003: 80 = 80 (matches)

Output should list only `INV-1002`.

## Grading Criteria

- [ ] `mismatch_report.json` created
- [ ] Valid JSON with a list of mismatched ids
- [ ] INV-1002 is reported as mismatched
- [ ] INV-1001 is not reported
- [ ] INV-1003 is not reported

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import json

    scores = {
        "file_created": 0.0,
        "valid_json": 0.0,
        "inv_1002_flagged": 0.0,
        "inv_1001_not_flagged": 0.0,
        "inv_1003_not_flagged": 0.0,
    }
    workspace = Path(workspace_path)
    path = workspace / "mismatch_report.json"
    if not path.exists():
        return scores

    scores["file_created"] = 1.0
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except Exception:
        return scores

    ids = []
    if isinstance(data, dict):
        raw = data.get("mismatched_ids", data.get("mismatches", data.get("ids", [])))
        if isinstance(raw, list):
            ids = [str(x) for x in raw]
        elif isinstance(raw, dict):
            ids = [str(k) for k in raw.keys()]
    elif isinstance(data, list):
        for item in data:
            if isinstance(item, str):
                ids.append(item)
            elif isinstance(item, dict):
                ids.append(str(item.get("id", item.get("invoice_id", ""))))

    scores["valid_json"] = 1.0
    id_set = set(ids)

    scores["inv_1002_flagged"] = 1.0 if "INV-1002" in id_set else 0.0
    scores["inv_1001_not_flagged"] = 1.0 if "INV-1001" not in id_set else 0.0
    scores["inv_1003_not_flagged"] = 1.0 if "INV-1003" not in id_set else 0.0
    return scores
```
