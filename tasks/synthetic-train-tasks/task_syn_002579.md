---
id: task_syn_002579
name: Repair record transformer 002579
category: code_debugging
grading_type: automated
timeout_seconds: 240
workspace_files:
- source: task_syn_002579/workspace/src/buggy_module.py
  dest: src/buggy_module.py
- source: task_syn_002579/workspace/tests/visible_cases.json
  dest: tests/visible_cases.json
capability_family: code_debugging
intended_difficulty_band: 4
base_scenario_id: scenario_001290
generator_seed: 825423
multi_session: false
---

## Prompt

You are working on synthetic task `task_syn_002579` for the `policy review` scenario `quartz-nimbus-1290`.
Use only the supplied workspace files. Do not fetch live data or use credentials.

`src/buggy_module.py` is intended to satisfy this behavior: Implement `transform_records(records)`. Keep records whose status is `active` and score is at least 64. Return dictionaries with uppercase `code` and `bucket`, where bucket is `priority` when the score is at least 84, otherwise `watch`. Sort by code. Write the corrected implementation to `submission/fixed_module.py` with the same public function.

Scenario-specific code anchors: guvehaf mehawog jowoguh tufohai najovej mepowok poditul saritum veguzen kijoluo cecemep kikimeq wozezer worices lukigut batukiu wokinav guhawow meguhax tunariy cedibaz dibagua diyadib guwozec bawosad zemenae lufoyaf foharig cesatuh yawolui mewonaj lufodik havelul riguwom baluven cerisao gubagup memeriq lubakir josayas wogunat nacemeu dikituv mecebaw napohax fotudiy riponaz veluvea wotuzeb pobaguc riveved rizeyae bahacef foluveg woluwoh wohatui kizesaj dizecek zesahal fogubam wogunan kijorio namemep powohaq sariwor joguyas wopozet diguceu disayav veluguw tubanax nakikiy batutuz yahadia jokirib luceyac wojolud sasague yayatuf povemeg meguguh tudijoi wotuhaj vedirik guwoyal dihazem woguzen foyaveo kizeyap nafoyaq kiforir hafonas fojopot posanau womefov luluzew.

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
OUTPUT_FILE = 'fixed_module.py'
VISIBLE_CASES = [{'input': [{'code': 'aa', 'status': 'active', 'score': 64}, {'code': 'bb', 'status': 'paused', 'score': 89}], 'expected': [{'code': 'AA', 'bucket': 'watch'}]}, {'input': [{'code': 'cc', 'status': 'active', 'score': 94}, {'code': 'dd', 'status': 'active', 'score': 63}], 'expected': [{'code': 'CC', 'bucket': 'priority'}]}]
HIDDEN_CASES = [{'input': [{'code': 'mx', 'status': 'active', 'score': 65}, {'code': 'az', 'status': 'active', 'score': 104}], 'expected': [{'code': 'AZ', 'bucket': 'priority'}, {'code': 'MX', 'bucket': 'watch'}]}, {'input': [{'code': 'nk', 'status': 'unknown', 'score': 154}, {'code': 'lm', 'status': 'active', 'score': 83}], 'expected': [{'code': 'LM', 'bucket': 'watch'}]}]
REFERENCE_CODE = 'def transform_records(records):\n    output = []\n    for record in records:\n        try:\n            score = int(record.get("score", 0))\n        except Exception:\n            continue\n        if record.get("status") == "active" and score >= 64:\n            bucket = "priority" if score >= 84 else "watch"\n            output.append({"code": str(record.get("code", "")).upper(), "bucket": bucket})\n    return sorted(output, key=lambda item: item["code"])\n'
INCORRECT_CODE = 'def transform_records(records):\n    output = []\n    for record in records:\n        try:\n            score = int(record.get("score", 0))\n        except Exception:\n            continue\n        if record.get("status") == "active" and score > 64:\n            bucket = "urgent" if score > 84 else "watch"\n            output.append({"code": str(record.get("code", "")).upper(), "bucket": bucket})\n    return sorted(output, key=lambda item: item["code"])\n'

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
