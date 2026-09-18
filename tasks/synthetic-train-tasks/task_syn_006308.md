---
id: task_syn_006308
name: Professional update transformation 006308
category: professional_communication_content_transformation
grading_type: llm_judge
timeout_seconds: 210
workspace_files:
- source: task_syn_006308/workspace/drafting/raw_notes.md
  dest: drafting/raw_notes.md
capability_family: professional_communication_content_transformation
intended_difficulty_band: 3
base_scenario_id: scenario_003154
generator_seed: 963396
multi_session: false
---

## Prompt

You are working on synthetic task `task_syn_006308` for the `incident follow-up` scenario `ion-ember-3154`.
Use only the files supplied in the workspace. Do not fetch live data or use credentials.

Turn `drafting/raw_notes.md` into a professional update plan. Capture a concise subject, required points, excluded distractors, and the intended tone. Do not invent commitments not present in the notes.

Scenario-specific audit anchors: mebaceq posapor wocesas vemedit fovewou wogutuv jocewow naludix gutufoy cemevez zemezea gujolub vehaguc focetud megujoe guceyaf jozepog kitujoh tucejoi bajowoj cepocek yavebal lufolum ricejon rimekio kigukip kijoyaq ludiver hafobas yanakit vefokiu veceguv najojow gusapox dibajoy potuyaz nahasaa hayazeb fofohac naribad kiveyae cepovef bavemeg fosaceh tudibai yasakij fomeguk zetusal pojonam havetun fonajoo tubarip dipobaq focebar lupotus tusawot najobau cewonav cegunaw saponax meyaluy zecevez woponaa hakiveb jovevec fojoyad divesae mefotuf ceceyag lusabah yawomei wokifoj hamemek mezedil pocebam sabacen tuvewoo mecerip zehanaq tujogur lusawos cerimet kibatuu ceyayav kifocew rizevex podifoy jogufoz guzeyaa wocebab yakinac sapobad haguvee womerif mezehag yavehah.

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

Capability focus: `professional_communication_content_transformation`.

## Additional Notes

All names, records, source pages, logs, and code fixtures in this task are synthetic. Do not infer a final model route or model tier from this metadata.
