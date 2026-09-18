---
id: task_syn_001096
name: Captured source synthesis 001096
category: web_information_gathering_source_synthesis
grading_type: automated
timeout_seconds: 150
workspace_files:
- source: task_syn_001096/workspace/captured/page_a.md
  dest: captured/page_a.md
- source: task_syn_001096/workspace/captured/page_b.md
  dest: captured/page_b.md
- source: task_syn_001096/workspace/captured/page_c.md
  dest: captured/page_c.md
capability_family: web_information_gathering_source_synthesis
intended_difficulty_band: 1
base_scenario_id: scenario_000548
generator_seed: 770552
multi_session: true
---

## Prompt

You are working on synthetic task `task_syn_001096` for the `vendor intake` scenario `cedar-ion-0548`.
Use only the files supplied in the workspace. Do not fetch live data or use credentials.

Use the captured source files under `captured/`; do not fetch live pages. Select the metric value by preferring a reviewed source and using latest date only as a tie breaker. Report conflicting metric values and cite the selected file.

Scenario-specific audit anchors: jomenae meveluf memetug ripobah dihayai rigukij hagufok sajocel nadidim woporin fozenao hahabap baposaq mekizer dicelus wovevet posapou cesawov cenajow worisax rijocey turinaz zewobaa sabafob cedisac havebad meyavee mesarif guwofog kibatuh diwovei riyajoj foluyak zehagul folubam hatuven yavenao satucep tuyabaq kizemer mevelus jojolut rizezeu hanadiv fomeyaw posafox polusay gunasaz wozegua hawokib poribac yahatud kidipoe fovekif kimepog mebajoh dipokii yacejoj vecedik dijomel nabamem kijomen sagunao vejokip kidijoq dikizer zekidis bamecet foyahau nayavev tuhajow yalufox potukiy lumecez popojoa wobatub foceluc joyawod vefozee saluzef kiyayag tumebah luluhai gusavej yacesak mehamel nagusam nanasan mehakio mekigup zepojoq ripojor zebawos cefobat rijoceu woriyav.

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
Before finishing, verify that the output agrees with the relevant fixture files and record the check in `verification`.
Some source notes include French words such as priorite, preuve, and etape; keep the output schema in English.
This task may require continuing context across multiple session files.

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
EXPECTED_OUTPUT = {'result': {'selected_metric_value': 32, 'selected_source': 'captured/page_b.md', 'selection_rule': 'prefer reviewed source, then latest date', 'conflicting_values': [25, 28]}, 'evidence': ['captured/page_b.md'], 'verification': {'checked_files': 3, 'live_network_used': False, 'status': 'pass'}}

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
