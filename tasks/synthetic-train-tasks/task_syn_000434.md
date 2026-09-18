---
id: task_syn_000434
name: Active file manifest 000434
category: file_directory_operations
grading_type: automated
timeout_seconds: 240
workspace_files:
- source: task_syn_000434/workspace/incoming/archive/juniper_ripple_0217_00.txt
  dest: incoming/archive/juniper_ripple_0217_00.txt
- source: task_syn_000434/workspace/incoming/active/juniper_ripple_0217_01.md
  dest: incoming/active/juniper_ripple_0217_01.md
- source: task_syn_000434/workspace/incoming/active/juniper_ripple_0217_02.json
  dest: incoming/active/juniper_ripple_0217_02.json
- source: task_syn_000434/workspace/incoming/active/juniper_ripple_0217_03.log
  dest: incoming/active/juniper_ripple_0217_03.log
- source: task_syn_000434/workspace/incoming/archive/juniper_ripple_0217_04.md
  dest: incoming/archive/juniper_ripple_0217_04.md
- source: task_syn_000434/workspace/incoming/active/juniper_ripple_0217_05.md
  dest: incoming/active/juniper_ripple_0217_05.md
- source: task_syn_000434/workspace/incoming/active/juniper_ripple_0217_06.json
  dest: incoming/active/juniper_ripple_0217_06.json
- source: task_syn_000434/workspace/incoming/active/juniper_ripple_0217_07.txt
  dest: incoming/active/juniper_ripple_0217_07.txt
- source: task_syn_000434/workspace/incoming/archive/juniper_ripple_0217_08.txt
  dest: incoming/archive/juniper_ripple_0217_08.txt
- source: task_syn_000434/workspace/incoming/active/juniper_ripple_0217_09.cfg
  dest: incoming/active/juniper_ripple_0217_09.cfg
- source: task_syn_000434/workspace/incoming/active/juniper_ripple_0217_10.cfg
  dest: incoming/active/juniper_ripple_0217_10.cfg
capability_family: file_directory_operations
intended_difficulty_band: 4
base_scenario_id: scenario_000217
generator_seed: 746058
multi_session: false
---

## Prompt

You are working on synthetic task `task_syn_000434` for the `access cleanup` scenario `juniper-ripple-0217`.
Use only the files supplied in the workspace. Do not fetch live data or use credentials.

Inspect the files under `incoming/active/` for the access cleanup workspace. Ignore everything under `incoming/archive/`. Select active files ending in `.json` whose byte length is at least 52, count active files by extension, and identify the largest active file.

Scenario-specific audit anchors: lulufos yatusat zewodiu cehabav venatuw kiririx namezey cetupoz josacea nasabab jodibac kisazed kizelue harituf nahafog guhajoh baditui zegufoj nariluk merifol fowoyam lufohan yabanao zegufop nawoceq kisanar naluzes lukiyat yaluhau yafopov woribaw sajovex gulukiy bapocez yatuhaa namewob jonajoc yagupod tuverie bavepof merilug wodiluh bajopoi wozewoj zezeguk gusalul rifotum rizewon zefomeo womemep bapotuq fojover vefokis riwolut fonapou cenahav lurisaw cemegux dicefoy nababaz wozesaa jozebab bayamec babatud tukidie zevetuf fofodig rifomeh turizei gumeyaj cewopok hafopol veyalum digusan ponaceo cetujop rinawoq nalupor zewoves tuvezet nasatuu nanamev gumemew dijolux fomehay gudiguz ceyamea rizejob kiluhac rihaced riwovee cenajof pobarig yatufoh mesajoi poyaguj.

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
EXPECTED_OUTPUT = {'result': {'target_extension': 'json', 'minimum_bytes': 52, 'selected_files': ['incoming/active/juniper_ripple_0217_02.json', 'incoming/active/juniper_ripple_0217_06.json'], 'active_extension_counts': {'cfg': 2, 'json': 2, 'log': 1, 'md': 2, 'txt': 1}, 'largest_active_file': {'path': 'incoming/active/juniper_ripple_0217_10.cfg', 'bytes': 199}}, 'evidence': ['incoming/active/juniper_ripple_0217_01.md', 'incoming/active/juniper_ripple_0217_02.json', 'incoming/active/juniper_ripple_0217_03.log', 'incoming/active/juniper_ripple_0217_05.md'], 'verification': {'checked_files': 11, 'ignored_archive': True, 'status': 'pass'}}

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
