---
id: task_csv_cities_midwest_count
name: Count Midwest Cities in Top 1000
category: csv_analysis
grading_type: automated
timeout_seconds: 180
workspace_files:
  - source: csvs/us_cities_top1000.csv
    dest: us_cities_top1000.csv
---

## Prompt

Using `us_cities_top1000.csv` (City, State, Population, lat, lon), count how many cities are in the Midwest.

Midwest states: Illinois, Indiana, Iowa, Kansas, Michigan, Minnesota, Missouri, Nebraska, North Dakota, Ohio, South Dakota, Wisconsin.

Write `midwest_count.json` with `count` and `states_used` (list).

## Expected Behavior

Expected count is 231.

## Grading Criteria

- [ ] File created
- [ ] count is 231
- [ ] states_used includes Ohio and Illinois

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import json
    scores = {"file_created": 0.0, "count": 0.0, "states": 0.0}
    path = Path(workspace_path) / "midwest_count.json"
    if not path.exists():
        return scores
    scores["file_created"] = 1.0
    try:
        data = json.loads(path.read_text())
    except Exception:
        return scores
    try:
        c = int(data.get("count", -1))
        scores["count"] = 1.0 if c == 231 else (0.5 if abs(c-231) <= 5 else 0.0)
    except Exception:
        pass
    states = data.get("states_used") or data.get("states") or []
    joined = " ".join(str(s) for s in states).lower() if isinstance(states, list) else str(states).lower()
    scores["states"] = 1.0 if ("ohio" in joined and "illinois" in joined) else 0.0
    return scores

```
