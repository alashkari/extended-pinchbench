---
id: task_syn_001987
name: Professional update transformation 001987
category: professional_communication_content_transformation
grading_type: automated
timeout_seconds: 180
workspace_files:
- source: task_syn_001987/workspace/drafting/raw_notes.md
  dest: drafting/raw_notes.md
capability_family: professional_communication_content_transformation
intended_difficulty_band: 2
base_scenario_id: scenario_000994
generator_seed: 803519
multi_session: false
---

## Prompt

You are working on synthetic task `task_syn_001987` for the `inventory audit` scenario `glade-delta-0994`.
Use only the files supplied in the workspace. Do not fetch live data or use credentials.

Turn `drafting/raw_notes.md` into a professional update plan. Capture a concise subject, required points, excluded distractors, and the intended tone. Do not invent commitments not present in the notes.

Scenario-specific audit anchors: sasamel wocejom ripoyan tubahao meyanap ceyariq bagufor rikidis riritut ceyapou mekimev woyavew megucex lusamey wofonaz fotugua ceguyab tukikic lujoced luhalue basafof fohaceg dikijoh rijolui sarifoj gunawok tunapol wohajom kipotun gudijoo jowokip wokikiq yabapor dirinas tuyazet poveceu bavefov wohamew tupotux nadikiy hapojoz wohahaa diyalub fovevec bapodid pocemee fogukif vekiveg samedih zejovei luwofoj metunak jorizel woforim luditun tuposao yayadip yajodiq difolur barigus haricet dizefou lululuv gudiyaw wofogux hawofoy kikisaz tubamea riguceb zesacec nahabad mekimee riririf pocehag mecewoh riwogui megurij woyatuk haribal ceyavem natuwon turiluo gumelup basasaq wosasar tusabas yamemet yavefou cehariv dihaguw cezefox zeceguy zelujoz porijoa melukib bayapoc.

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
EXPECTED_OUTPUT = {'result': {'subject': 'Update on glade-delta-0994 inventory audit', 'required_points': ['customer impact window 2 closes on day-4', 'owner lumen must confirm the checklist', 'risk level normal'], 'excluded_points': [], 'tone': 'professional_concise'}, 'evidence': ['drafting/raw_notes.md'], 'verification': {'checked_files': 1, 'invented_points': 0, 'status': 'pass'}}

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
