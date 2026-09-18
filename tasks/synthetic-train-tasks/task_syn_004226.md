---
id: task_syn_004226
name: Active file manifest 004226
category: file_directory_operations
grading_type: automated
timeout_seconds: 150
workspace_files:
- source: task_syn_004226/workspace/incoming/archive/harbor_lumen_2113_00.cfg
  dest: incoming/archive/harbor_lumen_2113_00.cfg
- source: task_syn_004226/workspace/incoming/active/harbor_lumen_2113_01.cfg
  dest: incoming/active/harbor_lumen_2113_01.cfg
- source: task_syn_004226/workspace/incoming/active/harbor_lumen_2113_02.md
  dest: incoming/active/harbor_lumen_2113_02.md
- source: task_syn_004226/workspace/incoming/active/harbor_lumen_2113_03.json
  dest: incoming/active/harbor_lumen_2113_03.json
- source: task_syn_004226/workspace/incoming/archive/harbor_lumen_2113_04.cfg
  dest: incoming/archive/harbor_lumen_2113_04.cfg
- source: task_syn_004226/workspace/incoming/active/harbor_lumen_2113_05.md
  dest: incoming/active/harbor_lumen_2113_05.md
capability_family: file_directory_operations
intended_difficulty_band: 1
base_scenario_id: scenario_002113
generator_seed: 886362
multi_session: false
---

## Prompt

You are working on synthetic task `task_syn_004226` for the `release readiness` scenario `harbor-lumen-2113`.
Use only the files supplied in the workspace. Do not fetch live data or use credentials.

Inspect the files under `incoming/active/` for the release readiness workspace. Ignore everything under `incoming/archive/`. Select active files ending in `.log` whose byte length is at least 31, count active files by extension, and identify the largest active file.

Scenario-specific audit anchors: pofoluo guceyap kiriguq rizezer pomeves batuhat tumeguu jotucev vesapow rivecex tusawoy dibawoz dizekia nametub didikic sawotud jovetue lupoyaf rigusag pohadih luvefoi haveluj vemetuk foditul jofomem veveven sagujoo pozerip saripoq vepodir rihayas guriwot veceguu fohanav mewohaw bapovex venajoy vecediz lujogua saponab napodic yatuyad rilujoe forizef zegutug basameh lukifoi venadij vezebak meluhal ponacem zekikin cecerio cesatup foporiq vesapor ribahas jovevet hanaceu popozev rihapow rimedix meyapoy veyatuz kidicea luzepob mekikic fovegud kihatue zelunaf nawolug vemesah gubahai bacesaj zekiguk najodil yanawom rimelun zeyario focelup pojohaq vemenar hatuzes kibalut yameveu zewofov kicefow rimewox zehadiy yaluyaz luzetua sakipob wojofoc basafod cezehae tupodif.

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
EXPECTED_OUTPUT = {'result': {'target_extension': 'log', 'minimum_bytes': 31, 'selected_files': [], 'active_extension_counts': {'cfg': 1, 'json': 1, 'md': 2}, 'largest_active_file': {'path': 'incoming/active/harbor_lumen_2113_05.md', 'bytes': 141}}, 'evidence': ['incoming/active/harbor_lumen_2113_01.cfg', 'incoming/active/harbor_lumen_2113_02.md', 'incoming/active/harbor_lumen_2113_03.json', 'incoming/active/harbor_lumen_2113_05.md'], 'verification': {'checked_files': 6, 'ignored_archive': True, 'status': 'pass'}}

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
