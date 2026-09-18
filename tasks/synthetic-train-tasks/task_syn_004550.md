---
id: task_syn_004550
name: Mini repository maintenance scan 004550
category: repository_navigation_software_maintenance
grading_type: hybrid
timeout_seconds: 270
workspace_files:
- source: task_syn_004550/workspace/repo/config/modules.json
  dest: repo/config/modules.json
- source: task_syn_004550/workspace/repo/src/ingest.py
  dest: repo/src/ingest.py
- source: task_syn_004550/workspace/repo/src/export.py
  dest: repo/src/export.py
- source: task_syn_004550/workspace/repo/src/audit.py
  dest: repo/src/audit.py
- source: task_syn_004550/workspace/repo/src/notify.py
  dest: repo/src/notify.py
- source: task_syn_004550/workspace/repo/src/cleanup.py
  dest: repo/src/cleanup.py
- source: task_syn_004550/workspace/repo/docs/changelog.md
  dest: repo/docs/changelog.md
capability_family: repository_navigation_software_maintenance
intended_difficulty_band: 5
base_scenario_id: scenario_002275
generator_seed: 898350
multi_session: false
grading_weights:
  automated: 0.7
  llm_judge: 0.3
---

## Prompt

You are working on synthetic task `task_syn_004550` for the `inventory audit` scenario `nimbus-onyx-2275`.
Use only the files supplied in the workspace. Do not fetch live data or use credentials.

Inspect the mini repository under `repo/`. Create a maintenance report with enabled modules, deprecated modules, TODO markers with their module names, and any enabled module whose source file is missing.

Scenario-specific audit anchors: riwosaa haveceb disaric dipogud pobazee kiyasaf hakiwog pomenah turikii hamecej zedikik yasayal sapofom tulutun nadifoo turicep samefoq bafogur rifosas yavegut yabawou wokijov guwopow nanasax nahayay zeriguz jolufoa zejogub nafonac yaposad tukirie guzejof divemeg bafotuh sakilui nahasaj ricejok baripol pohajom lucejon pobaluo sasarip veyakiq dibanar wocejos lufojot kinaveu bamehav cebazew diwovex dinavey mesasaz foluria gunahab mewowoc jonagud forinae sayacef yafozeg zerinah ponatui meluguj kipofok jojobal hamebam babapon mezefoo gusafop cebadiq nacetur powopos gubacet cerihau nayatuv memediw sanarix merituy ceyahaz yavecea gufofob verijoc sameced fonacee meriyaf dipotug gucehah mewozei pomekij podifok kibanal cejomem zecejon johapoo fomehap kituyaq mevefor.

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
- [ ] Judge review: Assess clarity, traceability, and whether the response avoids unsupported assumptions.

## Automated Checks

```python
from pathlib import Path
import json

CRITERIA = ['format_valid', 'answer_correct', 'evidence_grounded', 'verification_complete']
EXPECTED_OUTPUT = {'result': {'enabled_modules': ['ingest', 'export', 'audit', 'notify', 'cleanup'], 'deprecated_modules': ['cleanup'], 'todo_items': [{'module': 'ingest', 'todo': '4550-0'}, {'module': 'audit', 'todo': '4550-2'}, {'module': 'cleanup', 'todo': '4550-4'}], 'missing_enabled_files': []}, 'evidence': ['repo/config/modules.json', 'repo/src'], 'verification': {'checked_files': 7, 'status': 'pass'}}

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

Judge the submitted artifact using the criteria below. Award credit only for content grounded in the supplied workspace files.

- 1.0: Complete, accurate, well organized, and explicit about evidence and verification.
- 0.7: Mostly correct with a minor omission or weak explanation that does not change the core result.
- 0.4: Partially grounded but misses an important constraint, source, or edge case.
- 0.0: Ungrounded, unusable, unsafe, or dependent on unavailable external data.

Capability focus: `repository_navigation_software_maintenance`.

## Additional Notes

All names, records, source pages, logs, and code fixtures in this task are synthetic. Do not infer a final model route or model tier from this metadata.
