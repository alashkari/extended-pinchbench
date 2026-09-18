---
id: task_syn_000601
name: Active file manifest 000601
category: file_directory_operations
grading_type: automated
timeout_seconds: 150
workspace_files:
- source: task_syn_000601/workspace/incoming/archive/prairie_yonder_0301_00.log
  dest: incoming/archive/prairie_yonder_0301_00.log
- source: task_syn_000601/workspace/incoming/active/prairie_yonder_0301_01.txt
  dest: incoming/active/prairie_yonder_0301_01.txt
- source: task_syn_000601/workspace/incoming/active/prairie_yonder_0301_02.cfg
  dest: incoming/active/prairie_yonder_0301_02.cfg
- source: task_syn_000601/workspace/incoming/active/prairie_yonder_0301_03.log
  dest: incoming/active/prairie_yonder_0301_03.log
- source: task_syn_000601/workspace/incoming/archive/prairie_yonder_0301_04.md
  dest: incoming/archive/prairie_yonder_0301_04.md
- source: task_syn_000601/workspace/incoming/active/prairie_yonder_0301_05.md
  dest: incoming/active/prairie_yonder_0301_05.md
capability_family: file_directory_operations
intended_difficulty_band: 1
base_scenario_id: scenario_000301
generator_seed: 752237
multi_session: false
---

## Prompt

You are working on synthetic task `task_syn_000601` for the `release readiness` scenario `prairie-yonder-0301`.
Use only the files supplied in the workspace. Do not fetch live data or use credentials.

Inspect the files under `incoming/active/` for the release readiness workspace. Ignore everything under `incoming/archive/`. Select active files ending in `.log` whose byte length is at least 31, count active files by extension, and identify the largest active file.

Scenario-specific audit anchors: balubad gucezee harikif woforig pohayah haforii mewoluj turituk kisabal bajodim zeluwon mehakio potubap zejoceq sahawor bajoyas lukibat meveceu vemezev hayadiw focecex kilusay yaluluz dipokia rijofob kifonac diverid fodikie kibajof nagupog fozepoh jofonai zediguj lupobak bazecel naludim povecen rizejoo wotugup lumejoq fotudir pokijos luyadit rizefou tumevev fowobaw kiguyax womekiy risakiz hatujoa podimeb kiharic zejorid tupomee tuyasaf yahalug guhaguh jonavei tuwopoj difosak zebalul kiceham jofonan rivezeo tuvedip samejoq ditunar nametus fobahat mecepou vebanav jokidiw cejowox fonawoy tuvehaz wonabaa salupob mebafoc sarijod haridie kitufof mevelug digusah zeyalui wotuyaj natuwok hanatul mesasam jomezen gukiceo cewobap kimehaq wogupor cekigus baguhat dihayau.

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
EXPECTED_OUTPUT = {'result': {'target_extension': 'log', 'minimum_bytes': 31, 'selected_files': ['incoming/active/prairie_yonder_0301_03.log'], 'active_extension_counts': {'cfg': 1, 'log': 1, 'md': 1, 'txt': 1}, 'largest_active_file': {'path': 'incoming/active/prairie_yonder_0301_05.md', 'bytes': 143}}, 'evidence': ['incoming/active/prairie_yonder_0301_01.txt', 'incoming/active/prairie_yonder_0301_02.cfg', 'incoming/active/prairie_yonder_0301_03.log', 'incoming/active/prairie_yonder_0301_05.md'], 'verification': {'checked_files': 6, 'ignored_archive': True, 'status': 'pass'}}

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
