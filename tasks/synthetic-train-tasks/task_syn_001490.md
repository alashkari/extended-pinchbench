---
id: task_syn_001490
name: Active file manifest 001490
category: file_directory_operations
grading_type: automated
timeout_seconds: 270
workspace_files:
- source: task_syn_001490/workspace/incoming/archive/ripple_ion_0745_00.md
  dest: incoming/archive/ripple_ion_0745_00.md
- source: task_syn_001490/workspace/incoming/active/ripple_ion_0745_01.md
  dest: incoming/active/ripple_ion_0745_01.md
- source: task_syn_001490/workspace/incoming/active/ripple_ion_0745_02.cfg
  dest: incoming/active/ripple_ion_0745_02.cfg
- source: task_syn_001490/workspace/incoming/active/ripple_ion_0745_03.cfg
  dest: incoming/active/ripple_ion_0745_03.cfg
- source: task_syn_001490/workspace/incoming/archive/ripple_ion_0745_04.log
  dest: incoming/archive/ripple_ion_0745_04.log
- source: task_syn_001490/workspace/incoming/active/ripple_ion_0745_05.md
  dest: incoming/active/ripple_ion_0745_05.md
- source: task_syn_001490/workspace/incoming/active/ripple_ion_0745_06.cfg
  dest: incoming/active/ripple_ion_0745_06.cfg
- source: task_syn_001490/workspace/incoming/active/ripple_ion_0745_07.md
  dest: incoming/active/ripple_ion_0745_07.md
- source: task_syn_001490/workspace/incoming/archive/ripple_ion_0745_08.json
  dest: incoming/archive/ripple_ion_0745_08.json
- source: task_syn_001490/workspace/incoming/active/ripple_ion_0745_09.log
  dest: incoming/active/ripple_ion_0745_09.log
- source: task_syn_001490/workspace/incoming/active/ripple_ion_0745_10.json
  dest: incoming/active/ripple_ion_0745_10.json
- source: task_syn_001490/workspace/incoming/active/ripple_ion_0745_11.txt
  dest: incoming/active/ripple_ion_0745_11.txt
- source: task_syn_001490/workspace/incoming/archive/distractor_001490.txt
  dest: incoming/archive/distractor_001490.txt
capability_family: file_directory_operations
intended_difficulty_band: 5
base_scenario_id: scenario_000745
generator_seed: 785130
multi_session: false
---

## Prompt

You are working on synthetic task `task_syn_001490` for the `knowledge-base upkeep` scenario `ripple-ion-0745`.
Use only the files supplied in the workspace. Do not fetch live data or use credentials.

Inspect the files under `incoming/active/` for the knowledge-base upkeep workspace. Ignore everything under `incoming/archive/`. Select active files ending in `.txt` whose byte length is at least 59, count active files by extension, and identify the largest active file.

Scenario-specific audit anchors: mewocei cebarij fogubak diguhal pomecem lurilun sazerio naripop safodiq sayabar mepowos ponapot kirizeu wotumev luriluw memekix luzejoy tufobaz tuhavea podimeb zejosac hayamed sacewoe pohamef guveveg bagukih samezei wozevej kihadik babagul vediham nawokin riguluo sajowop risameq yalumer zepodis badilut sawomeu zezekiv folupow kiditux rinariy dinazez vemefoa guyafob nahazec jomelud zecerie zeponaf pometug nayadih gukinai vejocej fohayak hagukil turidim fojomen kiyakio gufobap jomehaq gutubar jogulus tufozet didiluu povecev mepoguw tunawox gujobay riguluz saluyaa tumeceb lutuguc dibabad vefohae cefoyaf ludiyag tunaluh lubayai joyarij sadinak guzewol navetum nafoban tudipoo bagulup yamemeq kitulur sawozes wowobat bafoluu hajoguv dicejow vetujox hayasay hacediz.

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
Some supplied information is intentionally irrelevant; exclude it from the result.

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
EXPECTED_OUTPUT = {'result': {'target_extension': 'txt', 'minimum_bytes': 59, 'selected_files': ['incoming/active/ripple_ion_0745_11.txt'], 'active_extension_counts': {'cfg': 3, 'json': 1, 'log': 1, 'md': 3, 'txt': 1}, 'largest_active_file': {'path': 'incoming/active/ripple_ion_0745_11.txt', 'bytes': 214}}, 'evidence': ['incoming/active/ripple_ion_0745_01.md', 'incoming/active/ripple_ion_0745_02.cfg', 'incoming/active/ripple_ion_0745_03.cfg', 'incoming/active/ripple_ion_0745_05.md'], 'verification': {'checked_files': 13, 'ignored_archive': True, 'status': 'pass'}}

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
