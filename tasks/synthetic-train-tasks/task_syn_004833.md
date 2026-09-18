---
id: task_syn_004833
name: Generate record transformer 004833
category: code_generation
grading_type: hybrid
timeout_seconds: 210
workspace_files:
- source: task_syn_004833/workspace/spec/visible_cases.json
  dest: spec/visible_cases.json
capability_family: code_generation
intended_difficulty_band: 3
base_scenario_id: scenario_002417
generator_seed: 908821
multi_session: false
grading_weights:
  automated: 0.7
  llm_judge: 0.3
---

## Prompt

You are working on synthetic task `task_syn_004833` for the `sensor calibration` scenario `zenith-mosaic-2417`.
Use only the supplied workspace files. Do not fetch live data or use credentials.

Implement `transform_records(records)`. Keep records whose status is `active` and score is at least 58. Return dictionaries with uppercase `code` and `bucket`, where bucket is `priority` when the score is at least 78, otherwise `watch`. Sort by code. Write the implementation to `submission/solution.py`.

Scenario-specific code anchors: diyavex poridiy vedisaz dirimea tubapob bametuc kimesad zesayae foyadif savewog bakibah sazegui sakibaj nayarik havetul fozedim metupon didirio kihacep tugusaq rinazer sabalus fogutut jopowou nabariv gusatuw tupofox banaluy tusavez yarigua tuhayab disavec wokized vebajoe diridif jovebag foribah vebanai natuguj bayanak zeyamel dikibam mesanan sahabao pokilup bazenaq zesamer dididis fonamet nayafou haveyav johajow kibajox yameguy pocekiz kipolua zeturib joyacec risapod ripowoe hanabaf saposag guceceh fodimei hahafoj tuceluk lusavel diguvem dicefon haveceo poridip cejoluq pokinar kibadis povehat basazeu mesanav woricew popojox guyapoy mejobaz tuzefoa lubajob yajohac riyafod foposae kiyahaf cefowog popozeh josanai hatudij poguzek fodihal cebanam tupodin fogufoo.

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
OUTPUT_FILE = 'solution.py'
VISIBLE_CASES = [{'input': [{'code': 'aa', 'status': 'active', 'score': 58}, {'code': 'bb', 'status': 'paused', 'score': 83}], 'expected': [{'code': 'AA', 'bucket': 'watch'}]}, {'input': [{'code': 'cc', 'status': 'active', 'score': 88}, {'code': 'dd', 'status': 'active', 'score': 57}], 'expected': [{'code': 'CC', 'bucket': 'priority'}]}]
HIDDEN_CASES = [{'input': [{'code': 'mx', 'status': 'active', 'score': 59}, {'code': 'az', 'status': 'active', 'score': 98}], 'expected': [{'code': 'AZ', 'bucket': 'priority'}, {'code': 'MX', 'bucket': 'watch'}]}, {'input': [{'code': 'nk', 'status': 'unknown', 'score': 148}, {'code': 'lm', 'status': 'active', 'score': 77}], 'expected': [{'code': 'LM', 'bucket': 'watch'}]}]
REFERENCE_CODE = 'def transform_records(records):\n    output = []\n    for record in records:\n        try:\n            score = int(record.get("score", 0))\n        except Exception:\n            continue\n        if record.get("status") == "active" and score >= 58:\n            bucket = "priority" if score >= 78 else "watch"\n            output.append({"code": str(record.get("code", "")).upper(), "bucket": bucket})\n    return sorted(output, key=lambda item: item["code"])\n'
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

Judge the submitted artifact using the criteria below. Award credit only for content grounded in the supplied workspace files.

- 1.0: Complete, accurate, well organized, and explicit about evidence and verification.
- 0.7: Mostly correct with a minor omission or weak explanation that does not change the core result.
- 0.4: Partially grounded but misses an important constraint, source, or edge case.
- 0.0: Ungrounded, unusable, unsafe, or dependent on unavailable external data.

Capability focus: `code_generation`.

## Additional Notes

All names, records, source pages, logs, and code fixtures in this task are synthetic. Do not infer a final model route or model tier from this metadata.
