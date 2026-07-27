---
id: task_csv_pension_median
name: Median State Pension Payee Count
category: csv_analysis
grading_type: automated
timeout_seconds: 180
workspace_files:
  - source: csvs/us_pension_by_state.csv
    dest: us_pension_by_state.csv
---

## Prompt

The file `us_pension_by_state.csv` includes many district rows and aggregate rows whose STATE_ABBREV_NAME ends with `Total`.

Using only rows where STATE_ABBREV_NAME ends with `Total` but is not `Grand Total`, compute the **median** of PAYEE_COUNT.

Write `pension_median.json` with `median_payee_count` (number).

## Expected Behavior

Expected median PAYEE_COUNT among * Total rows (excluding Grand Total) is 5456.

## Grading Criteria

- [ ] File created
- [ ] median_payee_count is 5456 (or within 5450–5460)

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import json
    scores = {"file_created": 0.0, "median": 0.0}
    path = Path(workspace_path) / "pension_median.json"
    if not path.exists():
        return scores
    scores["file_created"] = 1.0
    try:
        data = json.loads(path.read_text())
        m = float(data.get("median_payee_count") or data.get("median") or -1)
        scores["median"] = 1.0 if abs(m - 5456) < 1 else (0.5 if abs(m-5456) <= 50 else 0.0)
    except Exception:
        pass
    return scores

```
