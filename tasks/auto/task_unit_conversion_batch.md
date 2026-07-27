---
id: task_unit_conversion_batch
name: Batch Unit Conversion
category: analysis
grading_type: automated
timeout_seconds: 180
workspace_files:
  - path: "measures.json"
    content: |
      {
        "conversions": [
          {"id": "m1", "value": 10, "from_unit": "km", "to_unit": "miles"},
          {"id": "m2", "value": 25, "from_unit": "C", "to_unit": "F"},
          {"id": "m3", "value": 5, "from_unit": "kg", "to_unit": "lb"}
        ]
      }
---

## Prompt

Convert each measurement in `measures.json` using these fixed formulas:

- km → miles: `miles = km * 0.621371`
- C → F: `F = C * 9/5 + 32`
- kg → lb: `lb = kg * 2.20462`

Write `converted.json` with the results:

```json
{
  "results": [
    {"id": "m1", "value": 6.21371},
    {"id": "m2", "value": 77.0},
    {"id": "m3", "value": 11.0231}
  ]
}
```

Approximate values within a small tolerance are fine.

## Expected Behavior

- m1: 10 * 0.621371 = 6.21371 miles
- m2: 25 * 9/5 + 32 = 77.0 °F
- m3: 5 * 2.20462 = 11.0231 lb

## Grading Criteria

- [ ] `converted.json` created
- [ ] Valid JSON
- [ ] m1 ≈ 6.21371
- [ ] m2 ≈ 77.0
- [ ] m3 ≈ 11.0231

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import json

    scores = {
        "file_created": 0.0,
        "valid_json": 0.0,
        "m1_correct": 0.0,
        "m2_correct": 0.0,
        "m3_correct": 0.0,
    }
    workspace = Path(workspace_path)
    path = workspace / "converted.json"
    if not path.exists():
        return scores

    scores["file_created"] = 1.0
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except Exception:
        return scores

    scores["valid_json"] = 1.0

    by_id = {}
    results = data
    if isinstance(data, dict):
        results = data.get("results", data.get("conversions", data.get("converted", data)))
    if isinstance(results, list):
        for item in results:
            if isinstance(item, dict) and "id" in item:
                by_id[str(item["id"])] = item.get("value", item.get("result", item.get("converted")))
    elif isinstance(results, dict):
        # either id->value or id->{value:...}
        for k, v in results.items():
            if isinstance(v, dict):
                by_id[str(k)] = v.get("value", v.get("result", v.get("converted")))
            else:
                by_id[str(k)] = v

    expected = {
        "m1": 6.21371,
        "m2": 77.0,
        "m3": 11.0231,
    }
    key_map = {"m1": "m1_correct", "m2": "m2_correct", "m3": "m3_correct"}
    tol = {"m1": 0.01, "m2": 0.1, "m3": 0.01}

    for mid, exp in expected.items():
        if mid not in by_id:
            continue
        try:
            got = float(by_id[mid])
            if abs(got - exp) <= tol[mid]:
                scores[key_map[mid]] = 1.0
        except (TypeError, ValueError):
            pass
    return scores
```
