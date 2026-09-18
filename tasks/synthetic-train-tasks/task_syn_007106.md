---
id: task_syn_007106
name: Active file manifest 007106
category: file_directory_operations
grading_type: hybrid
timeout_seconds: 150
workspace_files:
- source: task_syn_007106/workspace/incoming/archive/ripple_zenith_3553_00.md
  dest: incoming/archive/ripple_zenith_3553_00.md
- source: task_syn_007106/workspace/incoming/active/ripple_zenith_3553_01.txt
  dest: incoming/active/ripple_zenith_3553_01.txt
- source: task_syn_007106/workspace/incoming/active/ripple_zenith_3553_02.log
  dest: incoming/active/ripple_zenith_3553_02.log
- source: task_syn_007106/workspace/incoming/active/ripple_zenith_3553_03.log
  dest: incoming/active/ripple_zenith_3553_03.log
- source: task_syn_007106/workspace/incoming/archive/ripple_zenith_3553_04.json
  dest: incoming/archive/ripple_zenith_3553_04.json
- source: task_syn_007106/workspace/incoming/active/ripple_zenith_3553_05.md
  dest: incoming/active/ripple_zenith_3553_05.md
capability_family: file_directory_operations
intended_difficulty_band: 1
base_scenario_id: scenario_003553
generator_seed: 992922
multi_session: false
grading_weights:
  automated: 0.7
  llm_judge: 0.3
---

## Prompt

You are working on synthetic task `task_syn_007106` for the `release readiness` scenario `ripple-zenith-3553`.
Use only the files supplied in the workspace. Do not fetch live data or use credentials.

Inspect the files under `incoming/active/` for the release readiness workspace. Ignore everything under `incoming/archive/`. Select active files ending in `.log` whose byte length is at least 31, count active files by extension, and identify the largest active file.

Scenario-specific audit anchors: gucebai hapoyaj risatuk kinasal dibanam fodirin luyayao wogucep zebabaq kiwomer bamedis rikipot divekiu cedisav yamefow wolusax posazey gudimez nayamea dirisab poluwoc gupozed yasacee salurif meditug kivewoh cenatui luriluj mevedik yamezel dilusam joveyan mefoveo vewotup dimetuq popofor luveyas kikifot poyazeu jobasav poceriw veyalux lufocey nanariz joforia sakizeb najobac yamelud memeyae jorinaf kijorig dijotuh melunai batudij kipomek cesajol rimetum haluhan cefomeo mecelup menasaq wogujor zeveris kimenat foyadiu haripov zevekiw turikix fobajoy turidiz bameria joceyab jobahac poyamed pojohae cewohaf hafozeg najokih lututui yakidij metumek zerijol zejopom kicepon tulumeo hameyap nabaveq rivewor yaveyas yavelut napoyau gutuwov cebawow vecehax vefoguy rivecez.

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
EXPECTED_OUTPUT = {'result': {'target_extension': 'log', 'minimum_bytes': 31, 'selected_files': ['incoming/active/ripple_zenith_3553_02.log', 'incoming/active/ripple_zenith_3553_03.log'], 'active_extension_counts': {'log': 2, 'md': 1, 'txt': 1}, 'largest_active_file': {'path': 'incoming/active/ripple_zenith_3553_05.md', 'bytes': 142}}, 'evidence': ['incoming/active/ripple_zenith_3553_01.txt', 'incoming/active/ripple_zenith_3553_02.log', 'incoming/active/ripple_zenith_3553_03.log', 'incoming/active/ripple_zenith_3553_05.md'], 'verification': {'checked_files': 6, 'ignored_archive': True, 'status': 'pass'}}

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
