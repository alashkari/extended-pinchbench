---
id: task_csv_gdp_top5_africa
name: Top 5 African Economies by 2014 GDP
category: csv_analysis
grading_type: automated
timeout_seconds: 180
workspace_files:
  - source: csvs/world_gdp_2014.csv
    dest: world_gdp_2014.csv
---

## Prompt

Using `world_gdp_2014.csv` (COUNTRY, GDP (BILLIONS), CODE), identify the top 5 African countries by GDP.

Write `africa_top5.json` as a list of objects `{country, gdp}` sorted descending by gdp.

Treat these as African (non-exhaustive guidance): Nigeria, South Africa, Egypt, Algeria, Angola, Morocco, Kenya, Ethiopia, etc. Exclude non-African countries.

## Expected Behavior

Expected top 5: Nigeria 594.3, South Africa 341.2, Egypt 284.9, Algeria 227.8, Angola 131.4.

## Grading Criteria

- [ ] File created
- [ ] First country Nigeria
- [ ] Second South Africa
- [ ] List length 5
- [ ] Nigeria GDP ~594

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import json
    scores = {k: 0.0 for k in ["file_created","first","second","length","nigeria_gdp"]}
    path = Path(workspace_path) / "africa_top5.json"
    if not path.exists():
        return scores
    scores["file_created"] = 1.0
    try:
        data = json.loads(path.read_text())
    except Exception:
        return scores
    if not isinstance(data, list):
        return scores
    scores["length"] = 1.0 if len(data) == 5 else (0.5 if len(data) >= 3 else 0.0)
    def cname(row):
        if isinstance(row, dict):
            return str(row.get("country") or row.get("COUNTRY") or "")
        return str(row)
    def cgdp(row):
        if isinstance(row, dict):
            return float(row.get("gdp") or row.get("GDP") or row.get("GDP (BILLIONS)") or 0)
        return 0.0
    if data:
        scores["first"] = 1.0 if "nigeria" in cname(data[0]).lower() else 0.0
    if len(data) > 1:
        scores["second"] = 1.0 if "south africa" in cname(data[1]).lower() else 0.0
    if data:
        g = cgdp(data[0])
        scores["nigeria_gdp"] = 1.0 if 590 <= g <= 600 else (0.5 if 500 <= g <= 650 else 0.0)
    return scores

```
