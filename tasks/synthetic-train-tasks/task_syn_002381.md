---
id: task_syn_002381
name: Quantitative reading summary 002381
category: statistical_quantitative_analysis
grading_type: automated
timeout_seconds: 150
workspace_files:
- source: task_syn_002381/workspace/measurements/readings.csv
  dest: measurements/readings.csv
capability_family: statistical_quantitative_analysis
intended_difficulty_band: 1
base_scenario_id: scenario_001191
generator_seed: 818097
multi_session: false
---

## Prompt

You are working on synthetic task `task_syn_002381` for the `customer migration` scenario `violet-tundra-1191`.
Use only the files supplied in the workspace. Do not fetch live data or use credentials.

Analyze `measurements/readings.csv`. Ignore rows whose group is `ignore` or whose weight is zero. Compute count, mean, median, weighted mean, per-group means, and sample ids with values at least 130.

Scenario-specific audit anchors: memenap ririjoq lufobar luvebas sayabat sasajou luvecev nasapow zefofox povemey yajoguz ridiyaa jonazeb yafosac lulukid tusajoe gujonaf menajog haceyah rifokii pokiguj jopowok fohahal habarim lujozen zejozeo pojomep jotuluq hakiver ribabas nahasat sahakiu saponav podicew wobahax sanahay yawopoz tugucea medirib nagujoc mezeced guyasae rituvef rinayag luharih banatui zenayaj tunawok wozebal hamewom yajolun ponazeo gurijop cewonaq gudirir dijomes merilut ponazeu riluhav veguwow tutuzex zemesay kiwopoz yasakia sariyab dilusac baharid yasapoe tuzeluf yacemeg saguhah baposai hatufoj lusakik hapogul hafodim vegulun jofohao bagurip bapowoq rifonar yaditus fomejot fobahau foluzev hawohaw poyatux cerisay hazekiz havetua jocedib rimeguc kizenad wofovee zekikif guvepog.

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
EXPECTED_OUTPUT = {'result': {'count': 11, 'mean': 54.27, 'median': 52.0, 'weighted_mean': 53.42, 'group_means': {'alpha': 46.0, 'beta': 59.33, 'delta': 63.0, 'gamma': 46.0}, 'outlier_ids': []}, 'evidence': ['measurements/readings.csv'], 'verification': {'checked_files': 1, 'ignored_distractors': False, 'status': 'pass'}}

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
