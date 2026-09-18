---
id: task_syn_006359
name: Multi-artifact triage plan 006359
category: multi_tool_workflow_orchestration
grading_type: llm_judge
timeout_seconds: 240
workspace_files:
- source: task_syn_006359/workspace/triage/tickets.csv
  dest: triage/tickets.csv
- source: task_syn_006359/workspace/triage/scoring.json
  dest: triage/scoring.json
- source: task_syn_006359/workspace/triage/events.log
  dest: triage/events.log
capability_family: multi_tool_workflow_orchestration
intended_difficulty_band: 4
base_scenario_id: scenario_003180
generator_seed: 965283
multi_session: false
---

## Prompt

You are working on synthetic task `task_syn_006359` for the `customer migration` scenario `ion-tundra-3180`.
Use only the files supplied in the workspace. Do not fetch live data or use credentials.

Combine `triage/tickets.csv`, `triage/scoring.json`, and `triage/events.log` into a priority plan. Apply severity multipliers, subtract one point for blocked tickets, skip malformed event lines, and sort by score descending then ticket id.

Scenario-specific audit anchors: nawoyap zehameq cezefor guwojos josajot sameyau dicesav hacebaw yawogux rimekiy rikiluz nawobaa vejofob sacemec fotuved kiwocee cemefof wodijog yadiguh zejodii wokikij yarinak hanahal havefom vemegun tuvezeo kizejop josariq pokitur diwoces balucet ceguveu guforiv mepocew zefojox gugusay luluriz jofohaa dilusab ceceluc kidigud dinayae ricemef ponajog jofofoh gukimei ririvej yagukik vekifol hatulum tulutun zemeveo luluhap turidiq disanar hajogus wowojot nagufou zeluguv hagubaw cefowox rinasay gutuguz yalutua jorikib dipofoc batuved kimekie nazehaf dikitug sajozeh bananai najoguj rifoluk hameyal hazeham sanamen lukikio poyatup wowofoq fovedir gucehas gubahat mehafou cepokiv fozesaw kidivex lubawoy fomekiz bapomea focepob mezemec venaced sarinae guhacef diyalug.

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

Capability focus: `multi_tool_workflow_orchestration`.

## Additional Notes

All names, records, source pages, logs, and code fixtures in this task are synthetic. Do not infer a final model route or model tier from this metadata.
