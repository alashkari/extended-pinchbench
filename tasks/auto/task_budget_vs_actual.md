---
id: task_budget_vs_actual
name: Budget vs Actual Variance
category: analysis
grading_type: automated
timeout_seconds: 180
workspace_files:
  - path: "budget.csv"
    content: |
      category,amount
      marketing,10000
      engineering,50000
      ops,8000
      facilities,12000
  - path: "actual.csv"
    content: |
      category,amount
      marketing,11500
      engineering,48000
      ops,8000
      facilities,13500
---

## Prompt

Compare `budget.csv` and `actual.csv`. For each category, compute variance as **actual − budget**.

Write `variance.json` mapping category → variance:

```json
{
  "marketing": 1500,
  "engineering": -2000,
  "ops": 0,
  "facilities": 1500
}
```

Use the category names exactly as in the CSVs.

## Expected Behavior

The agent joins on category and subtracts budget from actual:

- marketing: 11500 − 10000 = 1500
- engineering: 48000 − 50000 = −2000
- ops: 8000 − 8000 = 0
- facilities: 13500 − 12000 = 1500

## Grading Criteria

- [ ] `variance.json` created
- [ ] Valid JSON object
- [ ] marketing variance is 1500
- [ ] engineering variance is -2000
- [ ] ops variance is 0
- [ ] facilities variance is 1500

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import json

    scores = {
        "file_created": 0.0,
        "valid_json": 0.0,
        "marketing_correct": 0.0,
        "engineering_correct": 0.0,
        "ops_correct": 0.0,
        "facilities_correct": 0.0,
    }
    workspace = Path(workspace_path)
    path = workspace / "variance.json"
    if not path.exists():
        return scores

    scores["file_created"] = 1.0
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except Exception:
        return scores

    if not isinstance(data, dict):
        return scores

    # Unwrap common nesting
    if "variance" in data and isinstance(data["variance"], dict):
        data = data["variance"]
    elif "variances" in data and isinstance(data["variances"], dict):
        data = data["variances"]

    scores["valid_json"] = 1.0

    expected = {
        "marketing": 1500,
        "engineering": -2000,
        "ops": 0,
        "facilities": 1500,
    }
    key_map = {
        "marketing": "marketing_correct",
        "engineering": "engineering_correct",
        "ops": "ops_correct",
        "facilities": "facilities_correct",
    }
    for cat, exp in expected.items():
        if cat not in data:
            continue
        try:
            if abs(float(data[cat]) - exp) < 0.01:
                scores[key_map[cat]] = 1.0
        except (TypeError, ValueError):
            pass
    return scores
```
