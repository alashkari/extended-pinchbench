---
id: task_syn_006977
name: Constraint schedule build 006977
category: planning_scheduling_constraint_satisfaction
grading_type: hybrid
timeout_seconds: 180
workspace_files:
- source: task_syn_006977/workspace/plan/constraints.json
  dest: plan/constraints.json
capability_family: planning_scheduling_constraint_satisfaction
intended_difficulty_band: 2
base_scenario_id: scenario_003489
generator_seed: 988149
multi_session: false
grading_weights:
  automated: 0.7
  llm_judge: 0.3
---

## Prompt

You are working on synthetic task `task_syn_006977` for the `queue triage` scenario `frost-harbor-3489`.
Use only the files supplied in the workspace. Do not fetch live data or use credentials.

Create a deterministic schedule from `plan/constraints.json`. Process tasks in listed order, honor dependencies, start at the given workday hour, skip tasks with impossible dependencies or non-positive duration, and report finish time.

Scenario-specific audit anchors: sakizej pomeluk ripocel vewobam natudin rimezeo mezedip menameq tucejor cerizes fobajot tudiceu lumeriv ripojow hajolux polufoy guhatuz fodisaa luveyab gurifoc riyalud tujokie ceposaf risafog jomehah yalurii mevejoj cemenak gunaril pofotum lukiban tuzebao rinakip digutuq tufosar metubas ceyanat dibayau dinasav yacecew sapolux guvemey zewovez tugugua zepoveb sakihac dibanad halucee fofosaf jolugug digujoh tukizei venasaj zefotuk wodinal kiripom cedipon cesakio batuhap guguwoq dikiver kidifos zewokit wokihau fodiluv navezew zefojox diwobay samecez zegufoa joyajob bavenac tudisad dijofoe diwotuf saworig zehapoh safokii ribayaj jonacek rikihal diyabam sayaban foyakio sacehap bahadiq fohanar nazeyas veribat gufopou gupowov saridiw yakigux luguhay ribazez banaria.

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
- [ ] Judge review: Assess clarity, traceability, and whether the response avoids unsupported assumptions.

## Automated Checks

```python
from pathlib import Path
import json

CRITERIA = ['format_valid', 'answer_correct', 'evidence_grounded', 'verification_complete']
EXPECTED_OUTPUT = {'result': {'schedule': [{'task': 'A', 'owner': 'ari', 'start': 9, 'end': 11}, {'task': 'B', 'owner': 'bea', 'start': 11, 'end': 14}, {'task': 'C', 'owner': 'cam', 'start': 14, 'end': 18}, {'task': 'D', 'owner': 'ari', 'start': 18, 'end': 19}, {'task': 'E', 'owner': 'bea', 'start': 19, 'end': 21}, {'task': 'F', 'owner': 'cam', 'start': 21, 'end': 24}, {'task': 'G', 'owner': 'ari', 'start': 24, 'end': 28}], 'skipped_tasks': [], 'finish_time': 28}, 'evidence': ['plan/constraints.json'], 'verification': {'checked_files': 1, 'skipped_count': 0, 'status': 'pass'}}

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

Judge the submitted artifact using the criteria below. Award credit only for content grounded in the supplied workspace files.

- 1.0: Complete, accurate, well organized, and explicit about evidence and verification.
- 0.7: Mostly correct with a minor omission or weak explanation that does not change the core result.
- 0.4: Partially grounded but misses an important constraint, source, or edge case.
- 0.0: Ungrounded, unusable, unsafe, or dependent on unavailable external data.

Capability focus: `planning_scheduling_constraint_satisfaction`.

## Additional Notes

All names, records, source pages, logs, and code fixtures in this task are synthetic. Do not infer a final model route or model tier from this metadata.
