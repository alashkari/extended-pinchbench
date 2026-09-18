---
id: task_syn_000289
name: Active file manifest 000289
category: file_directory_operations
grading_type: automated
timeout_seconds: 240
workspace_files:
- source: task_syn_000289/workspace/incoming/archive/prairie_willow_0145_00.md
  dest: incoming/archive/prairie_willow_0145_00.md
- source: task_syn_000289/workspace/incoming/active/prairie_willow_0145_01.md
  dest: incoming/active/prairie_willow_0145_01.md
- source: task_syn_000289/workspace/incoming/active/prairie_willow_0145_02.cfg
  dest: incoming/active/prairie_willow_0145_02.cfg
- source: task_syn_000289/workspace/incoming/active/prairie_willow_0145_03.json
  dest: incoming/active/prairie_willow_0145_03.json
- source: task_syn_000289/workspace/incoming/archive/prairie_willow_0145_04.txt
  dest: incoming/archive/prairie_willow_0145_04.txt
- source: task_syn_000289/workspace/incoming/active/prairie_willow_0145_05.json
  dest: incoming/active/prairie_willow_0145_05.json
- source: task_syn_000289/workspace/incoming/active/prairie_willow_0145_06.json
  dest: incoming/active/prairie_willow_0145_06.json
- source: task_syn_000289/workspace/incoming/active/prairie_willow_0145_07.json
  dest: incoming/active/prairie_willow_0145_07.json
- source: task_syn_000289/workspace/incoming/archive/prairie_willow_0145_08.json
  dest: incoming/archive/prairie_willow_0145_08.json
capability_family: file_directory_operations
intended_difficulty_band: 4
base_scenario_id: scenario_000145
generator_seed: 740693
multi_session: false
---

## Prompt

You are working on synthetic task `task_syn_000289` for the `access cleanup` scenario `prairie-willow-0145`.
Use only the files supplied in the workspace. Do not fetch live data or use credentials.

Inspect the files under `incoming/active/` for the access cleanup workspace. Ignore everything under `incoming/archive/`. Select active files ending in `.json` whose byte length is at least 52, count active files by extension, and identify the largest active file.

Scenario-specific audit anchors: naguhad tujojoe cekiluf bawoyag zeceluh hacewoi habakij vemejok zegucel fojonam mefosan ricedio womeyap cekiluq kikilur zeyalus bafofot bafofou yawojov zeguguw havetux havediy tufodiz dihacea rifobab nanayac diriced ritudie bacetuf ridibag fokidih vehasai jonarij gutupok lukikil vedibam jorizen pogusao veveyap hacewoq cevepor kiwogus folugut havebau riporiv gukijow yanakix zeceriy nayaguz tuvenaa tuvemeb guhasac hasapod yawopoe nawojof focetug meriluh nawopoi pojonaj fobanak risavel zedirim worilun lukirio ceguvep bapowoq bapopor saribas yajodit vecesau zetutuv jogubaw pokitux bacebay lukipoz velubaa batusab fogufoc fovenad wosazee verimef sazemeg turiwoh wopotui wodiguj mediwok savekil tuwofom kikimen zezeguo kipokip naluhaq hapopor kihazes vegurit rifoyau.

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
EXPECTED_OUTPUT = {'result': {'target_extension': 'json', 'minimum_bytes': 52, 'selected_files': ['incoming/active/prairie_willow_0145_03.json', 'incoming/active/prairie_willow_0145_05.json', 'incoming/active/prairie_willow_0145_06.json', 'incoming/active/prairie_willow_0145_07.json'], 'active_extension_counts': {'cfg': 1, 'json': 4, 'md': 1}, 'largest_active_file': {'path': 'incoming/active/prairie_willow_0145_07.json', 'bytes': 175}}, 'evidence': ['incoming/active/prairie_willow_0145_01.md', 'incoming/active/prairie_willow_0145_02.cfg', 'incoming/active/prairie_willow_0145_03.json', 'incoming/active/prairie_willow_0145_05.json'], 'verification': {'checked_files': 9, 'ignored_archive': True, 'status': 'pass'}}

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
