---
id: task_syn_003338
name: Active file manifest 003338
category: file_directory_operations
grading_type: automated
timeout_seconds: 210
workspace_files:
- source: task_syn_003338/workspace/incoming/archive/frost_zenith_1669_00.txt
  dest: incoming/archive/frost_zenith_1669_00.txt
- source: task_syn_003338/workspace/incoming/active/frost_zenith_1669_01.txt
  dest: incoming/active/frost_zenith_1669_01.txt
- source: task_syn_003338/workspace/incoming/active/frost_zenith_1669_02.log
  dest: incoming/active/frost_zenith_1669_02.log
- source: task_syn_003338/workspace/incoming/active/frost_zenith_1669_03.log
  dest: incoming/active/frost_zenith_1669_03.log
- source: task_syn_003338/workspace/incoming/archive/frost_zenith_1669_04.txt
  dest: incoming/archive/frost_zenith_1669_04.txt
- source: task_syn_003338/workspace/incoming/active/frost_zenith_1669_05.json
  dest: incoming/active/frost_zenith_1669_05.json
- source: task_syn_003338/workspace/incoming/active/frost_zenith_1669_06.json
  dest: incoming/active/frost_zenith_1669_06.json
- source: task_syn_003338/workspace/incoming/active/frost_zenith_1669_07.json
  dest: incoming/active/frost_zenith_1669_07.json
capability_family: file_directory_operations
intended_difficulty_band: 3
base_scenario_id: scenario_001669
generator_seed: 853506
multi_session: false
---

## Prompt

You are working on synthetic task `task_syn_003338` for the `customer migration` scenario `frost-zenith-1669`.
Use only the files supplied in the workspace. Do not fetch live data or use credentials.

Inspect the files under `incoming/active/` for the customer migration workspace. Ignore everything under `incoming/archive/`. Select active files ending in `.md` whose byte length is at least 45, count active files by extension, and identify the largest active file.

Scenario-specific audit anchors: wowoluk bajodil powogum pofotun diwofoo haguzep cekiguq badijor tubaces vefokit vetuceu meveriv venatuw ribavex jomediy joridiz luwojoa lunakib joribac badimed powobae zeriyaf fobaceg yariguh gufogui lurikij zesadik pogupol pofolum luhaban riyapoo nasacep yajodiq vevemer lusafos naguvet bayapou hakicev meriwow kiceyax rinahay dinazez guwovea povewob saguhac guluzed dipowoe hayapof fomebag yaguguh zezebai jojonaj cekituk riguvel vesavem yajolun meveluo sayarip tunameq kitujor yanames gukiwot sazetuu zedivev vekinaw dizejox kikiyay vesakiz fowobaa nadigub kiriguc cefofod hajozee wonawof fobawog sazebah zesayai natutuj hapodik haluyal fogubam hariwon vediveo ludizep tuzetuq samever jojolus joyamet gunabau dijomev sayajow hawolux dicefoy zediluz tuguhaa bagupob.

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
EXPECTED_OUTPUT = {'result': {'target_extension': 'md', 'minimum_bytes': 45, 'selected_files': [], 'active_extension_counts': {'json': 3, 'log': 2, 'txt': 1}, 'largest_active_file': {'path': 'incoming/active/frost_zenith_1669_07.json', 'bytes': 170}}, 'evidence': ['incoming/active/frost_zenith_1669_01.txt', 'incoming/active/frost_zenith_1669_02.log', 'incoming/active/frost_zenith_1669_03.log', 'incoming/active/frost_zenith_1669_05.json'], 'verification': {'checked_files': 8, 'ignored_archive': True, 'status': 'pass'}}

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
