---
id: task_ab_test_lift
name: A/B Test Conversion Lift
category: analysis
grading_type: automated
timeout_seconds: 180
workspace_files:
  - path: "ab.json"
    content: |
      {
        "control_conversions": 80,
        "control_users": 1000,
        "treatment_conversions": 100,
        "treatment_users": 1000
      }
---

## Prompt

Using `ab.json`, compute conversion rates and relative lift:

- `control_rate` = control_conversions / control_users
- `treatment_rate` = treatment_conversions / treatment_users
- `lift_percent` = ((treatment_rate − control_rate) / control_rate) * 100

Write `lift.json`:

```json
{
  "control_rate": 0.08,
  "treatment_rate": 0.10,
  "lift_percent": 25
}
```

Rates may be decimals. `lift_percent` may be `25` or `25%`.

## Expected Behavior

- control_rate = 80/1000 = 0.08
- treatment_rate = 100/1000 = 0.10
- lift_percent = ((0.10 − 0.08) / 0.08) * 100 = 25%

## Grading Criteria

- [ ] `lift.json` created
- [ ] Valid JSON
- [ ] control_rate is 0.08
- [ ] treatment_rate is 0.10
- [ ] lift_percent is 25

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import json

    scores = {
        "file_created": 0.0,
        "valid_json": 0.0,
        "control_rate_correct": 0.0,
        "treatment_rate_correct": 0.0,
        "lift_percent_correct": 0.0,
    }
    workspace = Path(workspace_path)
    path = workspace / "lift.json"
    if not path.exists():
        return scores

    scores["file_created"] = 1.0
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except Exception:
        return scores

    if not isinstance(data, dict):
        return scores
    scores["valid_json"] = 1.0

    def as_float(v):
        if isinstance(v, str):
            return float(v.strip().replace("%", ""))
        return float(v)

    def rate_ok(key, expected):
        if key not in data:
            return 0.0
        try:
            val = as_float(data[key])
            if val > 1:
                # percent form e.g. 8 for 0.08
                return 1.0 if abs(val - expected * 100) <= 0.5 else 0.0
            return 1.0 if abs(val - expected) <= 0.005 else 0.0
        except (TypeError, ValueError):
            return 0.0

    scores["control_rate_correct"] = rate_ok("control_rate", 0.08)
    scores["treatment_rate_correct"] = rate_ok("treatment_rate", 0.10)

    if "lift_percent" in data:
        try:
            lift = as_float(data["lift_percent"])
            # accept 25 or 0.25 (fractional lift)
            if abs(lift - 25) <= 0.5 or abs(lift - 0.25) <= 0.005:
                scores["lift_percent_correct"] = 1.0
        except (TypeError, ValueError):
            pass
    return scores
```
