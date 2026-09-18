---
id: task_syn_002785
name: Active file manifest 002785
category: file_directory_operations
grading_type: automated
timeout_seconds: 270
workspace_files:
- source: task_syn_002785/workspace/incoming/archive/prairie_keystone_1393_00.md
  dest: incoming/archive/prairie_keystone_1393_00.md
- source: task_syn_002785/workspace/incoming/active/prairie_keystone_1393_01.log
  dest: incoming/active/prairie_keystone_1393_01.log
- source: task_syn_002785/workspace/incoming/active/prairie_keystone_1393_02.cfg
  dest: incoming/active/prairie_keystone_1393_02.cfg
- source: task_syn_002785/workspace/incoming/active/prairie_keystone_1393_03.log
  dest: incoming/active/prairie_keystone_1393_03.log
- source: task_syn_002785/workspace/incoming/archive/prairie_keystone_1393_04.md
  dest: incoming/archive/prairie_keystone_1393_04.md
- source: task_syn_002785/workspace/incoming/active/prairie_keystone_1393_05.json
  dest: incoming/active/prairie_keystone_1393_05.json
- source: task_syn_002785/workspace/incoming/active/prairie_keystone_1393_06.md
  dest: incoming/active/prairie_keystone_1393_06.md
- source: task_syn_002785/workspace/incoming/active/prairie_keystone_1393_07.json
  dest: incoming/active/prairie_keystone_1393_07.json
- source: task_syn_002785/workspace/incoming/archive/prairie_keystone_1393_08.json
  dest: incoming/archive/prairie_keystone_1393_08.json
- source: task_syn_002785/workspace/incoming/active/prairie_keystone_1393_09.log
  dest: incoming/active/prairie_keystone_1393_09.log
- source: task_syn_002785/workspace/incoming/archive/distractor_002785.txt
  dest: incoming/archive/distractor_002785.txt
capability_family: file_directory_operations
intended_difficulty_band: 5
base_scenario_id: scenario_001393
generator_seed: 833045
multi_session: false
---

## Prompt

You are working on synthetic task `task_syn_002785` for the `knowledge-base upkeep` scenario `prairie-keystone-1393`.
Use only the files supplied in the workspace. Do not fetch live data or use credentials.

Inspect the files under `incoming/active/` for the knowledge-base upkeep workspace. Ignore everything under `incoming/archive/`. Select active files ending in `.txt` whose byte length is at least 59, count active files by extension, and identify the largest active file.

Scenario-specific audit anchors: ponaved pozebae lutuvef metuceg kihatuh risakii vetuzej gubawok hadikil yaluwom yazeven woponao powovep lumeceq jopodir rimezes wodinat foyafou kisayav sagusaw digusax luriguy tugufoz diwobaa wozekib cesayac pogumed hacefoe pogujof pocenag badiluh kiguhai celujoj yayamek riyasal gusadim tutuyan hadiyao powowop podiceq narigur nabajos kimemet kicehau cenazev vekizew kifoyax lunadiy vejowoz mekifoa cediwob jomenac hazebad vebamee riforif mevesag luriguh lulusai gudimej zewowok worizel zezerim luvemen yameguo kinakip meririq yayadir safodis sayadit gugutuu diveriv hatudiw diharix dimevey wofoguz veditua sarihab yamebac wofojod fogukie namedif mezetug tutuceh didibai johacej nagubak ritubal wofomem hazenan sajozeo vepocep jocesaq kiwocer vewohas yacevet salutuu.

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
EXPECTED_OUTPUT = {'result': {'target_extension': 'txt', 'minimum_bytes': 59, 'selected_files': [], 'active_extension_counts': {'cfg': 1, 'json': 2, 'log': 3, 'md': 1}, 'largest_active_file': {'path': 'incoming/active/prairie_keystone_1393_09.log', 'bytes': 205}}, 'evidence': ['incoming/active/prairie_keystone_1393_01.log', 'incoming/active/prairie_keystone_1393_02.cfg', 'incoming/active/prairie_keystone_1393_03.log', 'incoming/active/prairie_keystone_1393_05.json'], 'verification': {'checked_files': 11, 'ignored_archive': True, 'status': 'pass'}}

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
