---
id: task_syn_001969
name: Active file manifest 001969
category: file_directory_operations
grading_type: automated
timeout_seconds: 240
workspace_files:
- source: task_syn_001969/workspace/incoming/archive/xenial_brisk_0985_00.log
  dest: incoming/archive/xenial_brisk_0985_00.log
- source: task_syn_001969/workspace/incoming/active/xenial_brisk_0985_01.cfg
  dest: incoming/active/xenial_brisk_0985_01.cfg
- source: task_syn_001969/workspace/incoming/active/xenial_brisk_0985_02.cfg
  dest: incoming/active/xenial_brisk_0985_02.cfg
- source: task_syn_001969/workspace/incoming/active/xenial_brisk_0985_03.json
  dest: incoming/active/xenial_brisk_0985_03.json
- source: task_syn_001969/workspace/incoming/archive/xenial_brisk_0985_04.txt
  dest: incoming/archive/xenial_brisk_0985_04.txt
- source: task_syn_001969/workspace/incoming/active/xenial_brisk_0985_05.cfg
  dest: incoming/active/xenial_brisk_0985_05.cfg
- source: task_syn_001969/workspace/incoming/active/xenial_brisk_0985_06.cfg
  dest: incoming/active/xenial_brisk_0985_06.cfg
- source: task_syn_001969/workspace/incoming/active/xenial_brisk_0985_07.cfg
  dest: incoming/active/xenial_brisk_0985_07.cfg
- source: task_syn_001969/workspace/incoming/archive/xenial_brisk_0985_08.json
  dest: incoming/archive/xenial_brisk_0985_08.json
capability_family: file_directory_operations
intended_difficulty_band: 4
base_scenario_id: scenario_000985
generator_seed: 802853
multi_session: false
---

## Prompt

You are working on synthetic task `task_syn_001969` for the `access cleanup` scenario `xenial-brisk-0985`.
Use only the files supplied in the workspace. Do not fetch live data or use credentials.

Inspect the files under `incoming/active/` for the access cleanup workspace. Ignore everything under `incoming/archive/`. Select active files ending in `.json` whose byte length is at least 52, count active files by extension, and identify the largest active file.

Scenario-specific audit anchors: halugut zeyameu memezev hafobaw dirizex nawodiy nacekiz jobapoa guvemeb podifoc hatudid gukibae zegubaf kitufog posameh riwojoi nafozej divebak hafodil cewozem kigulun cekidio banalup lucewoq hakimer kisanas wokinat posaveu gudizev najokiw vejotux haveguy pogucez kivedia wovemeb rifonac gumewod dimezee hamemef fogudig fofoveh dinawoi powocej jofoguk yadilul popobam menacen salurio kiwowop pofowoq yabacer fotunas vetuhat folutuu bacekiv fosahaw cekivex potucey mehasaz cezelua luvenab bapofoc yagujod kizenae cejoluf jojofog turiceh bamezei kikiluj jotubak wowofol jopomem zesacen cecedio pozejop guhanaq podizer saworis hacedit saguguu savenav satusaw povetux lukihay gudiwoz yagujoa bapodib cesayac yawotud cezejoe cesarif fowoceg yamesah baluwoi cejoyaj rifobak.

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
EXPECTED_OUTPUT = {'result': {'target_extension': 'json', 'minimum_bytes': 52, 'selected_files': ['incoming/active/xenial_brisk_0985_03.json'], 'active_extension_counts': {'cfg': 5, 'json': 1}, 'largest_active_file': {'path': 'incoming/active/xenial_brisk_0985_07.cfg', 'bytes': 173}}, 'evidence': ['incoming/active/xenial_brisk_0985_01.cfg', 'incoming/active/xenial_brisk_0985_02.cfg', 'incoming/active/xenial_brisk_0985_03.json', 'incoming/active/xenial_brisk_0985_05.cfg'], 'verification': {'checked_files': 9, 'ignored_archive': True, 'status': 'pass'}}

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
