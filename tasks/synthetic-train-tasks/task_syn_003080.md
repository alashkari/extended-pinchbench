---
id: task_syn_003080
name: Briefing extraction 003080
category: unstructured_document_analysis
grading_type: automated
timeout_seconds: 270
workspace_files:
- source: task_syn_003080/workspace/notes/briefing.md
  dest: notes/briefing.md
capability_family: unstructured_document_analysis
intended_difficulty_band: 5
base_scenario_id: scenario_001540
generator_seed: 843960
multi_session: true
---

## Prompt

You are working on synthetic task `task_syn_003080` for the `vendor intake` scenario `glade-frost-1540`.
Use only the files supplied in the workspace. Do not fetch live data or use credentials.

Read `notes/briefing.md` and extract action items, risk counts, high-risk topics, and decisions. Do not include ordinary notes or unrelated agenda material. Treat `[accion]` as an action and `[risgo]` as a risk despite the shorthand spelling.

Scenario-specific audit anchors: navetum cevekin yacebao vevegup tusadiq yahadir natusas bavetut tubakiu jocemev ricewow veribax kiyaluy fowobaz fomebaa fomelub celuvec woyaced bamesae yasafof cemefog mejoluh yapobai tuveyaj zeworik jomegul yawopom lumesan zeriveo hafopop pozeluq yajocer sayafos wocewot bapoveu bakihav nakimew rimecex bagucey jorivez nawoyaa sadifob nayawoc safoced wonalue poluluf saridig jojosah lulufoi kibafoj vewotuk fovewol dilukim cejonan sakimeo rihasap cezehaq bamezer rijotus kinagut mewonau memevev cepotuw memejox naguriy pogudiz dinayaa turizeb tubakic tuyazed haluhae kinazef dilumeg tutubah yazemei wotuhaj yakisak rijodil wobatum yajoban yahakio gufopop kibaceq cenagur gupolus rivegut zecekiu nahawov vebafow havedix vecediy yavekiz safonaa balukib zesajoc josapod.

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
If a malformed row, impossible dependency, or unusable entry appears, skip it and report the skip count instead of failing.
Some supplied information is intentionally irrelevant; exclude it from the result.
Some records mix English with romanized Japanese tags such as kakunin and shuryo; keep the output values deterministic.
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
EXPECTED_OUTPUT = {'result': {'actions': [{'owner': 'eli', 'due': 'day-1', 'item': 'verify batch 0'}, {'owner': 'bea', 'due': 'day-4', 'item': 'verify batch 3'}, {'owner': 'eli', 'due': 'day-2', 'item': 'verify batch 6'}, {'owner': 'bea', 'due': 'day-5', 'item': 'verify batch 9'}], 'risk_count': 3, 'high_risk_topics': ['lane 1', 'lane 7'], 'decisions': ['use checksum window 4', 'use checksum window 7', 'use checksum window 10']}, 'evidence': ['notes/briefing.md'], 'verification': {'checked_files': 1, 'ignored_distractors': True, 'status': 'pass'}}

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
