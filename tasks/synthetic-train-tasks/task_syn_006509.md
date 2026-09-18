---
id: task_syn_006509
name: Quantitative reading summary 006509
category: statistical_quantitative_analysis
grading_type: automated
timeout_seconds: 240
workspace_files:
- source: task_syn_006509/workspace/measurements/readings.csv
  dest: measurements/readings.csv
capability_family: statistical_quantitative_analysis
intended_difficulty_band: 4
base_scenario_id: scenario_003255
generator_seed: 970833
multi_session: false
---

## Prompt

You are working on synthetic task `task_syn_006509` for the `training roster` scenario `frost-keystone-3255`.
Use only the files supplied in the workspace. Do not fetch live data or use credentials.

Analyze `measurements/readings.csv`. Ignore rows whose group is `ignore` or whose weight is zero. Compute count, mean, median, weighted mean, per-group means, and sample ids with values at least 130.

Scenario-specific audit anchors: sahacej podivek hakicel guvebam lulukin fopoceo luyavep hagubaq vecedir tumedis yaverit gugufou kimebav meworiw sapobax veluhay forijoz fogukia natuhab kinaluc jofopod womekie metuzef rimeveg tumedih wogugui barifoj luhacek dipoyal kinazem gujojon sazefoo saguhap guyaveq kipomer cerives potuzet bafohau cewomev powomew foworix lupodiy didiriz vejocea zetubab kizedic mehanad wotugue gutunaf vepozeg sayayah sajofoi tujovej fojotuk vetupol meguyam zeyakin dikiguo nanamep wojoriq balusar jogujos cesawot nanazeu wosavev gunazew tuvepox haveyay wonabaz diwoyaa poritub najojoc hajogud luguyae cecezef kizegug wopomeh gutuyai lusazej zeguluk zeyawol mekisam yahaven metuguo jofomep pofoveq rijokir luhaces cebanat gufopou yapovev kitutuw satulux disahay yajowoz dijokia.

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
EXPECTED_OUTPUT = {'result': {'count': 17, 'mean': 59.06, 'median': 60.0, 'weighted_mean': 59.63, 'group_means': {'alpha': 61.2, 'beta': 48.75, 'delta': 60.0, 'gamma': 65.75}, 'outlier_ids': []}, 'evidence': ['measurements/readings.csv'], 'verification': {'checked_files': 1, 'ignored_distractors': False, 'status': 'pass'}}

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
