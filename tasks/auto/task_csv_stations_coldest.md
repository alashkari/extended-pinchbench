---
id: task_csv_stations_coldest
name: Northernmost Idaho Weather Station
category: csv_analysis
grading_type: automated
timeout_seconds: 180
workspace_files:
  - source: csvs/idaho_weather_stations.csv
    dest: idaho_weather_stations.csv
---

## Prompt

Using `idaho_weather_stations.csv`, find the northernmost station by Latitude (highest latitude). Latitudes may be in `DD MM SS` format.

Write `northernmost_station.json` with `station_name`, `latitude_decimal` (float), and `elevation_feet`.

## Expected Behavior

Expected: PORTHILL at latitude 49.0, elevation 1775.

## Grading Criteria

- [ ] File created
- [ ] station_name is PORTHILL
- [ ] latitude_decimal approximately 49
- [ ] elevation_feet is 1775

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import json
    scores = {k: 0.0 for k in ["file_created","name","lat","elev"]}
    path = Path(workspace_path) / "northernmost_station.json"
    if not path.exists():
        return scores
    scores["file_created"] = 1.0
    try:
        data = json.loads(path.read_text())
    except Exception:
        return scores
    name = str(data.get("station_name") or data.get("name") or "")
    scores["name"] = 1.0 if "porthill" in name.lower() else 0.0
    try:
        lat = float(data.get("latitude_decimal") or data.get("latitude") or 0)
        scores["lat"] = 1.0 if abs(lat - 49.0) < 0.05 else (0.5 if abs(lat-49)<0.2 else 0.0)
    except Exception:
        pass
    try:
        elev = float(str(data.get("elevation_feet") or data.get("elevation") or 0).replace(",",""))
        scores["elev"] = 1.0 if abs(elev - 1775) < 1 else 0.0
    except Exception:
        pass
    return scores

```
