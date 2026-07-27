---
id: task_funnel_conversion_calc
name: Funnel Step Conversion Rates
category: analysis
grading_type: automated
timeout_seconds: 180
workspace_files:
  - path: "funnel.json"
    content: |
      {
        "stages": {
          "visitors": 1000,
          "signup": 250,
          "activate": 100,
          "purchase": 25
        }
      }
---

## Prompt

Using the funnel counts in `funnel.json`, compute **step conversion rates** (each stage divided by the previous stage):

- `signup_rate` = signup / visitors
- `activate_rate` = activate / signup
- `purchase_rate` = purchase / activate

Write `conversions.json`:

```json
{
  "signup_rate": 0.25,
  "activate_rate": 0.4,
  "purchase_rate": 0.25
}
```

Rates may be decimals (0.25) or percentages (25). Either form is acceptable.

## Expected Behavior

The agent computes:

- signup_rate = 250/1000 = 0.25 (25%)
- activate_rate = 100/250 = 0.4 (40%)
- purchase_rate = 25/100 = 0.25 (25%)

## Grading Criteria

- [ ] `conversions.json` created
- [ ] Valid JSON
- [ ] signup_rate correct (0.25 or 25%)
- [ ] activate_rate correct (0.4 or 40%)
- [ ] purchase_rate correct (0.25 or 25%)

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import json

    scores = {
        "file_created": 0.0,
        "valid_json": 0.0,
        "signup_rate_correct": 0.0,
        "activate_rate_correct": 0.0,
        "purchase_rate_correct": 0.0,
    }
    workspace = Path(workspace_path)
    path = workspace / "conversions.json"
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

    def rate_ok(key, expected_frac):
        if key not in data:
            return 0.0
        raw = data[key]
        try:
            if isinstance(raw, str):
                s = raw.strip().replace("%", "")
                val = float(s)
                if "%" in str(raw):
                    return 1.0 if abs(val - expected_frac * 100) <= 0.5 else 0.0
                # bare number in string: treat as fraction if <= 1 else percent
                if val > 1:
                    return 1.0 if abs(val - expected_frac * 100) <= 0.5 else 0.0
                return 1.0 if abs(val - expected_frac) <= 0.01 else 0.0
            val = float(raw)
            if val > 1:
                return 1.0 if abs(val - expected_frac * 100) <= 0.5 else 0.0
            return 1.0 if abs(val - expected_frac) <= 0.01 else 0.0
        except (TypeError, ValueError):
            return 0.0

    scores["signup_rate_correct"] = rate_ok("signup_rate", 0.25)
    scores["activate_rate_correct"] = rate_ok("activate_rate", 0.4)
    scores["purchase_rate_correct"] = rate_ok("purchase_rate", 0.25)
    return scores
```
