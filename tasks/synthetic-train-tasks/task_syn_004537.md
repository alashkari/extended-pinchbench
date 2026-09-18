---
id: task_syn_004537
name: Active file manifest 004537
category: file_directory_operations
grading_type: hybrid
timeout_seconds: 180
workspace_files:
- source: task_syn_004537/workspace/incoming/archive/harbor_tundra_2269_00.cfg
  dest: incoming/archive/harbor_tundra_2269_00.cfg
- source: task_syn_004537/workspace/incoming/active/harbor_tundra_2269_01.txt
  dest: incoming/active/harbor_tundra_2269_01.txt
- source: task_syn_004537/workspace/incoming/active/harbor_tundra_2269_02.log
  dest: incoming/active/harbor_tundra_2269_02.log
- source: task_syn_004537/workspace/incoming/active/harbor_tundra_2269_03.json
  dest: incoming/active/harbor_tundra_2269_03.json
- source: task_syn_004537/workspace/incoming/archive/harbor_tundra_2269_04.cfg
  dest: incoming/archive/harbor_tundra_2269_04.cfg
- source: task_syn_004537/workspace/incoming/active/harbor_tundra_2269_05.json
  dest: incoming/active/harbor_tundra_2269_05.json
- source: task_syn_004537/workspace/incoming/active/harbor_tundra_2269_06.json
  dest: incoming/active/harbor_tundra_2269_06.json
- source: task_syn_004537/workspace/incoming/active/harbor_tundra_2269_07.txt
  dest: incoming/active/harbor_tundra_2269_07.txt
- source: task_syn_004537/workspace/incoming/archive/harbor_tundra_2269_08.txt
  dest: incoming/archive/harbor_tundra_2269_08.txt
capability_family: file_directory_operations
intended_difficulty_band: 2
base_scenario_id: scenario_002269
generator_seed: 897869
multi_session: false
grading_weights:
  automated: 0.7
  llm_judge: 0.3
---

## Prompt

You are working on synthetic task `task_syn_004537` for the `billing review` scenario `harbor-tundra-2269`.
Use only the files supplied in the workspace. Do not fetch live data or use credentials.

Inspect the files under `incoming/active/` for the billing review workspace. Ignore everything under `incoming/archive/`. Select active files ending in `.cfg` whose byte length is at least 38, count active files by extension, and identify the largest active file.

Scenario-specific audit anchors: saluban sayameo folugup cevebaq lunafor pozehas luvezet cezediu nazediv babacew naguhax nasapoy kiripoz memegua lufokib habaric johahad satupoe riricef tuguwog vegunah yanayai guzeluj wocesak cenadil cememem mebapon kipohao yaguyap tunayaq dimetur hametus tufowot fodinau disasav polujow jofoyax vemenay savejoz joguria hamezeb cebaluc zekirid bacejoe wopobaf rihakig guzesah hayasai cemekij vesanak kisaril kiwozem gubalun yalupoo gusasap fomeguq dipozer bajosas zesahat didinau hajoluv wobariw riwolux zebadiy venabaz harimea tuvelub ceharic vevejod risarie poforif cebafog saharih cerigui cegujoj fovedik vesayal potusam kijowon lufoluo kizepop gukihaq veriwor hafozes riwohat hadiceu kivemev babaguw saworix woluriy podiyaz gujomea kicetub mecejoc fopoced cebalue.

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
- [ ] Judge review: Assess clarity, traceability, and whether the response avoids unsupported assumptions.

## Automated Checks

```python
from pathlib import Path
import json

CRITERIA = ['format_valid', 'answer_correct', 'evidence_grounded', 'verification_complete']
EXPECTED_OUTPUT = {'result': {'target_extension': 'cfg', 'minimum_bytes': 38, 'selected_files': [], 'active_extension_counts': {'json': 3, 'log': 1, 'txt': 2}, 'largest_active_file': {'path': 'incoming/active/harbor_tundra_2269_07.txt', 'bytes': 160}}, 'evidence': ['incoming/active/harbor_tundra_2269_01.txt', 'incoming/active/harbor_tundra_2269_02.log', 'incoming/active/harbor_tundra_2269_03.json', 'incoming/active/harbor_tundra_2269_05.json'], 'verification': {'checked_files': 9, 'ignored_archive': True, 'status': 'pass'}}

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

Capability focus: `file_directory_operations`.

## Additional Notes

All names, records, source pages, logs, and code fixtures in this task are synthetic. Do not infer a final model route or model tier from this metadata.
