---
id: task_syn_002449
name: Active file manifest 002449
category: file_directory_operations
grading_type: automated
timeout_seconds: 240
workspace_files:
- source: task_syn_002449/workspace/incoming/archive/delta_prairie_1225_00.json
  dest: incoming/archive/delta_prairie_1225_00.json
- source: task_syn_002449/workspace/incoming/active/delta_prairie_1225_01.txt
  dest: incoming/active/delta_prairie_1225_01.txt
- source: task_syn_002449/workspace/incoming/active/delta_prairie_1225_02.json
  dest: incoming/active/delta_prairie_1225_02.json
- source: task_syn_002449/workspace/incoming/active/delta_prairie_1225_03.json
  dest: incoming/active/delta_prairie_1225_03.json
- source: task_syn_002449/workspace/incoming/archive/delta_prairie_1225_04.json
  dest: incoming/archive/delta_prairie_1225_04.json
- source: task_syn_002449/workspace/incoming/active/delta_prairie_1225_05.cfg
  dest: incoming/active/delta_prairie_1225_05.cfg
- source: task_syn_002449/workspace/incoming/active/delta_prairie_1225_06.cfg
  dest: incoming/active/delta_prairie_1225_06.cfg
- source: task_syn_002449/workspace/incoming/active/delta_prairie_1225_07.md
  dest: incoming/active/delta_prairie_1225_07.md
- source: task_syn_002449/workspace/incoming/archive/delta_prairie_1225_08.cfg
  dest: incoming/archive/delta_prairie_1225_08.cfg
capability_family: file_directory_operations
intended_difficulty_band: 4
base_scenario_id: scenario_001225
generator_seed: 820613
multi_session: false
---

## Prompt

You are working on synthetic task `task_syn_002449` for the `access cleanup` scenario `delta-prairie-1225`.
Use only the files supplied in the workspace. Do not fetch live data or use credentials.

Inspect the files under `incoming/active/` for the access cleanup workspace. Ignore everything under `incoming/archive/`. Select active files ending in `.json` whose byte length is at least 52, count active files by extension, and identify the largest active file.

Scenario-specific audit anchors: fozedif digupog namejoh metufoi zecefoj fodihak woguyal cebagum pozerin kiguwoo vewopop vebatuq fohazer kiluves guyacet zeridiu guhawov badibaw ponahax ponaguy kikinaz jolusaa gumerib kihapoc diriyad vezehae yaceluf wojodig risazeh guluzei metufoj nasacek yadicel wopolum wogumen rilujoo tuveyap basadiq foyajor cemeves havetut wolusau zedibav hajoluw rigugux cejoriy vemejoz veforia badijob poguzec ridigud zekizee babakif risabag lucebah zelului nanazej dimebak wotukil menalum wovecen zefodio pocesap sanabaq johaver rimefos cehajot wojofou turijov venazew powoyax tubawoy mejofoz hanaria nayanab cefohac vezetud meridie lugufof ripogug zeyasah jofofoi sakiwoj naveguk luriwol sagugum kidiyan hajobao fofoyap cebazeq josakir vejokis sawomet yarimeu meguyav jorikiw.

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
EXPECTED_OUTPUT = {'result': {'target_extension': 'json', 'minimum_bytes': 52, 'selected_files': ['incoming/active/delta_prairie_1225_02.json', 'incoming/active/delta_prairie_1225_03.json'], 'active_extension_counts': {'cfg': 2, 'json': 2, 'md': 1, 'txt': 1}, 'largest_active_file': {'path': 'incoming/active/delta_prairie_1225_07.md', 'bytes': 174}}, 'evidence': ['incoming/active/delta_prairie_1225_01.txt', 'incoming/active/delta_prairie_1225_02.json', 'incoming/active/delta_prairie_1225_03.json', 'incoming/active/delta_prairie_1225_05.cfg'], 'verification': {'checked_files': 9, 'ignored_archive': True, 'status': 'pass'}}

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
