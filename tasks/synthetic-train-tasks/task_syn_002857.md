---
id: task_syn_002857
name: Active file manifest 002857
category: file_directory_operations
grading_type: automated
timeout_seconds: 180
workspace_files:
- source: task_syn_002857/workspace/incoming/archive/zenith_brisk_1429_00.md
  dest: incoming/archive/zenith_brisk_1429_00.md
- source: task_syn_002857/workspace/incoming/active/zenith_brisk_1429_01.json
  dest: incoming/active/zenith_brisk_1429_01.json
- source: task_syn_002857/workspace/incoming/active/zenith_brisk_1429_02.cfg
  dest: incoming/active/zenith_brisk_1429_02.cfg
- source: task_syn_002857/workspace/incoming/active/zenith_brisk_1429_03.md
  dest: incoming/active/zenith_brisk_1429_03.md
- source: task_syn_002857/workspace/incoming/archive/zenith_brisk_1429_04.cfg
  dest: incoming/archive/zenith_brisk_1429_04.cfg
- source: task_syn_002857/workspace/incoming/active/zenith_brisk_1429_05.txt
  dest: incoming/active/zenith_brisk_1429_05.txt
- source: task_syn_002857/workspace/incoming/active/zenith_brisk_1429_06.md
  dest: incoming/active/zenith_brisk_1429_06.md
- source: task_syn_002857/workspace/incoming/active/zenith_brisk_1429_07.json
  dest: incoming/active/zenith_brisk_1429_07.json
- source: task_syn_002857/workspace/incoming/archive/zenith_brisk_1429_08.md
  dest: incoming/archive/zenith_brisk_1429_08.md
capability_family: file_directory_operations
intended_difficulty_band: 2
base_scenario_id: scenario_001429
generator_seed: 835709
multi_session: false
---

## Prompt

You are working on synthetic task `task_syn_002857` for the `billing review` scenario `zenith-brisk-1429`.
Use only the files supplied in the workspace. Do not fetch live data or use credentials.

Inspect the files under `incoming/active/` for the billing review workspace. Ignore everything under `incoming/archive/`. Select active files ending in `.cfg` whose byte length is at least 38, count active files by extension, and identify the largest active file.

Scenario-specific audit anchors: tutulux risatuy ceyayaz bamefoa jokinab sadiguc wopogud kihanae veriyaf gunatug jobahah tucevei zeyazej gukiyak bagugul luyarim vehawon gubadio fozenap verihaq dijopor yasakis folulut cejoveu celuzev kilujow jojoyax fozejoy podikiz nayalua hamewob haguhac guwoved rikiyae wowojof bakiyag rizeguh yarihai tuguvej dibavek jojopol jocebam lulufon tuveluo kidijop pohafoq luzeyar hasasas nabadit jocediu vecehav zerijow naguyax tupoyay wodiyaz cevehaa dibalub tuyajoc mediced rivenae cecefof sadinag vejoluh lurisai rihadij pomejok vemejol guluyam dinahan cevetuo celuhap jomeriq joyamer satugus rigukit nasadiu riforiv hazezew wometux tudifoy ditumez dikidia jozekib jowonac joceyad woyabae yakinaf mebafog lubahah rizekii babawoj kiwokik sadifol hakiwom nasaven yasapoo.

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
EXPECTED_OUTPUT = {'result': {'target_extension': 'cfg', 'minimum_bytes': 38, 'selected_files': ['incoming/active/zenith_brisk_1429_02.cfg'], 'active_extension_counts': {'cfg': 1, 'json': 2, 'md': 2, 'txt': 1}, 'largest_active_file': {'path': 'incoming/active/zenith_brisk_1429_07.json', 'bytes': 159}}, 'evidence': ['incoming/active/zenith_brisk_1429_01.json', 'incoming/active/zenith_brisk_1429_02.cfg', 'incoming/active/zenith_brisk_1429_03.md', 'incoming/active/zenith_brisk_1429_05.txt'], 'verification': {'checked_files': 9, 'ignored_archive': True, 'status': 'pass'}}

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
