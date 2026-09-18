---
id: task_syn_007583
name: Multi-artifact triage plan 007583
category: multi_tool_workflow_orchestration
grading_type: automated
timeout_seconds: 210
workspace_files:
- source: task_syn_007583/workspace/triage/tickets.csv
  dest: triage/tickets.csv
- source: task_syn_007583/workspace/triage/scoring.json
  dest: triage/scoring.json
- source: task_syn_007583/workspace/triage/events.log
  dest: triage/events.log
capability_family: multi_tool_workflow_orchestration
intended_difficulty_band: 3
base_scenario_id: scenario_003792
generator_seed: 1010571
multi_session: false
---

## Prompt

You are working on synthetic task `task_syn_007583` for the `billing review` scenario `willow-willow-3792`.
Use only the files supplied in the workspace. Do not fetch live data or use credentials.

Combine `triage/tickets.csv`, `triage/scoring.json`, and `triage/events.log` into a priority plan. Apply severity multipliers, subtract one point for blocked tickets, skip malformed event lines, and sort by score descending then ticket id.

Scenario-specific audit anchors: fowolur nameves wojorit wosaguu yanaguv nafozew dijolux luceyay wolumez sasagua gutuyab dirizec bakidid lusarie hatuzef gujolug menahah safolui mehafoj bayanak focegul cesawom nanapon tusawoo zetutup foluguq vevenar badizes pofolut pozeveu bamejov riwoyaw mecebax yananay gugujoz tuvefoa riyapob ceguyac lukikid lufobae dimezef guwopog vesapoh zelului tunadij memesak vemeyal nakiyam nawosan johameo sacesap hasaguq vegugur guguces woyabat tumemeu yanazev turijow kizewox bawodiy vevewoz cepocea cevedib tunamec zemewod ripohae ripozef guveveg tunatuh hatujoi yazejoj joposak yadihal dicedim wovecen yawosao ridihap kisapoq kihakir kifokis pohapot yadijou wopoluv mewozew focedix yahaluy jogufoz cewonaa harizeb hapobac zesazed mewodie merikif dirinag mecerih sapogui.

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
EXPECTED_OUTPUT = {'result': {'priority_order': [{'ticket': 'T007583-2', 'owner': 'cam', 'priority_score': 3}, {'ticket': 'T007583-5', 'owner': 'bea', 'priority_score': 3}, {'ticket': 'T007583-1', 'owner': 'bea', 'priority_score': 2}, {'ticket': 'T007583-3', 'owner': 'dev', 'priority_score': 1}, {'ticket': 'T007583-4', 'owner': 'ari', 'priority_score': 1}, {'ticket': 'T007583-6', 'owner': 'cam', 'priority_score': 1}, {'ticket': 'T007583-0', 'owner': 'ari', 'priority_score': 0}], 'blocked_tickets': ['T007583-0', 'T007583-4'], 'malformed_events_skipped': 0}, 'evidence': ['triage/tickets.csv', 'triage/scoring.json', 'triage/events.log'], 'verification': {'checked_files': 3, 'status': 'pass'}}

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
