---
id: task_syn_007561
name: Active file manifest 007561
category: file_directory_operations
grading_type: automated
timeout_seconds: 150
workspace_files:
- source: task_syn_007561/workspace/incoming/archive/lumen_harbor_3781_00.txt
  dest: incoming/archive/lumen_harbor_3781_00.txt
- source: task_syn_007561/workspace/incoming/active/lumen_harbor_3781_01.md
  dest: incoming/active/lumen_harbor_3781_01.md
- source: task_syn_007561/workspace/incoming/active/lumen_harbor_3781_02.json
  dest: incoming/active/lumen_harbor_3781_02.json
- source: task_syn_007561/workspace/incoming/active/lumen_harbor_3781_03.txt
  dest: incoming/active/lumen_harbor_3781_03.txt
- source: task_syn_007561/workspace/incoming/archive/lumen_harbor_3781_04.json
  dest: incoming/archive/lumen_harbor_3781_04.json
- source: task_syn_007561/workspace/incoming/active/lumen_harbor_3781_05.txt
  dest: incoming/active/lumen_harbor_3781_05.txt
capability_family: file_directory_operations
intended_difficulty_band: 1
base_scenario_id: scenario_003781
generator_seed: 1009757
multi_session: false
---

## Prompt

You are working on synthetic task `task_syn_007561` for the `release readiness` scenario `lumen-harbor-3781`.
Use only the files supplied in the workspace. Do not fetch live data or use credentials.

Inspect the files under `incoming/active/` for the release readiness workspace. Ignore everything under `incoming/archive/`. Select active files ending in `.log` whose byte length is at least 31, count active files by extension, and identify the largest active file.

Scenario-specific audit anchors: pocehav jotuwow riwopox guyazey zevesaz gunabaa wozegub luworic vebapod dihanae namebaf focemeg hakisah mesamei bayayaj diceluk fojobal bahagum wogucen bacetuo gupogup jokiguq hayasar posafos ludilut jojoguu ponasav hatuguw folucex nafopoy rigujoz dinatua cepoceb womeluc vediwod guyanae sakinaf jofoyag cezefoh folumei tugukij tucesak meturil pokilum veridin woceyao yanacep navebaq yajoyar tulunas risasat fofobau sahariv cezehaw gutumex najovey jomejoz haharia yaluyab guzecec dihafod pobague gulusaf gugurig gulujoh zecezei tusaguj naluluk tuzehal fodidim wohayan bavebao tukisap zesayaq vetuwor jorifos fosagut mefowou zetuluv mejocew kitumex hazeriy tumeriz baposaa nadikib jowozec lumejod tudigue najonaf fozegug fonajoh tuhazei disanaj nahaguk dimelul zepowom.

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
EXPECTED_OUTPUT = {'result': {'target_extension': 'log', 'minimum_bytes': 31, 'selected_files': [], 'active_extension_counts': {'json': 1, 'md': 1, 'txt': 2}, 'largest_active_file': {'path': 'incoming/active/lumen_harbor_3781_05.txt', 'bytes': 141}}, 'evidence': ['incoming/active/lumen_harbor_3781_01.md', 'incoming/active/lumen_harbor_3781_02.json', 'incoming/active/lumen_harbor_3781_03.txt', 'incoming/active/lumen_harbor_3781_05.txt'], 'verification': {'checked_files': 6, 'ignored_archive': True, 'status': 'pass'}}

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
