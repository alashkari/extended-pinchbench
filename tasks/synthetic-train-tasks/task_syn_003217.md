---
id: task_syn_003217
name: Active file manifest 003217
category: file_directory_operations
grading_type: automated
timeout_seconds: 180
workspace_files:
- source: task_syn_003217/workspace/incoming/archive/xenial_umbra_1609_00.cfg
  dest: incoming/archive/xenial_umbra_1609_00.cfg
- source: task_syn_003217/workspace/incoming/active/xenial_umbra_1609_01.md
  dest: incoming/active/xenial_umbra_1609_01.md
- source: task_syn_003217/workspace/incoming/active/xenial_umbra_1609_02.log
  dest: incoming/active/xenial_umbra_1609_02.log
- source: task_syn_003217/workspace/incoming/active/xenial_umbra_1609_03.log
  dest: incoming/active/xenial_umbra_1609_03.log
- source: task_syn_003217/workspace/incoming/archive/xenial_umbra_1609_04.json
  dest: incoming/archive/xenial_umbra_1609_04.json
- source: task_syn_003217/workspace/incoming/active/xenial_umbra_1609_05.json
  dest: incoming/active/xenial_umbra_1609_05.json
- source: task_syn_003217/workspace/incoming/active/xenial_umbra_1609_06.md
  dest: incoming/active/xenial_umbra_1609_06.md
- source: task_syn_003217/workspace/incoming/active/xenial_umbra_1609_07.log
  dest: incoming/active/xenial_umbra_1609_07.log
- source: task_syn_003217/workspace/incoming/archive/xenial_umbra_1609_08.txt
  dest: incoming/archive/xenial_umbra_1609_08.txt
capability_family: file_directory_operations
intended_difficulty_band: 2
base_scenario_id: scenario_001609
generator_seed: 849029
multi_session: false
---

## Prompt

You are working on synthetic task `task_syn_003217` for the `billing review` scenario `xenial-umbra-1609`.
Use only the files supplied in the workspace. Do not fetch live data or use credentials.

Inspect the files under `incoming/active/` for the billing review workspace. Ignore everything under `incoming/archive/`. Select active files ending in `.cfg` whose byte length is at least 38, count active files by extension, and identify the largest active file.

Scenario-specific audit anchors: wowolut vejosau kicezev nasajow mebabax wosatuy mediwoz harigua nanayab foyawoc rijohad yakisae nalusaf yajozeg namewoh cedicei cenadij menadik rihajol badiwom kiharin polubao disalup zehanaq yarisar dicemes johazet zekidiu pozezev yasavew zeporix mefoyay venamez fodinaa napohab menaric nadibad tuvedie powovef dirilug sabaveh melusai dicecej fohahak guzekil mecepom cetuzen zebapoo vedijop wofoluq mezewor riyayas halunat yazeceu bacenav bafojow havejox vesanay bafofoz veriyaa josaceb riwosac metufod tulukie tupowof najotug napopoh zesafoi diwomej sanaluk gupohal rigujom mekilun ceceyao jobapop veworiq fomenar cesakis wozemet poveceu banavev rididiw kibakix kidimey veguyaz lunanaa vebabab zeguhac yatujod fowonae veyaluf jodikig tujonah hazebai fosapoj diworik.

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
EXPECTED_OUTPUT = {'result': {'target_extension': 'cfg', 'minimum_bytes': 38, 'selected_files': [], 'active_extension_counts': {'json': 1, 'log': 3, 'md': 2}, 'largest_active_file': {'path': 'incoming/active/xenial_umbra_1609_07.log', 'bytes': 159}}, 'evidence': ['incoming/active/xenial_umbra_1609_01.md', 'incoming/active/xenial_umbra_1609_02.log', 'incoming/active/xenial_umbra_1609_03.log', 'incoming/active/xenial_umbra_1609_05.json'], 'verification': {'checked_files': 9, 'ignored_archive': True, 'status': 'pass'}}

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
