---
id: task_syn_006237
name: Context continuation update 006237
category: memory_retrieval_context_continuation
grading_type: llm_judge
timeout_seconds: 180
workspace_files:
- source: task_syn_006237/workspace/sessions/session_log.md
  dest: sessions/session_log.md
capability_family: memory_retrieval_context_continuation
intended_difficulty_band: 2
base_scenario_id: scenario_003119
generator_seed: 960769
multi_session: false
---

## Prompt

You are working on synthetic task `task_syn_006237` for the `incident follow-up` scenario `zenith-yonder-3119`.
Use only the files supplied in the workspace. Do not fetch live data or use credentials.

Read the session log file or files under `sessions/` and produce a context-continuation update. Separate durable preferences, current state, and stale items.

Scenario-specific audit anchors: tuzerix kituwoy bawofoz jobagua tuvepob lujosac vemekid kikihae gucesaf tucefog fokinah savebai fodipoj fobawok wobazel zeyavem velulun cecetuo cekifop sasaceq fogujor yapoves yayabat tupoyau poceriv tutusaw woguvex wopojoy woguguz didijoa fopojob jowobac yagutud yavekie rikinaf rivezeg lujoluh kiyawoi bazeluj guvewok saforil lucetum poyazen guceceo tuwomep nasaceq kiturir bajogus lujovet satuguu yapoluv salubaw babayax tulukiy cesaluz gukidia cesatub foveguc zewonad ritupoe zetuwof mewopog cesafoh jodipoi tukisaj vesawok ribacel veyaham lulufon bakipoo banacep zejoyaq foriwor bajojos polugut saporiu ridiyav guyazew rihavex fohamey dinatuz lucehaa lukimeb popodic zekikid lulukie yalufof yabatug meforih ceforii nanafoj gujotuk diricel menajom tutulun gunasao.

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

Capability focus: `memory_retrieval_context_continuation`.

## Additional Notes

All names, records, source pages, logs, and code fixtures in this task are synthetic. Do not infer a final model route or model tier from this metadata.
