---
id: task_csv_life_exp_delta_china
name: China Life Expectancy Change 1952–2007
category: csv_analysis
grading_type: automated
timeout_seconds: 180
workspace_files:
  - source: csvs/gapminder_life_expectancy.csv
    dest: gapminder_life_expectancy.csv
---

## Prompt

Using `gapminder_life_expectancy.csv` (long format: country, year, pop, continent, lifeExp, gdpPercap), compute China's life expectancy change from 1952 to 2007.

Write `china_life_delta.json` with:
- `life_exp_1952`
- `life_exp_2007`
- `delta` (2007 - 1952)

## Expected Behavior

Expected: 44.0 in 1952, 72.961 in 2007, delta ≈ 28.961.

## Grading Criteria

- [ ] File created
- [ ] life_exp_1952 ≈ 44
- [ ] life_exp_2007 ≈ 72.96
- [ ] delta ≈ 28.96

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import json
    scores = {k: 0.0 for k in ["file_created","y1952","y2007","delta"]}
    path = Path(workspace_path) / "china_life_delta.json"
    if not path.exists():
        return scores
    scores["file_created"] = 1.0
    try:
        data = json.loads(path.read_text())
        a = float(data.get("life_exp_1952") or data.get("1952") or 0)
        b = float(data.get("life_exp_2007") or data.get("2007") or 0)
        d = float(data.get("delta") or (b-a))
        scores["y1952"] = 1.0 if abs(a-44.0) < 0.1 else 0.0
        scores["y2007"] = 1.0 if abs(b-72.961) < 0.05 else (0.5 if abs(b-72.961)<0.2 else 0.0)
        scores["delta"] = 1.0 if abs(d-28.961) < 0.1 else (0.5 if abs(d-28.961)<0.5 else 0.0)
    except Exception:
        pass
    return scores

```
