---
id: task_syn_006436
name: Structured table normalization 006436
category: structured_data_transformation
grading_type: automated
timeout_seconds: 150
workspace_files:
- source: task_syn_006436/workspace/tables/source_records.csv
  dest: tables/source_records.csv
- source: task_syn_006436/workspace/tables/region_map.json
  dest: tables/region_map.json
capability_family: structured_data_transformation
intended_difficulty_band: 1
base_scenario_id: scenario_003218
generator_seed: 968132
multi_session: false
---

## Prompt

You are working on synthetic task `task_syn_006436` for the `billing review` scenario `umbra-ion-3218`.
Use only the files supplied in the workspace. Do not fetch live data or use credentials.

Transform `tables/source_records.csv` using `tables/region_map.json`. Keep only active rows with `units * unit_cost >= 93`, uppercase each id, map regions to zones, sort by zone then id, and report how many malformed rows were skipped.

Scenario-specific audit anchors: cekikio veturip tucehaq mekizer zezejos vebazet najofou forijov banakiw vetuzex harijoy difomez didikia bahabab sawozec turimed yariyae zesabaf haveveg sadikih zehamei cezekij cejovek bazebal kiyalum bamepon ripofoo guhazep hameriq nadiyar badices tuluvet natuwou kijoluv joceyaw bazegux dimesay lusanaz kitumea vecegub zekifoc kirized sagucee cetuhaf lufolug samenah nawojoi ripodij gudifok bayamel hagurim kicecen lupotuo sakikip vetunaq nahaver tunatus nawohat cenameu cehadiv cejowow tugubax tuzejoy kibamez merinaa vedirib hawomec dinahad yaturie mejocef pokisag hahameh diworii difojoj yabanak yabatul kicegum porinan riyahao wosayap babapoq zeponar gubapos yagumet hariveu joluvev ceriwow yamegux nalufoy joririz kifobaa velurib poyapoc gubaved rimepoe fodibaf.

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
Before finishing, verify that the output agrees with the relevant fixture files and record the check in `verification`.

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
EXPECTED_OUTPUT = {'result': {'threshold': 93, 'records': [{'id': 'UMB-002', 'zone': 'zone_1', 'total_value': 162}, {'id': 'UMB-007', 'zone': 'zone_1', 'total_value': 96}, {'id': 'UMB-004', 'zone': 'zone_3', 'total_value': 217}, {'id': 'UMB-005', 'zone': 'zone_4', 'total_value': 130}, {'id': 'UMB-001', 'zone': 'zone_5', 'total_value': 405}], 'total_value': 1010, 'malformed_rows_skipped': 0}, 'evidence': ['tables/source_records.csv', 'tables/region_map.json'], 'verification': {'checked_files': 2, 'malformed_rows_skipped': 0, 'status': 'pass'}}

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
