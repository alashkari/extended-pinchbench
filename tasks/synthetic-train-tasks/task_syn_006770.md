---
id: task_syn_006770
name: Active file manifest 006770
category: file_directory_operations
grading_type: automated
timeout_seconds: 270
workspace_files:
- source: task_syn_006770/workspace/incoming/archive/frost_delta_3385_00.log
  dest: incoming/archive/frost_delta_3385_00.log
- source: task_syn_006770/workspace/incoming/active/frost_delta_3385_01.cfg
  dest: incoming/active/frost_delta_3385_01.cfg
- source: task_syn_006770/workspace/incoming/active/frost_delta_3385_02.md
  dest: incoming/active/frost_delta_3385_02.md
- source: task_syn_006770/workspace/incoming/active/frost_delta_3385_03.cfg
  dest: incoming/active/frost_delta_3385_03.cfg
- source: task_syn_006770/workspace/incoming/archive/frost_delta_3385_04.txt
  dest: incoming/archive/frost_delta_3385_04.txt
- source: task_syn_006770/workspace/incoming/active/frost_delta_3385_05.txt
  dest: incoming/active/frost_delta_3385_05.txt
- source: task_syn_006770/workspace/incoming/active/frost_delta_3385_06.txt
  dest: incoming/active/frost_delta_3385_06.txt
- source: task_syn_006770/workspace/incoming/active/frost_delta_3385_07.log
  dest: incoming/active/frost_delta_3385_07.log
- source: task_syn_006770/workspace/incoming/archive/frost_delta_3385_08.md
  dest: incoming/archive/frost_delta_3385_08.md
- source: task_syn_006770/workspace/incoming/active/frost_delta_3385_09.md
  dest: incoming/active/frost_delta_3385_09.md
- source: task_syn_006770/workspace/incoming/active/frost_delta_3385_10.md
  dest: incoming/active/frost_delta_3385_10.md
- source: task_syn_006770/workspace/incoming/active/frost_delta_3385_11.log
  dest: incoming/active/frost_delta_3385_11.log
- source: task_syn_006770/workspace/incoming/archive/distractor_006770.txt
  dest: incoming/archive/distractor_006770.txt
capability_family: file_directory_operations
intended_difficulty_band: 5
base_scenario_id: scenario_003385
generator_seed: 980490
multi_session: false
---

## Prompt

You are working on synthetic task `task_syn_006770` for the `knowledge-base upkeep` scenario `frost-delta-3385`.
Use only the files supplied in the workspace. Do not fetch live data or use credentials.

Inspect the files under `incoming/active/` for the knowledge-base upkeep workspace. Ignore everything under `incoming/archive/`. Select active files ending in `.txt` whose byte length is at least 59, count active files by extension, and identify the largest active file.

Scenario-specific audit anchors: fopobak dikidil satutum babanan yahasao tuwocep satukiq pomezer vejosas haguwot cedidiu jogutuv zezezew ludicex guwofoy jozeluz cewotua hacegub woyayac lukilud tuwonae mepopof vepozeg dinameh rinarii wosawoj dinacek riwotul yadiwom pofoban wokidio ribagup nanawoq rivejor joporis zericet veporiu halucev zemeriw josawox povesay divevez ripobaa wozejob lucejoc disanad fomesae gugufof tunafog balumeh tuyazei riyamej poyahak cemejol joguwom hadifon yapoluo turisap cemeveq turigur gulukis haripot mewoguu yanatuv wovemew halucex tuvezey zeyabaz sapofoa cevelub gulujoc zepodid ceyapoe poyahaf najohag bakifoh wokifoi meyafoj kiyayak wotusal pozevem luwotun zemehao wotuyap wotuceq jokiwor fojobas wotufot bawoluu cewovev meluyaw naludix mehadiy cediwoz wokiyaa rihadib.

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
EXPECTED_OUTPUT = {'result': {'target_extension': 'txt', 'minimum_bytes': 59, 'selected_files': ['incoming/active/frost_delta_3385_05.txt', 'incoming/active/frost_delta_3385_06.txt'], 'active_extension_counts': {'cfg': 2, 'log': 2, 'md': 3, 'txt': 2}, 'largest_active_file': {'path': 'incoming/active/frost_delta_3385_11.log', 'bytes': 215}}, 'evidence': ['incoming/active/frost_delta_3385_01.cfg', 'incoming/active/frost_delta_3385_02.md', 'incoming/active/frost_delta_3385_03.cfg', 'incoming/active/frost_delta_3385_05.txt'], 'verification': {'checked_files': 13, 'ignored_archive': True, 'status': 'pass'}}

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
