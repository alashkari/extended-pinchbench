---
id: task_syn_001729
name: Active file manifest 001729
category: file_directory_operations
grading_type: automated
timeout_seconds: 240
workspace_files:
- source: task_syn_001729/workspace/incoming/archive/harbor_quartz_0865_00.json
  dest: incoming/archive/harbor_quartz_0865_00.json
- source: task_syn_001729/workspace/incoming/active/harbor_quartz_0865_01.md
  dest: incoming/active/harbor_quartz_0865_01.md
- source: task_syn_001729/workspace/incoming/active/harbor_quartz_0865_02.cfg
  dest: incoming/active/harbor_quartz_0865_02.cfg
- source: task_syn_001729/workspace/incoming/active/harbor_quartz_0865_03.cfg
  dest: incoming/active/harbor_quartz_0865_03.cfg
- source: task_syn_001729/workspace/incoming/archive/harbor_quartz_0865_04.cfg
  dest: incoming/archive/harbor_quartz_0865_04.cfg
- source: task_syn_001729/workspace/incoming/active/harbor_quartz_0865_05.json
  dest: incoming/active/harbor_quartz_0865_05.json
- source: task_syn_001729/workspace/incoming/active/harbor_quartz_0865_06.cfg
  dest: incoming/active/harbor_quartz_0865_06.cfg
- source: task_syn_001729/workspace/incoming/active/harbor_quartz_0865_07.cfg
  dest: incoming/active/harbor_quartz_0865_07.cfg
- source: task_syn_001729/workspace/incoming/archive/harbor_quartz_0865_08.log
  dest: incoming/archive/harbor_quartz_0865_08.log
capability_family: file_directory_operations
intended_difficulty_band: 4
base_scenario_id: scenario_000865
generator_seed: 793973
multi_session: false
---

## Prompt

You are working on synthetic task `task_syn_001729` for the `access cleanup` scenario `harbor-quartz-0865`.
Use only the files supplied in the workspace. Do not fetch live data or use credentials.

Inspect the files under `incoming/active/` for the access cleanup workspace. Ignore everything under `incoming/archive/`. Select active files ending in `.json` whose byte length is at least 52, count active files by extension, and identify the largest active file.

Scenario-specific audit anchors: poridin dijotuo banavep foyajoq difomer havetus lubayat cedijou natuwov nafoluw salucex hamejoy wodihaz ceceyaa ceyaceb barihac sabaved nakizee tudivef yadinag venahah kisamei yahacej zehaguk kitugul hapogum pojofon haguyao lujohap sadibaq lufotur babawos rituhat tulubau cetukiv hawotuw yayayax wowoluy hamevez zesatua satubab digutuc ribahad yatugue risapof gulunag bawofoh veluwoi veyadij mepocek disahal bazevem kimeyan nahafoo navemep vevekiq gufohar babasas hatufot womezeu babafov kijobaw bahafox sawozey mejobaz mecejoa narilub haforic balubad woworie napotuf gufoyag tusazeh gulukii bapofoj sasarik kigufol pogusam luponan zeyafoo jonapop celuriq tugudir fodikis jojomet tusaceu dihaguv hafofow yadiwox sanapoy wolutuz fometua ribadib kijopoc zefowod celuwoe.

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
EXPECTED_OUTPUT = {'result': {'target_extension': 'json', 'minimum_bytes': 52, 'selected_files': ['incoming/active/harbor_quartz_0865_05.json'], 'active_extension_counts': {'cfg': 4, 'json': 1, 'md': 1}, 'largest_active_file': {'path': 'incoming/active/harbor_quartz_0865_07.cfg', 'bytes': 174}}, 'evidence': ['incoming/active/harbor_quartz_0865_01.md', 'incoming/active/harbor_quartz_0865_02.cfg', 'incoming/active/harbor_quartz_0865_03.cfg', 'incoming/active/harbor_quartz_0865_05.json'], 'verification': {'checked_files': 9, 'ignored_archive': True, 'status': 'pass'}}

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
