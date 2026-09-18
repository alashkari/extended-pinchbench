---
id: task_syn_006650
name: Active file manifest 006650
category: file_directory_operations
grading_type: automated
timeout_seconds: 270
workspace_files:
- source: task_syn_006650/workspace/incoming/archive/xenial_brisk_3325_00.cfg
  dest: incoming/archive/xenial_brisk_3325_00.cfg
- source: task_syn_006650/workspace/incoming/active/xenial_brisk_3325_01.md
  dest: incoming/active/xenial_brisk_3325_01.md
- source: task_syn_006650/workspace/incoming/active/xenial_brisk_3325_02.txt
  dest: incoming/active/xenial_brisk_3325_02.txt
- source: task_syn_006650/workspace/incoming/active/xenial_brisk_3325_03.cfg
  dest: incoming/active/xenial_brisk_3325_03.cfg
- source: task_syn_006650/workspace/incoming/archive/xenial_brisk_3325_04.md
  dest: incoming/archive/xenial_brisk_3325_04.md
- source: task_syn_006650/workspace/incoming/active/xenial_brisk_3325_05.md
  dest: incoming/active/xenial_brisk_3325_05.md
- source: task_syn_006650/workspace/incoming/active/xenial_brisk_3325_06.md
  dest: incoming/active/xenial_brisk_3325_06.md
- source: task_syn_006650/workspace/incoming/active/xenial_brisk_3325_07.log
  dest: incoming/active/xenial_brisk_3325_07.log
- source: task_syn_006650/workspace/incoming/archive/xenial_brisk_3325_08.log
  dest: incoming/archive/xenial_brisk_3325_08.log
- source: task_syn_006650/workspace/incoming/active/xenial_brisk_3325_09.md
  dest: incoming/active/xenial_brisk_3325_09.md
- source: task_syn_006650/workspace/incoming/active/xenial_brisk_3325_10.json
  dest: incoming/active/xenial_brisk_3325_10.json
- source: task_syn_006650/workspace/incoming/active/xenial_brisk_3325_11.log
  dest: incoming/active/xenial_brisk_3325_11.log
- source: task_syn_006650/workspace/incoming/archive/distractor_006650.txt
  dest: incoming/archive/distractor_006650.txt
capability_family: file_directory_operations
intended_difficulty_band: 5
base_scenario_id: scenario_003325
generator_seed: 976050
multi_session: false
---

## Prompt

You are working on synthetic task `task_syn_006650` for the `knowledge-base upkeep` scenario `xenial-brisk-3325`.
Use only the files supplied in the workspace. Do not fetch live data or use credentials.

Inspect the files under `incoming/active/` for the knowledge-base upkeep workspace. Ignore everything under `incoming/archive/`. Select active files ending in `.txt` whose byte length is at least 59, count active files by extension, and identify the largest active file.

Scenario-specific audit anchors: foluguu yawozev ribazew bahagux didinay sayafoz wojomea bazeceb sawoluc nawojod jofocee tuvewof mepoyag tujozeh haporii basazej salucek kivewol johazem diritun vecewoo womehap gubanaq cekisar lutusas johayat kihatuu pofomev ceyariw bamemex foluguy dibakiz lucedia cebalub vecemec hahafod sahavee tufoyaf ceguzeg porimeh jomehai vezesaj celukik bajomel diposam tuwoban hagupoo badigup lugutuq sayalur vevelus wotutut nahaveu sayamev wobafow fokivex yavepoy kiyabaz babaria hagunab cedicec kiluwod vefomee povefof yaworig fowoyah didimei zenazej jozefok tukihal wotulum cenayan yatujoo cekitup yasayaq dicezer medibas fokizet rihaluu cevenav rihabaw tuwovex sahazey diwoyaz hadizea zenajob baveguc najokid dipozee sanaluf dipopog fonaguh tuporii wobabaj bacefok tufopol.

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

## Automated Checks

```python
from pathlib import Path
import json

CRITERIA = ['format_valid', 'answer_correct', 'evidence_grounded', 'verification_complete']
EXPECTED_OUTPUT = {'result': {'target_extension': 'txt', 'minimum_bytes': 59, 'selected_files': ['incoming/active/xenial_brisk_3325_02.txt'], 'active_extension_counts': {'cfg': 1, 'json': 1, 'log': 2, 'md': 4, 'txt': 1}, 'largest_active_file': {'path': 'incoming/active/xenial_brisk_3325_11.log', 'bytes': 216}}, 'evidence': ['incoming/active/xenial_brisk_3325_01.md', 'incoming/active/xenial_brisk_3325_02.txt', 'incoming/active/xenial_brisk_3325_03.cfg', 'incoming/active/xenial_brisk_3325_05.md'], 'verification': {'checked_files': 13, 'ignored_archive': True, 'status': 'pass'}}

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
