---
id: task_syn_001105
name: Active file manifest 001105
category: file_directory_operations
grading_type: automated
timeout_seconds: 270
workspace_files:
- source: task_syn_001105/workspace/incoming/archive/harbor_quartz_0553_00.log
  dest: incoming/archive/harbor_quartz_0553_00.log
- source: task_syn_001105/workspace/incoming/active/harbor_quartz_0553_01.cfg
  dest: incoming/active/harbor_quartz_0553_01.cfg
- source: task_syn_001105/workspace/incoming/active/harbor_quartz_0553_02.cfg
  dest: incoming/active/harbor_quartz_0553_02.cfg
- source: task_syn_001105/workspace/incoming/active/harbor_quartz_0553_03.cfg
  dest: incoming/active/harbor_quartz_0553_03.cfg
- source: task_syn_001105/workspace/incoming/archive/harbor_quartz_0553_04.cfg
  dest: incoming/archive/harbor_quartz_0553_04.cfg
- source: task_syn_001105/workspace/incoming/active/harbor_quartz_0553_05.txt
  dest: incoming/active/harbor_quartz_0553_05.txt
- source: task_syn_001105/workspace/incoming/active/harbor_quartz_0553_06.log
  dest: incoming/active/harbor_quartz_0553_06.log
- source: task_syn_001105/workspace/incoming/active/harbor_quartz_0553_07.txt
  dest: incoming/active/harbor_quartz_0553_07.txt
- source: task_syn_001105/workspace/incoming/archive/harbor_quartz_0553_08.md
  dest: incoming/archive/harbor_quartz_0553_08.md
- source: task_syn_001105/workspace/incoming/active/harbor_quartz_0553_09.md
  dest: incoming/active/harbor_quartz_0553_09.md
- source: task_syn_001105/workspace/incoming/archive/distractor_001105.txt
  dest: incoming/archive/distractor_001105.txt
capability_family: file_directory_operations
intended_difficulty_band: 5
base_scenario_id: scenario_000553
generator_seed: 770885
multi_session: false
---

## Prompt

You are working on synthetic task `task_syn_001105` for the `knowledge-base upkeep` scenario `harbor-quartz-0553`.
Use only the files supplied in the workspace. Do not fetch live data or use credentials.

Inspect the files under `incoming/active/` for the knowledge-base upkeep workspace. Ignore everything under `incoming/archive/`. Select active files ending in `.txt` whose byte length is at least 59, count active files by extension, and identify the largest active file.

Scenario-specific audit anchors: cenasan sabanao mewokip veyafoq halukir najokis halukit womekiu hazebav tuvediw guridix foludiy kikisaz kiriria tunagub kicedic nahasad yakiwoe zekinaf cemewog najorih mekifoi zejopoj zefojok fojopol jogudim gumesan zegusao gumerip kinafoq kimepor vejogus yakicet ritutuu zetupov luyanaw wonadix nazepoy metuhaz melusaa dirifob wozesac vewoved yabapoe kibatuf yazekig bameyah yafowoi vecetuj zewoyak zehapol kigulum popocen tuyaluo poyabap gutuzeq tupogur naveris najoyat disabau cezecev kikiguw lubacex nawosay wotufoz diyapoa yajotub fogutuc tutuyad tupotue vedinaf cewokig sayazeh popokii zetumej metuvek hahagul fofobam gugupon zezenao tudihap cesawoq bayahar gufozes dipobat wofopou hakicev saripow worivex yadipoy wolutuz yagusaa dicelub babatuc sasamed yadinae.

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
EXPECTED_OUTPUT = {'result': {'target_extension': 'txt', 'minimum_bytes': 59, 'selected_files': ['incoming/active/harbor_quartz_0553_05.txt', 'incoming/active/harbor_quartz_0553_07.txt'], 'active_extension_counts': {'cfg': 3, 'log': 1, 'md': 1, 'txt': 2}, 'largest_active_file': {'path': 'incoming/active/harbor_quartz_0553_09.md', 'bytes': 202}}, 'evidence': ['incoming/active/harbor_quartz_0553_01.cfg', 'incoming/active/harbor_quartz_0553_02.cfg', 'incoming/active/harbor_quartz_0553_03.cfg', 'incoming/active/harbor_quartz_0553_05.txt'], 'verification': {'checked_files': 11, 'ignored_archive': True, 'status': 'pass'}}

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
