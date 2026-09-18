---
id: task_syn_007685
name: Quantitative reading summary 007685
category: statistical_quantitative_analysis
grading_type: automated
timeout_seconds: 270
workspace_files:
- source: task_syn_007685/workspace/measurements/readings.csv
  dest: measurements/readings.csv
capability_family: statistical_quantitative_analysis
intended_difficulty_band: 5
base_scenario_id: scenario_003843
generator_seed: 1014345
multi_session: false
---

## Prompt

You are working on synthetic task `task_syn_007685` for the `sensor calibration` scenario `violet-cedar-3843`.
Use only the files supplied in the workspace. Do not fetch live data or use credentials.

Analyze `measurements/readings.csv`. Ignore rows whose group is `ignore` or whose weight is zero. Compute count, mean, median, weighted mean, per-group means, and sample ids with values at least 130.

Scenario-specific audit anchors: sapobap riwokiq sagupor ludimes hacekit posaluu lumeluv dibapow guzekix sakiwoy luguwoz hacehaa foyarib baluguc sababad tuhabae luwotuf sahasag naveveh mevepoi guyawoj fokizek hananal lufozem zelunan pogufoo namekip tufobaq samever hamekis nalucet luzemeu lucenav fohasaw lukilux yafopoy mecewoz tucezea gukijob gujodic povepod harigue cezemef nazerig gufoceh sawocei mecezej cerinak woposal pomebam fobatun zehatuo fonavep lulusaq venazer ceyaces dimegut yaveriu zevecev dinahaw zefoyax lumevey guzemez wodivea ririgub riyaric pojosad jonarie kihahaf nawoyag hazerih vedidii yariguj sasajok pogunal cebagum pobawon wodipoo yavedip nakiguq dimezer woveces bamejot wosayau dihajov memebaw cedinax tujodiy saveguz lumedia cezeceb guridic yamewod tutunae ridiluf cezegug.

Create `submission/result.json` using this shape:

```json
{
  "result": { ... family-specific deterministic values ... },
  "evidence": ["relative/source/path.ext"],
  "verification": {
    "checked_files": 1,
    "status": "pass"
  }
}
```

Use relative evidence paths from the workspace. Keep lists sorted when the prompt describes a sort order.
Some supplied information is intentionally irrelevant; exclude it from the result.

## Expected Behavior

A correct solution reads the supplied fixtures, performs the requested transformation or analysis, writes `submission/result.json`, cites relevant relative evidence paths, and records deterministic verification details.

## Grading Criteria

- [ ] format_valid: The submission is parseable JSON with the required top-level keys.
- [ ] answer_correct: The computed result matches the deterministic fixture outcome.
- [ ] evidence_grounded: Evidence paths cite the supplied files used for the result.
- [ ] verification_complete: The verification object accurately records checks, skips, or ignored distractors.

## Automated Checks

```python
from pathlib import Path
import json

CRITERIA = ['format_valid', 'answer_correct', 'evidence_grounded', 'verification_complete']
EXPECTED_OUTPUT = {'result': {'count': 19, 'mean': 54.47, 'median': 54.0, 'weighted_mean': 56.09, 'group_means': {'alpha': 65.25, 'beta': 52.8, 'delta': 50.4, 'gamma': 51.6}, 'outlier_ids': []}, 'evidence': ['measurements/readings.csv'], 'verification': {'checked_files': 1, 'ignored_distractors': True, 'status': 'pass'}}

def _load_json(path):
    try:
        return json.loads(path.read_text(encoding="utf-8"))
    except Exception:
        return None

def _same(expected, actual):
    if isinstance(expected, float):
        return isinstance(actual, (int, float)) and abs(float(actual) - expected) <= 0.01
    if isinstance(expected, dict):
        return isinstance(actual, dict) and set(expected) == set(actual) and all(
            _same(expected[key], actual[key]) for key in expected
        )
    if isinstance(expected, list):
        return isinstance(actual, list) and len(expected) == len(actual) and all(
            _same(left, right) for left, right in zip(expected, actual)
        )
    return expected == actual

def grade(transcript, workspace_dir):
    scores = {key: 0.0 for key in CRITERIA}
    output = Path(workspace_dir) / "submission" / "result.json"
    data = _load_json(output)
    if not isinstance(data, dict):
        return scores
    scores["format_valid"] = 1.0
    scores["answer_correct"] = 1.0 if _same(EXPECTED_OUTPUT.get("result"), data.get("result")) else 0.0
    scores["evidence_grounded"] = 1.0 if _same(EXPECTED_OUTPUT.get("evidence"), data.get("evidence")) else 0.0
    scores["verification_complete"] = 1.0 if _same(EXPECTED_OUTPUT.get("verification"), data.get("verification")) else 0.0
    return scores

def create_reference_solution(workspace_dir):
    output = Path(workspace_dir) / "submission" / "result.json"
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(json.dumps(EXPECTED_OUTPUT, indent=2, sort_keys=True) + "\n", encoding="utf-8")

def create_incorrect_solution(workspace_dir):
    output = Path(workspace_dir) / "submission" / "result.json"
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(json.dumps({"result": {}, "evidence": [], "verification": {"status": "unchecked"}}) + "\n", encoding="utf-8")
```

## LLM Judge Rubric

Not applicable; objective automated checks define the task score.

## Additional Notes

All names, records, source pages, logs, and code fixtures in this task are synthetic. Do not infer a final model route or model tier from this metadata.
