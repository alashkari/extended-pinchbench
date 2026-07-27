---
id: task_csv_iris_feature_means
name: Iris Per-Species Feature Means
category: csv_analysis
grading_type: automated
timeout_seconds: 180
workspace_files:
  - source: csvs/iris_flowers.csv
    dest: iris_flowers.csv
---

## Prompt

The file `iris_flowers.csv` has columns SepalLength, SepalWidth, PetalLength, PetalWidth, Name (species).

Compute the mean of each numeric feature for each species. Write `iris_means.json` as an object keyed by species name, each value an object of feature means.

Use the exact Name values from the CSV (e.g. Iris-setosa).

## Expected Behavior

Expected approximate means:
- Iris-setosa: SepalLength 5.006, SepalWidth 3.418, PetalLength 1.464, PetalWidth 0.244
- Iris-versicolor: 5.936, 2.77, 4.26, 1.326
- Iris-virginica: 6.588, 2.974, 5.552, 2.026

## Grading Criteria

- [ ] File created
- [ ] All three species present
- [ ] Setosa SepalLength ~5.006
- [ ] Virginica PetalWidth ~2.026
- [ ] Versicolor PetalLength ~4.26

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import json
    scores = {k: 0.0 for k in ["file_created","species_present","setosa_sl","virginica_pw","versicolor_pl"]}
    path = Path(workspace_path) / "iris_means.json"
    if not path.exists():
        return scores
    scores["file_created"] = 1.0
    try:
        data = json.loads(path.read_text())
    except Exception:
        return scores
    # allow keys with or without Iris- prefix flexibility via search
    def find(sp):
        for k,v in data.items():
            if sp.lower() in str(k).lower():
                return v
        return None
    s, ve, vi = find("setosa"), find("versicolor"), find("virginica")
    scores["species_present"] = 1.0 if s and ve and vi else 0.0
    def num(obj, *keys):
        if not obj: return None
        for k in keys:
            for kk,vv in obj.items():
                if k.lower() == kk.lower().replace(" ","").replace("_",""):
                    return float(vv)
            for kk,vv in obj.items():
                if k.lower() in kk.lower().replace("_",""):
                    return float(vv)
        return None
    sl = num(s, "sepallength", "SepalLength")
    scores["setosa_sl"] = 1.0 if sl is not None and abs(sl-5.006)<0.05 else 0.0
    pw = num(vi, "petalwidth", "PetalWidth")
    scores["virginica_pw"] = 1.0 if pw is not None and abs(pw-2.026)<0.05 else 0.0
    pl = num(ve, "petallength", "PetalLength")
    scores["versicolor_pl"] = 1.0 if pl is not None and abs(pl-4.26)<0.05 else 0.0
    return scores

```
