---
id: task_expense_receipt_log
name: Expense Receipt Category Totals
category: productivity
grading_type: automated
timeout_seconds: 120
workspace_files:
  - path: "receipts.csv"
    content: |
      id,category,amount,date
      r1,travel,42.50,2026-07-01
      r2,meals,18.75,2026-07-02
      r3,travel,120.00,2026-07-03
      r4,office,9.99,2026-07-04
      r5,meals,26.25,2026-07-05
      r6,office,15.01,2026-07-06
      r7,travel,33.50,2026-07-07
---

## Prompt

Read `receipts.csv` and compute the sum of `amount` for each `category`.

Write `totals.json` with exact totals (two decimal places as numbers):

```json
{
  "totals": {
    "travel": 196.0,
    "meals": 45.0,
    "office": 25.0
  }
}
```

Use these exact values for this fixture:
- travel = 42.50 + 120.00 + 33.50 = 196.00
- meals = 18.75 + 26.25 = 45.00
- office = 9.99 + 15.01 = 25.00

## Expected Behavior

The agent parses the CSV, groups by category, sums amounts, and writes `totals.json` with travel=196, meals=45, office=25 (float equality within a tiny epsilon is acceptable in grading).

## Grading Criteria

- [ ] totals.json exists
- [ ] Valid JSON with totals object
- [ ] travel total is 196.00
- [ ] meals total is 45.00
- [ ] office total is 25.00

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import json

    scores = {
        "file_created": 0.0,
        "valid_json": 0.0,
        "travel_total": 0.0,
        "meals_total": 0.0,
        "office_total": 0.0,
    }
    workspace = Path(workspace_path)
    path = workspace / "totals.json"
    if not path.exists():
        return scores

    scores["file_created"] = 1.0
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except Exception:
        return scores

    totals = data.get("totals", data)
    if not isinstance(totals, dict):
        return scores
    scores["valid_json"] = 1.0

    def close(val, expected):
        try:
            return abs(float(val) - expected) < 0.01
        except Exception:
            return False

    if close(totals.get("travel"), 196.0):
        scores["travel_total"] = 1.0
    if close(totals.get("meals"), 45.0):
        scores["meals_total"] = 1.0
    if close(totals.get("office"), 25.0):
        scores["office_total"] = 1.0

    return scores
```
