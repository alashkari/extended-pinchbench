---
id: task_syn_006220
name: Structured table normalization 006220
category: structured_data_transformation
grading_type: llm_judge
timeout_seconds: 270
workspace_files:
- source: task_syn_006220/workspace/tables/source_records.csv
  dest: tables/source_records.csv
- source: task_syn_006220/workspace/tables/region_map.json
  dest: tables/region_map.json
capability_family: structured_data_transformation
intended_difficulty_band: 5
base_scenario_id: scenario_003110
generator_seed: 960140
multi_session: false
---

## Prompt

You are working on synthetic task `task_syn_006220` for the `training roster` scenario `quartz-delta-3110`.
Use only the files supplied in the workspace. Do not fetch live data or use credentials.

Transform `tables/source_records.csv` using `tables/region_map.json`. Keep only active rows with `units * unit_cost >= 145`, uppercase each id, map regions to zones, sort by zone then id, and report how many malformed rows were skipped.

Scenario-specific audit anchors: disawog naribah celusai zelupoj jojopok rihadil wobayam sawojon tujopoo jopopop tuhakiq satumer wopotus banayat dihakiu wofoyav nahaluw zecegux jometuy gudiyaz dikivea nahasab cemeguc gujoved vedibae kivecef zenahag kiyasah gurigui poguyaj tuveguk dilupol wofosam luludin woyafoo celuzep ponapoq joyaver tubames cebasat yakiwou sawofov zenajow zegumex sakinay salumez fohasaa nafowob jonabac forilud kiguyae salusaf rijotug banayah divedii baverij yalusak foyapol kilusam mejodin tuzedio pomejop yaveveq kifofor polufos tucebat foguluu pocefov rihanaw fomewox meyasay cejodiz ripolua yameceb wolutuc gunahad mezevee fopowof sapowog fohawoh hanasai lufotuj kiwohak vekigul joluwom bayatun kiribao hagufop kiwofoq tufocer meditus sagudit fovewou wotufov zetukiw vebacex.

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

Capability focus: `structured_data_transformation`.

## Additional Notes

All names, records, source pages, logs, and code fixtures in this task are synthetic. Do not infer a final model route or model tier from this metadata.
