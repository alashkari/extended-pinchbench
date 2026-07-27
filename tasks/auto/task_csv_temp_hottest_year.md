---
id: task_csv_temp_hottest_year
name: Hottest Year in Global Temperature Record
category: csv_analysis
grading_type: automated
timeout_seconds: 180
workspace_files:
  - source: csvs/global_temperature.csv
    dest: global_temperature.csv
---

## Prompt

The file `global_temperature.csv` has columns Source, Year (YYYY-MM monthly), and Mean (temperature anomaly).

Compute the average Mean for each calendar year (across months) and find the hottest year (highest annual average).

Write `hottest_year.json` with `year` (YYYY string or int) and `mean_anomaly`.

## Expected Behavior

Expected hottest year is 2024 with mean anomaly approximately 1.1755.

## Grading Criteria

- [ ] File created
- [ ] year is 2024
- [ ] mean_anomaly approximately 1.18 (1.10–1.25)

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import json
    scores = {"file_created": 0.0, "year": 0.0, "mean": 0.0}
    path = Path(workspace_path) / "hottest_year.json"
    if not path.exists():
        return scores
    scores["file_created"] = 1.0
    try:
        data = json.loads(path.read_text())
    except Exception:
        return scores
    y = str(data.get("year", ""))
    scores["year"] = 1.0 if y == "2024" or y.endswith("2024") else 0.0
    try:
        m = float(data.get("mean_anomaly", data.get("mean", -999)))
        scores["mean"] = 1.0 if 1.10 <= m <= 1.25 else (0.5 if 1.0 <= m <= 1.3 else 0.0)
    except Exception:
        pass
    return scores

```
