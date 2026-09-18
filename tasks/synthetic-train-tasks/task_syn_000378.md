---
id: task_syn_000378
name: Constraint schedule build 000378
category: planning_scheduling_constraint_satisfaction
grading_type: automated
timeout_seconds: 210
workspace_files:
- source: task_syn_000378/workspace/plan/constraints.json
  dest: plan/constraints.json
capability_family: planning_scheduling_constraint_satisfaction
intended_difficulty_band: 3
base_scenario_id: scenario_000189
generator_seed: 743986
multi_session: false
---

## Prompt

You are working on synthetic task `task_syn_000378` for the `inventory audit` scenario `harbor-quartz-0189`.
Use only the files supplied in the workspace. Do not fetch live data or use credentials.

Create a deterministic schedule from `plan/constraints.json`. Process tasks in listed order, honor dependencies, start at the given workday hour, skip tasks with impossible dependencies or non-positive duration, and report finish time.

Scenario-specific audit anchors: fopojoo habayap diyazeq mefocer mesaris tukizet rinaguu lutuyav kijonaw menanax jojoriy kiriguz gukihaa zeluceb tutujoc tupowod cezesae ceyawof cetulug yasaguh yalului zenavej gurimek yayatul zebagum tupocen riyapoo yavebap navemeq medinar fohayas disasat pofoceu samecev cepoyaw pokilux dituriy didiyaz vehacea hagubab badiyac wopofod nayabae zecepof menasag focemeh hafogui porituj luverik nafobal rinabam mepojon basayao vevepop wohadiq fofopor fokiris zekirit bameguu tuhayav batucew nadizex mekiwoy hakidiz pozeyaa kituveb hakijoc riwoyad gusazee zezehaf tuvepog sakinah kiluhai ceriguj gutufok zepojol gucemem kidimen nabaluo nacevep kiyakiq wovekir luluves lucepot megupou bafowov vediguw satutux cegukiy kiwonaz haribaa lubameb ponacec lucelud riveyae kinaguf.

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
EXPECTED_OUTPUT = {'result': {'schedule': [{'task': 'A', 'owner': 'ari', 'start': 9, 'end': 11}, {'task': 'B', 'owner': 'bea', 'start': 11, 'end': 14}, {'task': 'C', 'owner': 'cam', 'start': 14, 'end': 18}, {'task': 'D', 'owner': 'ari', 'start': 18, 'end': 19}, {'task': 'E', 'owner': 'bea', 'start': 19, 'end': 21}], 'skipped_tasks': [], 'finish_time': 21}, 'evidence': ['plan/constraints.json'], 'verification': {'checked_files': 1, 'skipped_count': 0, 'status': 'pass'}}

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
