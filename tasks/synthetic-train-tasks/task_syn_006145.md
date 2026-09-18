---
id: task_syn_006145
name: Active file manifest 006145
category: file_directory_operations
grading_type: llm_judge
timeout_seconds: 270
workspace_files:
- source: task_syn_006145/workspace/incoming/archive/frost_onyx_3073_00.txt
  dest: incoming/archive/frost_onyx_3073_00.txt
- source: task_syn_006145/workspace/incoming/active/frost_onyx_3073_01.md
  dest: incoming/active/frost_onyx_3073_01.md
- source: task_syn_006145/workspace/incoming/active/frost_onyx_3073_02.log
  dest: incoming/active/frost_onyx_3073_02.log
- source: task_syn_006145/workspace/incoming/active/frost_onyx_3073_03.json
  dest: incoming/active/frost_onyx_3073_03.json
- source: task_syn_006145/workspace/incoming/archive/frost_onyx_3073_04.log
  dest: incoming/archive/frost_onyx_3073_04.log
- source: task_syn_006145/workspace/incoming/active/frost_onyx_3073_05.json
  dest: incoming/active/frost_onyx_3073_05.json
- source: task_syn_006145/workspace/incoming/active/frost_onyx_3073_06.json
  dest: incoming/active/frost_onyx_3073_06.json
- source: task_syn_006145/workspace/incoming/active/frost_onyx_3073_07.md
  dest: incoming/active/frost_onyx_3073_07.md
- source: task_syn_006145/workspace/incoming/archive/frost_onyx_3073_08.txt
  dest: incoming/archive/frost_onyx_3073_08.txt
- source: task_syn_006145/workspace/incoming/active/frost_onyx_3073_09.cfg
  dest: incoming/active/frost_onyx_3073_09.cfg
- source: task_syn_006145/workspace/incoming/archive/distractor_006145.txt
  dest: incoming/archive/distractor_006145.txt
capability_family: file_directory_operations
intended_difficulty_band: 5
base_scenario_id: scenario_003073
generator_seed: 957365
multi_session: false
---

## Prompt

You are working on synthetic task `task_syn_006145` for the `knowledge-base upkeep` scenario `frost-onyx-3073`.
Use only the files supplied in the workspace. Do not fetch live data or use credentials.

Inspect the files under `incoming/active/` for the knowledge-base upkeep workspace. Ignore everything under `incoming/archive/`. Select active files ending in `.txt` whose byte length is at least 59, count active files by extension, and identify the largest active file.

Scenario-specific audit anchors: poyasaj sadirik baponal yapojom bahakin havemeo bacevep kilufoq nayanar yagusas worizet poriyau mezeluv tucenaw podicex wojozey narimez kijomea luyabab nahasac kinabad rivemee bajofof cenazeg fovemeh ponawoi gucepoj zevedik vemezel yavefom hafohan diyabao ceguyap tuwobaq haharir wohagus yagufot sariceu dikiyav kikituw fowomex lucetuy kidicez meyatua tucewob meceluc venatud ripozee rijomef pofohag cekimeh ripovei lubayaj guvewok lusacel rizepom jogupon zeludio forivep polupoq wopogur cewonas sayarit hajotuu badiyav hafomew mebasax hahacey mesacez jocegua bakimeb yapocec vevegud lujowoe saluwof rimelug gumetuh nabamei powoluj kipodik haharil wotubam rizehan mewonao womeyap tusakiq cefonar hasatus jocesat pofoguu kijobav jorizew kinagux hakisay meluyaz yadigua.

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
