---
id: task_syn_001803
name: Structured table normalization 001803
category: structured_data_transformation
grading_type: automated
timeout_seconds: 210
workspace_files:
- source: task_syn_001803/workspace/tables/source_records.csv
  dest: tables/source_records.csv
- source: task_syn_001803/workspace/tables/region_map.json
  dest: tables/region_map.json
capability_family: structured_data_transformation
intended_difficulty_band: 3
base_scenario_id: scenario_000902
generator_seed: 796711
multi_session: false
---

## Prompt

You are working on synthetic task `task_syn_001803` for the `access cleanup` scenario `summit-zenith-0902`.
Use only the files supplied in the workspace. Do not fetch live data or use credentials.

Transform `tables/source_records.csv` using `tables/region_map.json`. Keep only active rows with `units * unit_cost >= 119`, uppercase each id, map regions to zones, sort by zone then id, and report how many malformed rows were skipped.

Scenario-specific audit anchors: fovesaj zemecek joturil zekipom mesarin bahadio powotup cetuguq kiwopor ribanas rizemet hayariu zebamev cetubaw kigufox lucediy povehaz sadimea zemedib diguguc poritud lupozee yayajof natuwog gutuhah mewowoi sasaluj sayahak rimecel tulunam nacecen zenahao banacep sawofoq cemecer cefopos jozejot wovekiu wozefov zedizew poriyax tuludiy tukibaz luluwoa satunab nahafoc fomeced tulunae gujoguf pofodig cedisah kimeyai wokifoj guwoguk porinal pozevem yapomen dirikio fopoyap wokipoq sadihar nacetus joyayat sakidiu turihav lunaguw venacex kiwokiy ponajoz kinasaa diritub yaceric foyapod wohavee gurifof tufowog foceluh luyahai yamesaj hahayak nadikil medinam cezepon yahameo zegupop riguriq hajozer tupomes cenahat gumesau luvenav lujotuw tuhadix dihasay kijotuz rimepoa.

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
EXPECTED_OUTPUT = {'result': {'threshold': 119, 'records': [{'id': 'SUM-004', 'zone': 'zone_2', 'total_value': 360}, {'id': 'SUM-001', 'zone': 'zone_4', 'total_value': 120}, {'id': 'SUM-002', 'zone': 'zone_5', 'total_value': 279}, {'id': 'SUM-007', 'zone': 'zone_5', 'total_value': 196}], 'total_value': 955, 'malformed_rows_skipped': 0}, 'evidence': ['tables/source_records.csv', 'tables/region_map.json'], 'verification': {'checked_files': 2, 'malformed_rows_skipped': 0, 'status': 'pass'}}

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
