---
id: task_syn_007767
name: Captured source synthesis 007767
category: web_information_gathering_source_synthesis
grading_type: hybrid
timeout_seconds: 180
workspace_files:
- source: task_syn_007767/workspace/captured/page_a.md
  dest: captured/page_a.md
- source: task_syn_007767/workspace/captured/page_b.md
  dest: captured/page_b.md
- source: task_syn_007767/workspace/captured/page_c.md
  dest: captured/page_c.md
capability_family: web_information_gathering_source_synthesis
intended_difficulty_band: 2
base_scenario_id: scenario_003884
generator_seed: 1017379
multi_session: false
grading_weights:
  automated: 0.7
  llm_judge: 0.3
---

## Prompt

You are working on synthetic task `task_syn_007767` for the `policy review` scenario `keystone-brisk-3884`.
Use only the files supplied in the workspace. Do not fetch live data or use credentials.

Use the captured source files under `captured/`; do not fetch live pages. Select the metric value by preferring a reviewed source and using latest date only as a tie breaker. Report conflicting metric values and cite the selected file.

Scenario-specific audit anchors: mewobat mesayau tukimev ludiriw sajogux lupojoy zehatuz kibamea fonatub ricekic bayakid merihae dirisaf sajorig lupohah vetutui nafohaj nanabak divedil dituyam sajokin lututuo lutupop guriguq zejogur lubafos tuwocet cezehau havekiv rihadiw cesanax tulubay dimediz luzekia cemehab yaludic digukid mebalue wohamef meturig tuzewoh gudisai zefotuj sagudik yakifol wopobam rifopon nayaveo ponabap memehaq wonarir nakigus nalunat namezeu lujokiv tutumew tutujox basacey rihanaz johatua yameceb nanazec luzedid bawocee dinafof vejoyag ceyayah nahadii focejoj gufobak dipojol ponatum powoyan rifoveo poharip guwohaq gubamer wodidis babahat foceveu satuwov hadiguw gufosax dizeluy metupoz worigua jonahab gucesac sajolud memeyae vemebaf nafojog diluyah gupolui vewojoj nacerik.

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
- [ ] Judge review: Assess clarity, traceability, and whether the response avoids unsupported assumptions.

## Automated Checks

```python
from pathlib import Path
import json

CRITERIA = ['format_valid', 'answer_correct', 'evidence_grounded', 'verification_complete']
EXPECTED_OUTPUT = {'result': {'selected_metric_value': 39, 'selected_source': 'captured/page_b.md', 'selection_rule': 'prefer reviewed source, then latest date', 'conflicting_values': [32, 35]}, 'evidence': ['captured/page_b.md'], 'verification': {'checked_files': 3, 'live_network_used': False, 'status': 'pass'}}

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

Capability focus: `web_information_gathering_source_synthesis`.

## Additional Notes

All names, records, source pages, logs, and code fixtures in this task are synthetic. Do not infer a final model route or model tier from this metadata.
