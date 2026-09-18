---
id: task_syn_000194
name: Active file manifest 000194
category: file_directory_operations
grading_type: automated
timeout_seconds: 240
workspace_files:
- source: task_syn_000194/workspace/incoming/archive/tundra_keystone_0097_00.cfg
  dest: incoming/archive/tundra_keystone_0097_00.cfg
- source: task_syn_000194/workspace/incoming/active/tundra_keystone_0097_01.txt
  dest: incoming/active/tundra_keystone_0097_01.txt
- source: task_syn_000194/workspace/incoming/active/tundra_keystone_0097_02.cfg
  dest: incoming/active/tundra_keystone_0097_02.cfg
- source: task_syn_000194/workspace/incoming/active/tundra_keystone_0097_03.cfg
  dest: incoming/active/tundra_keystone_0097_03.cfg
- source: task_syn_000194/workspace/incoming/archive/tundra_keystone_0097_04.json
  dest: incoming/archive/tundra_keystone_0097_04.json
- source: task_syn_000194/workspace/incoming/active/tundra_keystone_0097_05.txt
  dest: incoming/active/tundra_keystone_0097_05.txt
- source: task_syn_000194/workspace/incoming/active/tundra_keystone_0097_06.log
  dest: incoming/active/tundra_keystone_0097_06.log
- source: task_syn_000194/workspace/incoming/active/tundra_keystone_0097_07.cfg
  dest: incoming/active/tundra_keystone_0097_07.cfg
- source: task_syn_000194/workspace/incoming/archive/tundra_keystone_0097_08.json
  dest: incoming/archive/tundra_keystone_0097_08.json
- source: task_syn_000194/workspace/incoming/active/tundra_keystone_0097_09.json
  dest: incoming/active/tundra_keystone_0097_09.json
- source: task_syn_000194/workspace/incoming/active/tundra_keystone_0097_10.txt
  dest: incoming/active/tundra_keystone_0097_10.txt
capability_family: file_directory_operations
intended_difficulty_band: 4
base_scenario_id: scenario_000097
generator_seed: 737178
multi_session: false
---

## Prompt

You are working on synthetic task `task_syn_000194` for the `access cleanup` scenario `tundra-keystone-0097`.
Use only the files supplied in the workspace. Do not fetch live data or use credentials.

Inspect the files under `incoming/active/` for the access cleanup workspace. Ignore everything under `incoming/archive/`. Select active files ending in `.json` whose byte length is at least 52, count active files by extension, and identify the largest active file.

Scenario-specific audit anchors: hapozem foripon tuvejoo ceyanap fobatuq zebapor vecekis hadikit hawosau dimesav haririw tudimex zewojoy naluhaz kirifoa cewogub jometuc cejolud gufobae foturif hasaveg focekih cebawoi fozenaj barimek wogusal riyafom kikirin napodio zelutup wowoveq disayar tusazes bajobat yasawou gurihav forihaw sagutux gusawoy bameluz gujoyaa kibagub bazesac rimezed basapoe jonazef zeverig dirikih tukinai luwoluj yakiguk kihalul mejokim saguhan cericeo didihap saposaq hananar veyaces lujocet cejoyau hafowov guhahaw wozehax venahay gupocez diwosaa kikimeb gunadic kimeyad sayazee mececef bawofog vececeh hawocei yamebaj zedivek bamemel naturim zezegun mehaveo menabap wokiceq didiyar celutus polubat baripou rivebav kituwow poyamex celupoy yajomez rikivea lurizeb lubajoc cevemed.

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
EXPECTED_OUTPUT = {'result': {'target_extension': 'json', 'minimum_bytes': 52, 'selected_files': ['incoming/active/tundra_keystone_0097_09.json'], 'active_extension_counts': {'cfg': 3, 'json': 1, 'log': 1, 'txt': 3}, 'largest_active_file': {'path': 'incoming/active/tundra_keystone_0097_10.txt', 'bytes': 200}}, 'evidence': ['incoming/active/tundra_keystone_0097_01.txt', 'incoming/active/tundra_keystone_0097_02.cfg', 'incoming/active/tundra_keystone_0097_03.cfg', 'incoming/active/tundra_keystone_0097_05.txt'], 'verification': {'checked_files': 11, 'ignored_archive': True, 'status': 'pass'}}

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
