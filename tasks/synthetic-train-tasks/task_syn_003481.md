---
id: task_syn_003481
name: Active file manifest 003481
category: file_directory_operations
grading_type: automated
timeout_seconds: 150
workspace_files:
- source: task_syn_003481/workspace/incoming/archive/zenith_amber_1741_00.log
  dest: incoming/archive/zenith_amber_1741_00.log
- source: task_syn_003481/workspace/incoming/active/zenith_amber_1741_01.json
  dest: incoming/active/zenith_amber_1741_01.json
- source: task_syn_003481/workspace/incoming/active/zenith_amber_1741_02.md
  dest: incoming/active/zenith_amber_1741_02.md
- source: task_syn_003481/workspace/incoming/active/zenith_amber_1741_03.md
  dest: incoming/active/zenith_amber_1741_03.md
- source: task_syn_003481/workspace/incoming/archive/zenith_amber_1741_04.cfg
  dest: incoming/archive/zenith_amber_1741_04.cfg
- source: task_syn_003481/workspace/incoming/active/zenith_amber_1741_05.json
  dest: incoming/active/zenith_amber_1741_05.json
capability_family: file_directory_operations
intended_difficulty_band: 1
base_scenario_id: scenario_001741
generator_seed: 858797
multi_session: false
---

## Prompt

You are working on synthetic task `task_syn_003481` for the `release readiness` scenario `zenith-amber-1741`.
Use only the files supplied in the workspace. Do not fetch live data or use credentials.

Inspect the files under `incoming/active/` for the release readiness workspace. Ignore everything under `incoming/archive/`. Select active files ending in `.log` whose byte length is at least 31, count active files by extension, and identify the largest active file.

Scenario-specific audit anchors: haponax bawoyay lukiwoz rimesaa diripob tuveyac dicewod pojovee banaluf tujodig vediwoh riyamei zehayaj bayayak balujol mejotum riluyan tupoyao zejobap vecejoq vepocer yabasas lucetut guriyau zehapov jodivew cezevex banariy rinacez joyacea jotudib didiwoc bacefod zeyarie naluyaf riforig riludih yazecei lusahaj gurihak cecemel yaveham naricen diyafoo zevedip vehabaq kibasar dizemes divehat zesajou luzecev rizecew safowox tupopoy divekiz mebamea guvesab bakisac yasarid nadipoe luhahaf luceceg nariluh gugunai powoyaj cejosak rifosal jomejom cevetun joturio didivep tubanaq tunacer satuyas vebasat yavenau mejojov nariluw gulusax celuluy yariyaz sasabaa samewob lusayac yazetud yacecee sarivef saporig lutuyah kikibai guhavej nahatuk sajohal kilubam lukinan yazezeo.

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
EXPECTED_OUTPUT = {'result': {'target_extension': 'log', 'minimum_bytes': 31, 'selected_files': [], 'active_extension_counts': {'json': 2, 'md': 2}, 'largest_active_file': {'path': 'incoming/active/zenith_amber_1741_05.json', 'bytes': 141}}, 'evidence': ['incoming/active/zenith_amber_1741_01.json', 'incoming/active/zenith_amber_1741_02.md', 'incoming/active/zenith_amber_1741_03.md', 'incoming/active/zenith_amber_1741_05.json'], 'verification': {'checked_files': 6, 'ignored_archive': True, 'status': 'pass'}}

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
