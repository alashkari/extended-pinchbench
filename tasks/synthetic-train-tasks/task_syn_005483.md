---
id: task_syn_005483
name: Repair record transformer 005483
category: code_debugging
grading_type: hybrid
timeout_seconds: 210
workspace_files:
- source: task_syn_005483/workspace/src/buggy_module.py
  dest: src/buggy_module.py
- source: task_syn_005483/workspace/tests/visible_cases.json
  dest: tests/visible_cases.json
capability_family: code_debugging
intended_difficulty_band: 3
base_scenario_id: scenario_002742
generator_seed: 932871
multi_session: false
grading_weights:
  automated: 0.7
  llm_judge: 0.3
---

## Prompt

You are working on synthetic task `task_syn_005483` for the `vendor intake` scenario `mosaic-onyx-2742`.
Use only the supplied workspace files. Do not fetch live data or use credentials.

`src/buggy_module.py` is intended to satisfy this behavior: Implement `transform_records(records)`. Keep records whose status is `active` and score is at least 58. Return dictionaries with uppercase `code` and `bucket`, where bucket is `priority` when the score is at least 78, otherwise `watch`. Sort by code. Write the corrected implementation to `submission/fixed_module.py` with the same public function.

Scenario-specific code anchors: dijodix zekiriy luhavez fomewoa kigupob celubac cenatud kibafoe riluluf hazeceg ridiwoh hafohai woluhaj kipokik polujol bapokim kiyamen cehayao ponagup podibaq sawogur zehatus pobagut gujoceu tudiriv hacenaw bapofox tufovey zemepoz kijotua bariwob lurinac zesabad tuditue luludif badirig pocewoh povedii hakimej dikirik jofolul hazepom vecesan megusao hakiwop vejobaq hadicer ribanas yacezet foworiu sahasav yavebaw kimeyax lurifoy mevepoz satuzea fofokib rikiyac veyanad meditue kihaguf mebadig diwonah zemetui dilurij zerijok luvejol sariyam fomedin tucefoo nacevep tuworiq wobamer gudijos cekidit rinaveu tumecev nananaw nakinax yayaluy sabafoz gunanaa hakijob jopoluc mecezed rituvee foturif kiyaceg hakiguh veforii wozeguj bazezek safotul hameyam wokilun rituluo.

The submitted Python file must use only the standard library and expose the requested public function.
Keep the implementation deterministic and handle malformed records by skipping them when the behavior description implies a numeric conversion.

## Expected Behavior

A correct solution writes the requested Python module under `submission/`, exposes the requested function, passes the visible cases, and generalizes to structurally similar hidden cases.

## Grading Criteria

- [ ] syntax_valid: The submitted Python module imports without syntax or execution-time definition errors.
- [ ] public_api: The requested public function exists and is callable.
- [ ] visible_cases: The implementation passes visible behavior cases supplied in the workspace.
- [ ] hidden_cases: The implementation generalizes to held-back deterministic grader cases.
- [ ] Judge review: Assess clarity, traceability, and whether the response avoids unsupported assumptions.

## Automated Checks

```python
from pathlib import Path
import importlib.util

CRITERIA = ['syntax_valid', 'public_api', 'visible_cases', 'hidden_cases']
FUNCTION_NAME = 'transform_records'
OUTPUT_FILE = 'fixed_module.py'
VISIBLE_CASES = [{'input': [{'code': 'aa', 'status': 'active', 'score': 58}, {'code': 'bb', 'status': 'paused', 'score': 83}], 'expected': [{'code': 'AA', 'bucket': 'watch'}]}, {'input': [{'code': 'cc', 'status': 'active', 'score': 88}, {'code': 'dd', 'status': 'active', 'score': 57}], 'expected': [{'code': 'CC', 'bucket': 'priority'}]}]
HIDDEN_CASES = [{'input': [{'code': 'mx', 'status': 'active', 'score': 59}, {'code': 'az', 'status': 'active', 'score': 98}], 'expected': [{'code': 'AZ', 'bucket': 'priority'}, {'code': 'MX', 'bucket': 'watch'}]}, {'input': [{'code': 'nk', 'status': 'unknown', 'score': 148}, {'code': 'lm', 'status': 'active', 'score': 77}], 'expected': [{'code': 'LM', 'bucket': 'watch'}]}]
REFERENCE_CODE = 'def transform_records(records):\n    output = []\n    for record in records:\n        try:\n            score = int(record.get("score", 0))\n        except Exception:\n            continue\n        if record.get("status") == "active" and score >= 58:\n            bucket = "priority" if score >= 78 else "watch"\n            output.append({"code": str(record.get("code", "")).upper(), "bucket": bucket})\n    return sorted(output, key=lambda item: item["code"])\n'
INCORRECT_CODE = 'def transform_records(records):\n    output = []\n    for record in records:\n        try:\n            score = int(record.get("score", 0))\n        except Exception:\n            continue\n        if record.get("status") == "active" and score > 58:\n            bucket = "urgent" if score > 78 else "watch"\n            output.append({"code": str(record.get("code", "")).upper(), "bucket": bucket})\n    return sorted(output, key=lambda item: item["code"])\n'

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

Judge the submitted artifact using the criteria below. Award credit only for content grounded in the supplied workspace files.

- 1.0: Complete, accurate, well organized, and explicit about evidence and verification.
- 0.7: Mostly correct with a minor omission or weak explanation that does not change the core result.
- 0.4: Partially grounded but misses an important constraint, source, or edge case.
- 0.0: Ungrounded, unusable, unsafe, or dependent on unavailable external data.

Capability focus: `code_debugging`.

## Additional Notes

All names, records, source pages, logs, and code fixtures in this task are synthetic. Do not infer a final model route or model tier from this metadata.
