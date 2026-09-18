---
id: task_syn_006313
name: Active file manifest 006313
category: file_directory_operations
grading_type: llm_judge
timeout_seconds: 210
workspace_files:
- source: task_syn_006313/workspace/incoming/archive/lumen_ion_3157_00.json
  dest: incoming/archive/lumen_ion_3157_00.json
- source: task_syn_006313/workspace/incoming/active/lumen_ion_3157_01.json
  dest: incoming/active/lumen_ion_3157_01.json
- source: task_syn_006313/workspace/incoming/active/lumen_ion_3157_02.log
  dest: incoming/active/lumen_ion_3157_02.log
- source: task_syn_006313/workspace/incoming/active/lumen_ion_3157_03.log
  dest: incoming/active/lumen_ion_3157_03.log
- source: task_syn_006313/workspace/incoming/archive/lumen_ion_3157_04.json
  dest: incoming/archive/lumen_ion_3157_04.json
- source: task_syn_006313/workspace/incoming/active/lumen_ion_3157_05.json
  dest: incoming/active/lumen_ion_3157_05.json
- source: task_syn_006313/workspace/incoming/active/lumen_ion_3157_06.json
  dest: incoming/active/lumen_ion_3157_06.json
- source: task_syn_006313/workspace/incoming/active/lumen_ion_3157_07.log
  dest: incoming/active/lumen_ion_3157_07.log
capability_family: file_directory_operations
intended_difficulty_band: 3
base_scenario_id: scenario_003157
generator_seed: 963581
multi_session: false
---

## Prompt

You are working on synthetic task `task_syn_006313` for the `customer migration` scenario `lumen-ion-3157`.
Use only the files supplied in the workspace. Do not fetch live data or use credentials.

Inspect the files under `incoming/active/` for the customer migration workspace. Ignore everything under `incoming/archive/`. Select active files ending in `.md` whose byte length is at least 45, count active files by extension, and identify the largest active file.

Scenario-specific audit anchors: tugucev ririfow pokibax rijosay napofoz fowowoa vebasab wolukic velupod tusanae kiludif ririceg mebabah josalui riwozej vepopok kiditul vesalum fomepon povefoo poceyap josasaq gujopor nanalus napowot jomesau kicewov navezew cerihax bakimey riluyaz womejoa tuveceb gusasac mewoced sanalue cekituf sadipog luguzeh gubarii dinajoj melufok fobanal poyazem sametun wotuceo kinavep cesasaq tuvelur pomehas worivet bavejou jokikiv tumefow kiguzex gufofoy cegupoz diguwoa diriyab nanahac vemehad rifobae sahanaf yanapog foyanah kiludii yasadij sanahak vezedil velugum yariban ritusao yabazep mewozeq vedikir bavehas dinanat bariluu banawov ceyabaw basatux zedipoy kimepoz yawowoa yayameb dibayac yamekid harisae cericef zemegug hayawoh wocedii johamej cemejok tugukil navemem.

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

- [ ] factual_grounding: Uses only supplied fixture information.
- [ ] completeness: Covers every requested operation and constraint.
- [ ] clarity: Presents a concise artifact in the requested format.
- [ ] caution: Avoids invented facts, live-data claims, and unavailable-tool assumptions.

## Automated Checks

Not applicable; this candidate is scored by judge rubric only.

## LLM Judge Rubric

Judge the submitted artifact using the criteria below. Award credit only for content grounded in the supplied workspace files.

- 1.0: Complete, accurate, well organized, and explicit about evidence and verification.
- 0.7: Mostly correct with a minor omission or weak explanation that does not change the core result.
- 0.4: Partially grounded but misses an important constraint, source, or edge case.
- 0.0: Ungrounded, unusable, unsafe, or dependent on unavailable external data.

Capability focus: `file_directory_operations`.

## Additional Notes

All names, records, source pages, logs, and code fixtures in this task are synthetic. Do not infer a final model route or model tier from this metadata.
