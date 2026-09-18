---
id: task_syn_007522
name: Generate record transformer 007522
category: code_generation
grading_type: automated
timeout_seconds: 180
workspace_files:
- source: task_syn_007522/workspace/spec/visible_cases.json
  dest: spec/visible_cases.json
capability_family: code_generation
intended_difficulty_band: 2
base_scenario_id: scenario_003761
generator_seed: 1008314
multi_session: false
---

## Prompt

You are working on synthetic task `task_syn_007522` for the `training roster` scenario `ripple-ripple-3761`.
Use only the supplied workspace files. Do not fetch live data or use credentials.

Implement `transform_records(records)`. Keep records whose status is `active` and score is at least 52. Return dictionaries with uppercase `code` and `bucket`, where bucket is `priority` when the score is at least 72, otherwise `watch`. Sort by code. Write the implementation to `submission/solution.py`.

Scenario-specific code anchors: cejokii mecefoj zefoyak fojoyal foguyam hajoven fojosao popofop wokibaq hadifor kivemes zewobat sazenau cedijov vesariw megujox wojoyay ridinaz popogua tuwolub gufomec zedikid bafodie gugudif naveyag luhawoh salugui vejocej foyafok zefoyal navemem dibapon gufoveo tugubap digupoq riwonar rihagus digupot pofomeu povetuv hamewow zecemex zeyahay zevepoz poyahaa rigukib jorizec diluved cemedie guhafof rilufog fokinah lusasai joyayaj medijok zekibal ricepom ripodin gunameo hafohap polufoq tululur hakitus jobayat posakiu mesaluv pohasaw kimedix meriyay sadiwoz joripoa rivetub mediwoc ludived rivevee gucekif velurig lubaveh hadifoi rigutuj yacewok hamecel hapomem lututun josapoo luwokip kisaguq hapover velubas ponalut kiwopou bajosav wojovew kivemex jogunay batumez.

The submitted Python file must use only the standard library and expose the requested public function.
Keep the implementation deterministic and handle malformed records by skipping them when the behavior description implies a numeric conversion.

## Expected Behavior

A correct solution writes the requested Python module under `submission/`, exposes the requested function, passes the visible cases, and generalizes to structurally similar hidden cases.

## Grading Criteria

- [ ] syntax_valid: The submitted Python module imports without syntax or execution-time definition errors.
- [ ] public_api: The requested public function exists and is callable.
- [ ] visible_cases: The implementation passes visible behavior cases supplied in the workspace.
- [ ] hidden_cases: The implementation generalizes to held-back deterministic grader cases.

## Automated Checks

```python
from pathlib import Path
import importlib.util

CRITERIA = ['syntax_valid', 'public_api', 'visible_cases', 'hidden_cases']
FUNCTION_NAME = 'transform_records'
OUTPUT_FILE = 'solution.py'
VISIBLE_CASES = [{'input': [{'code': 'aa', 'status': 'active', 'score': 52}, {'code': 'bb', 'status': 'paused', 'score': 77}], 'expected': [{'code': 'AA', 'bucket': 'watch'}]}, {'input': [{'code': 'cc', 'status': 'active', 'score': 82}, {'code': 'dd', 'status': 'active', 'score': 51}], 'expected': [{'code': 'CC', 'bucket': 'priority'}]}]
HIDDEN_CASES = [{'input': [{'code': 'mx', 'status': 'active', 'score': 53}, {'code': 'az', 'status': 'active', 'score': 92}], 'expected': [{'code': 'AZ', 'bucket': 'priority'}, {'code': 'MX', 'bucket': 'watch'}]}, {'input': [{'code': 'nk', 'status': 'unknown', 'score': 142}, {'code': 'lm', 'status': 'active', 'score': 71}], 'expected': [{'code': 'LM', 'bucket': 'watch'}]}]
REFERENCE_CODE = 'def transform_records(records):\n    output = []\n    for record in records:\n        try:\n            score = int(record.get("score", 0))\n        except Exception:\n            continue\n        if record.get("status") == "active" and score >= 52:\n            bucket = "priority" if score >= 72 else "watch"\n            output.append({"code": str(record.get("code", "")).upper(), "bucket": bucket})\n    return sorted(output, key=lambda item: item["code"])\n'
INCORRECT_CODE = 'def transform_records(records):\n    return []\n'

def _load_module(path):
    try:
        spec = importlib.util.spec_from_file_location("candidate_solution", path)
        if spec is None or spec.loader is None:
            return None
        module = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(module)
        return module
    except Exception:
        return None

def _run_cases(func, cases):
    if not cases:
        return 1.0
    passed = 0
    for case in cases:
        try:
            actual = func(case["input"])
        except Exception:
            actual = None
        if actual == case["expected"]:
            passed += 1
    return passed / len(cases)

def grade(transcript, workspace_dir):
    scores = {key: 0.0 for key in CRITERIA}
    module_path = Path(workspace_dir) / "submission" / OUTPUT_FILE
    if not module_path.exists():
        return scores
    module = _load_module(module_path)
    if module is None:
        return scores
    scores["syntax_valid"] = 1.0
    func = getattr(module, FUNCTION_NAME, None)
    if not callable(func):
        return scores
    scores["public_api"] = 1.0
    scores["visible_cases"] = _run_cases(func, VISIBLE_CASES)
    scores["hidden_cases"] = _run_cases(func, HIDDEN_CASES)
    return scores

def create_reference_solution(workspace_dir):
    output = Path(workspace_dir) / "submission" / OUTPUT_FILE
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(REFERENCE_CODE, encoding="utf-8")

def create_incorrect_solution(workspace_dir):
    output = Path(workspace_dir) / "submission" / OUTPUT_FILE
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(INCORRECT_CODE, encoding="utf-8")
```

## LLM Judge Rubric

Not applicable; objective automated checks define the task score.

## Additional Notes

All names, records, source pages, logs, and code fixtures in this task are synthetic. Do not infer a final model route or model tier from this metadata.
