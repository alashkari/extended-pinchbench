---
id: task_syn_006505
name: Active file manifest 006505
category: file_directory_operations
grading_type: automated
timeout_seconds: 270
workspace_files:
- source: task_syn_006505/workspace/incoming/archive/delta_summit_3253_00.txt
  dest: incoming/archive/delta_summit_3253_00.txt
- source: task_syn_006505/workspace/incoming/active/delta_summit_3253_01.txt
  dest: incoming/active/delta_summit_3253_01.txt
- source: task_syn_006505/workspace/incoming/active/delta_summit_3253_02.log
  dest: incoming/active/delta_summit_3253_02.log
- source: task_syn_006505/workspace/incoming/active/delta_summit_3253_03.json
  dest: incoming/active/delta_summit_3253_03.json
- source: task_syn_006505/workspace/incoming/archive/delta_summit_3253_04.log
  dest: incoming/archive/delta_summit_3253_04.log
- source: task_syn_006505/workspace/incoming/active/delta_summit_3253_05.txt
  dest: incoming/active/delta_summit_3253_05.txt
- source: task_syn_006505/workspace/incoming/active/delta_summit_3253_06.cfg
  dest: incoming/active/delta_summit_3253_06.cfg
- source: task_syn_006505/workspace/incoming/active/delta_summit_3253_07.md
  dest: incoming/active/delta_summit_3253_07.md
- source: task_syn_006505/workspace/incoming/archive/delta_summit_3253_08.log
  dest: incoming/archive/delta_summit_3253_08.log
- source: task_syn_006505/workspace/incoming/active/delta_summit_3253_09.cfg
  dest: incoming/active/delta_summit_3253_09.cfg
- source: task_syn_006505/workspace/incoming/archive/distractor_006505.txt
  dest: incoming/archive/distractor_006505.txt
capability_family: file_directory_operations
intended_difficulty_band: 5
base_scenario_id: scenario_003253
generator_seed: 970685
multi_session: false
---

## Prompt

You are working on synthetic task `task_syn_006505` for the `knowledge-base upkeep` scenario `delta-summit-3253`.
Use only the files supplied in the workspace. Do not fetch live data or use credentials.

Inspect the files under `incoming/active/` for the knowledge-base upkeep workspace. Ignore everything under `incoming/archive/`. Select active files ending in `.txt` whose byte length is at least 59, count active files by extension, and identify the largest active file.

Scenario-specific audit anchors: diluhaf bahaveg pobarih tujohai rikipoj sazefok fokivel vejotum disakin luriluo hasatup cehabaq yagufor zemeris porihat harituu dizehav pozefow jocevex poririy lupofoz mejokia sakitub wopobac wonapod zevefoe wotujof sapoyag guguwoh kiluyai mefojoj kikinak fotubal wonaham kiveban jobafoo fotumep memeguq zeridir zejoves foriwot nazepou dihatuv ceyamew luponax zehariy wocekiz mewofoa kisasab woguyac hadiced wobamee jocejof pofozeg safoyah rihazei bakituj yabacek dizefol lujopom yaporin nabaveo basakip ditutuq hajonar didiwos wosajot sazefou divezev jozenaw vewolux guwowoy folubaz kinaria divewob bafozec ponagud hacerie difoyaf velupog vepoyah hakitui haceluj gumekik harizel veyavem tuveban yatufoo tunamep jokinaq salunar tufofos namehat cetuwou zenaguv vehahaw.

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
EXPECTED_OUTPUT = {'result': {'target_extension': 'txt', 'minimum_bytes': 59, 'selected_files': ['incoming/active/delta_summit_3253_01.txt', 'incoming/active/delta_summit_3253_05.txt'], 'active_extension_counts': {'cfg': 2, 'json': 1, 'log': 1, 'md': 1, 'txt': 2}, 'largest_active_file': {'path': 'incoming/active/delta_summit_3253_09.cfg', 'bytes': 201}}, 'evidence': ['incoming/active/delta_summit_3253_01.txt', 'incoming/active/delta_summit_3253_02.log', 'incoming/active/delta_summit_3253_03.json', 'incoming/active/delta_summit_3253_05.txt'], 'verification': {'checked_files': 11, 'ignored_archive': True, 'status': 'pass'}}

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
