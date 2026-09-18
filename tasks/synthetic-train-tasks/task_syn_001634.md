---
id: task_syn_001634
name: Active file manifest 001634
category: file_directory_operations
grading_type: automated
timeout_seconds: 240
workspace_files:
- source: task_syn_001634/workspace/incoming/archive/lumen_xenial_0817_00.json
  dest: incoming/archive/lumen_xenial_0817_00.json
- source: task_syn_001634/workspace/incoming/active/lumen_xenial_0817_01.json
  dest: incoming/active/lumen_xenial_0817_01.json
- source: task_syn_001634/workspace/incoming/active/lumen_xenial_0817_02.log
  dest: incoming/active/lumen_xenial_0817_02.log
- source: task_syn_001634/workspace/incoming/active/lumen_xenial_0817_03.json
  dest: incoming/active/lumen_xenial_0817_03.json
- source: task_syn_001634/workspace/incoming/archive/lumen_xenial_0817_04.log
  dest: incoming/archive/lumen_xenial_0817_04.log
- source: task_syn_001634/workspace/incoming/active/lumen_xenial_0817_05.md
  dest: incoming/active/lumen_xenial_0817_05.md
- source: task_syn_001634/workspace/incoming/active/lumen_xenial_0817_06.log
  dest: incoming/active/lumen_xenial_0817_06.log
- source: task_syn_001634/workspace/incoming/active/lumen_xenial_0817_07.md
  dest: incoming/active/lumen_xenial_0817_07.md
- source: task_syn_001634/workspace/incoming/archive/lumen_xenial_0817_08.md
  dest: incoming/archive/lumen_xenial_0817_08.md
- source: task_syn_001634/workspace/incoming/active/lumen_xenial_0817_09.md
  dest: incoming/active/lumen_xenial_0817_09.md
- source: task_syn_001634/workspace/incoming/active/lumen_xenial_0817_10.md
  dest: incoming/active/lumen_xenial_0817_10.md
capability_family: file_directory_operations
intended_difficulty_band: 4
base_scenario_id: scenario_000817
generator_seed: 790458
multi_session: false
---

## Prompt

You are working on synthetic task `task_syn_001634` for the `access cleanup` scenario `lumen-xenial-0817`.
Use only the files supplied in the workspace. Do not fetch live data or use credentials.

Inspect the files under `incoming/active/` for the access cleanup workspace. Ignore everything under `incoming/archive/`. Select active files ending in `.json` whose byte length is at least 52, count active files by extension, and identify the largest active file.

Scenario-specific audit anchors: bavesaw focecex tusatuy ponapoz rivelua hanafob sacedic baludid sapowoe turiyaf rituceg kigunah yawopoi cevebaj hakivek bajoril gucerim rilugun wobanao jojodip zefotuq badifor ripodis saguwot vesahau foturiv fobakiw lulujox rifoguy zedikiz hajokia yazekib zeharic hatugud cezefoe yalunaf balumeg rilunah foyanai zekikij lugupok bajowol vezevem fovejon nasaguo bapowop ririceq sasasar bahatus cebakit vevezeu bawokiv dikiguw barimex fohasay rikidiz menazea yasaceb mekikic rilulud gudipoe vewobaf rikipog poceguh disacei vejopoj mehafok mejohal gutukim lujorin fotuveo yafotup celunaq kizever pocenas nasafot joceceu bakivev kizediw dikigux naceyay sapojoz narifoa vesahab tuhatuc dikidid disawoe namewof yawonag tuguyah metusai ceponaj cebawok guceyal dijomem kisaven.

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
EXPECTED_OUTPUT = {'result': {'target_extension': 'json', 'minimum_bytes': 52, 'selected_files': ['incoming/active/lumen_xenial_0817_01.json', 'incoming/active/lumen_xenial_0817_03.json'], 'active_extension_counts': {'json': 2, 'log': 2, 'md': 4}, 'largest_active_file': {'path': 'incoming/active/lumen_xenial_0817_10.md', 'bytes': 197}}, 'evidence': ['incoming/active/lumen_xenial_0817_01.json', 'incoming/active/lumen_xenial_0817_02.log', 'incoming/active/lumen_xenial_0817_03.json', 'incoming/active/lumen_xenial_0817_05.md'], 'verification': {'checked_files': 11, 'ignored_archive': True, 'status': 'pass'}}

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
