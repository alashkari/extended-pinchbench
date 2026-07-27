---
id: task_survey_likert_summary
name: Survey Likert Score Summary
category: analysis
grading_type: automated
timeout_seconds: 180
workspace_files:
  - path: "survey.csv"
    content: |
      respondent_id,q1,q2,q3
      R1,4,2,5
      R2,5,4,5
      R3,3,3,5
      R4,4,3,1
---

## Prompt

Summarize the Likert survey responses in `survey.csv`. Columns `q1`, `q2`, and `q3` are integer scores from 1 to 5.

Write `summary.json` with the arithmetic means:

```json
{
  "mean_q1": 4.0,
  "mean_q2": 3.0,
  "mean_q3": 4.0
}
```

Use floating-point means. Exact values for this fixture: mean_q1=4.0, mean_q2=3.0, mean_q3=4.0.

## Expected Behavior

The agent parses the four survey rows and computes:

- q1: (4+5+3+4)/4 = 4.0
- q2: (2+4+3+3)/4 = 3.0
- q3: (5+5+5+1)/4 = 4.0

Writes those means to `summary.json`.

## Grading Criteria

- [ ] `summary.json` created
- [ ] Valid JSON
- [ ] mean_q1 is 4.0
- [ ] mean_q2 is 3.0
- [ ] mean_q3 is 4.0

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import json

    scores = {
        "file_created": 0.0,
        "valid_json": 0.0,
        "mean_q1_correct": 0.0,
        "mean_q2_correct": 0.0,
        "mean_q3_correct": 0.0,
    }
    workspace = Path(workspace_path)
    path = workspace / "summary.json"
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

    def near(key, expected, tol=0.01):
        if key not in data:
            return 0.0
        try:
            return 1.0 if abs(float(data[key]) - expected) <= tol else 0.0
        except (TypeError, ValueError):
            return 0.0

    scores["mean_q1_correct"] = near("mean_q1", 4.0)
    scores["mean_q2_correct"] = near("mean_q2", 3.0)
    scores["mean_q3_correct"] = near("mean_q3", 4.0)
    return scores
```
