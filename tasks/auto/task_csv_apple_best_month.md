---
id: task_csv_apple_best_month
name: Apple 2014 Best Monthly Return
category: csv_analysis
grading_type: automated
timeout_seconds: 180
workspace_files:
  - source: csvs/apple_stock_2014.csv
    dest: apple_stock_2014.csv
---

## Prompt

Using `apple_stock_2014.csv` (columns `AAPL_x`, `AAPL_y`), find the calendar month with the highest return, where monthly return = (last close in month - first close in month) / first close in month.

Write `best_month_report.json` with:
- `best_month` as YYYY-MM
- `return_pct` as percentage

## Expected Behavior

Expected best month is 2014-11 with approximately 10.69% return.

## Grading Criteria

- [ ] File `best_month_report.json` created
- [ ] best_month is 2014-11
- [ ] return_pct approximately 10.69 (10.0–11.5)

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import json
    scores = {"file_created": 0.0, "month_correct": 0.0, "return_pct": 0.0}
    path = Path(workspace_path) / "best_month_report.json"
    if not path.exists():
        return scores
    scores["file_created"] = 1.0
    try:
        data = json.loads(path.read_text())
    except Exception:
        return scores
    scores["month_correct"] = 1.0 if str(data.get("best_month", "")) == "2014-11" else 0.0
    try:
        pct = float(data.get("return_pct", -999))
        if 10.0 <= pct <= 11.5:
            scores["return_pct"] = 1.0
        elif 9.0 <= pct <= 12.5:
            scores["return_pct"] = 0.5
    except Exception:
        pass
    return scores

```
