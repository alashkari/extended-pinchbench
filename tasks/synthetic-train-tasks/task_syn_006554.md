---
id: task_syn_006554
name: Active file manifest 006554
category: file_directory_operations
grading_type: automated
timeout_seconds: 240
workspace_files:
- source: task_syn_006554/workspace/incoming/archive/brisk_lumen_3277_00.txt
  dest: incoming/archive/brisk_lumen_3277_00.txt
- source: task_syn_006554/workspace/incoming/active/brisk_lumen_3277_01.cfg
  dest: incoming/active/brisk_lumen_3277_01.cfg
- source: task_syn_006554/workspace/incoming/active/brisk_lumen_3277_02.txt
  dest: incoming/active/brisk_lumen_3277_02.txt
- source: task_syn_006554/workspace/incoming/active/brisk_lumen_3277_03.json
  dest: incoming/active/brisk_lumen_3277_03.json
- source: task_syn_006554/workspace/incoming/archive/brisk_lumen_3277_04.md
  dest: incoming/archive/brisk_lumen_3277_04.md
- source: task_syn_006554/workspace/incoming/active/brisk_lumen_3277_05.txt
  dest: incoming/active/brisk_lumen_3277_05.txt
- source: task_syn_006554/workspace/incoming/active/brisk_lumen_3277_06.txt
  dest: incoming/active/brisk_lumen_3277_06.txt
- source: task_syn_006554/workspace/incoming/active/brisk_lumen_3277_07.txt
  dest: incoming/active/brisk_lumen_3277_07.txt
- source: task_syn_006554/workspace/incoming/archive/brisk_lumen_3277_08.log
  dest: incoming/archive/brisk_lumen_3277_08.log
- source: task_syn_006554/workspace/incoming/active/brisk_lumen_3277_09.json
  dest: incoming/active/brisk_lumen_3277_09.json
- source: task_syn_006554/workspace/incoming/active/brisk_lumen_3277_10.md
  dest: incoming/active/brisk_lumen_3277_10.md
capability_family: file_directory_operations
intended_difficulty_band: 4
base_scenario_id: scenario_003277
generator_seed: 972498
multi_session: false
---

## Prompt

You are working on synthetic task `task_syn_006554` for the `access cleanup` scenario `brisk-lumen-3277`.
Use only the files supplied in the workspace. Do not fetch live data or use credentials.

Inspect the files under `incoming/active/` for the access cleanup workspace. Ignore everything under `incoming/archive/`. Select active files ending in `.json` whose byte length is at least 52, count active files by extension, and identify the largest active file.

Scenario-specific audit anchors: diricec cevejod sayayae haceguf vekiyag kimewoh hanalui kifocej rinanak megukil zekirim mewoven sakinao tumezep sabasaq cegujor cesaves kilusat basaluu sasawov bayaguw samecex guwoyay bariyaz jonahaa zeguwob yazesac rinarid vewokie sajokif yadijog popozeh ripohai kihapoj pokimek sanavel yajowom tuhatun jonayao wofonap tululuq sagukir lujonas bamedit luvekiu nalucev hawovew tuwokix mekifoy nakivez fovepoa dilusab hasayac luyalud difovee wosanaf jonakig kipojoh kirivei cetuhaj kimepok lunasal riyakim jopowon kifopoo menarip wopozeq sayacer cemeves batukit ribapou savehav tuwodiw cejoyax mekiguy guzejoz kifosaa tuvefob riripoc wohamed kiyanae meyamef hacesag medituh mepodii kibayaj yaworik jozemel gujogum ricefon venameo yacedip kiguriq gupogur pozeyas gunagut.

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
If a malformed row, impossible dependency, or unusable entry appears, skip it and report the skip count instead of failing.

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
EXPECTED_OUTPUT = {'result': {'target_extension': 'json', 'minimum_bytes': 52, 'selected_files': ['incoming/active/brisk_lumen_3277_03.json', 'incoming/active/brisk_lumen_3277_09.json'], 'active_extension_counts': {'cfg': 1, 'json': 2, 'md': 1, 'txt': 4}, 'largest_active_file': {'path': 'incoming/active/brisk_lumen_3277_10.md', 'bytes': 196}}, 'evidence': ['incoming/active/brisk_lumen_3277_01.cfg', 'incoming/active/brisk_lumen_3277_02.txt', 'incoming/active/brisk_lumen_3277_03.json', 'incoming/active/brisk_lumen_3277_05.txt'], 'verification': {'checked_files': 11, 'ignored_archive': True, 'status': 'pass'}}

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
