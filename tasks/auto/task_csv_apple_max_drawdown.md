---
id: task_csv_apple_max_drawdown
name: Apple 2014 Maximum Drawdown
category: csv_analysis
grading_type: automated
timeout_seconds: 180
workspace_files:
  - source: csvs/apple_stock_2014.csv
    dest: apple_stock_2014.csv
---

## Prompt

I have `apple_stock_2014.csv` with columns `AAPL_x` (date) and `AAPL_y` (adjusted close) for Apple stock in 2014.

Compute the **maximum drawdown** over the year: the largest peak-to-trough decline as a percentage of the peak price (using running peak from the start of the series).

Write `max_drawdown_report.json` with:
- `max_drawdown_pct`: the drawdown percentage (positive number)
- `peak_date` and `peak_price`
- `trough_date` and `trough_price`

Use the first occurrence of the peak that leads to the maximum drawdown.

## Expected Behavior

The agent should read the CSV, track a running peak, compute (peak-price)/peak for each day, and find the maximum. Expected: ~10.9% drawdown from 2014-01-02 ($77.45) to 2014-01-31 ($69.00).

## Grading Criteria

- [ ] Report file `max_drawdown_report.json` created
- [ ] max_drawdown_pct approximately 10.9 (10.5–11.3)
- [ ] peak_date is 2014-01-02
- [ ] trough_date is 2014-01-31
- [ ] peak and trough prices approximately correct

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import json
    scores = {k: 0.0 for k in ["file_created","drawdown_pct","peak_date","trough_date","prices_ok"]}
    path = Path(workspace_path) / "max_drawdown_report.json"
    if not path.exists():
        return scores
    scores["file_created"] = 1.0
    try:
        data = json.loads(path.read_text())
    except Exception:
        return scores
    pct = float(data.get("max_drawdown_pct", -1))
    if 10.5 <= pct <= 11.3:
        scores["drawdown_pct"] = 1.0
    elif 10.0 <= pct <= 12.0:
        scores["drawdown_pct"] = 0.5
    scores["peak_date"] = 1.0 if str(data.get("peak_date", "")).startswith("2014-01-02") else 0.0
    scores["trough_date"] = 1.0 if str(data.get("trough_date", "")).startswith("2014-01-31") else 0.0
    try:
        peak_p = float(data.get("peak_price", 0))
        trough_p = float(data.get("trough_price", 0))
        scores["prices_ok"] = 1.0 if (76.5 <= peak_p <= 78.5 and 68.0 <= trough_p <= 70.0) else 0.0
    except Exception:
        scores["prices_ok"] = 0.0
    return scores

```
