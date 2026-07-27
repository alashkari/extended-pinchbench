---
id: task_csv_iris_sepals_ratio
name: Iris Highest Sepal Length/Width Ratio
category: csv_analysis
grading_type: automated
timeout_seconds: 180
workspace_files:
  - source: csvs/iris_flowers.csv
    dest: iris_flowers.csv
---

## Prompt

Using `iris_flowers.csv`, find the row with the highest SepalLength/SepalWidth ratio.

Write `top_sepal_ratio.json` with:
- `ratio` (float)
- `species` (Name value)
- `sepal_length` and `sepal_width`

## Expected Behavior

Expected top ratio is approximately 2.962 for Iris-virginica (SepalLength/SepalWidth).

## Grading Criteria

- [ ] File created
- [ ] ratio approximately 2.96 (2.90–3.00)
- [ ] species is Iris-virginica
- [ ] sepal dimensions consistent

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import json
    scores = {"file_created": 0.0, "ratio": 0.0, "species": 0.0, "dims": 0.0}
    path = Path(workspace_path) / "top_sepal_ratio.json"
    if not path.exists():
        return scores
    scores["file_created"] = 1.0
    try:
        data = json.loads(path.read_text())
    except Exception:
        return scores
    try:
        r = float(data.get("ratio", 0))
        scores["ratio"] = 1.0 if 2.90 <= r <= 3.00 else (0.5 if 2.8 <= r <= 3.1 else 0.0)
    except Exception:
        pass
    sp = str(data.get("species", ""))
    scores["species"] = 1.0 if "virginica" in sp.lower() else 0.0
    try:
        sl = float(data.get("sepal_length", data.get("SepalLength", 0)))
        sw = float(data.get("sepal_width", data.get("SepalWidth", 0)))
        scores["dims"] = 1.0 if sl > 0 and sw > 0 and abs(sl/sw - float(data.get("ratio", sl/sw))) < 0.05 else 0.0
    except Exception:
        scores["dims"] = 0.0
    return scores

```
