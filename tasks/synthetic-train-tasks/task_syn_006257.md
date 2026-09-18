---
id: task_syn_006257
name: Constraint schedule build 006257
category: planning_scheduling_constraint_satisfaction
grading_type: llm_judge
timeout_seconds: 180
workspace_files:
- source: task_syn_006257/workspace/plan/constraints.json
  dest: plan/constraints.json
capability_family: planning_scheduling_constraint_satisfaction
intended_difficulty_band: 2
base_scenario_id: scenario_003129
generator_seed: 961509
multi_session: false
---

## Prompt

You are working on synthetic task `task_syn_006257` for the `queue triage` scenario `juniper-onyx-3129`.
Use only the files supplied in the workspace. Do not fetch live data or use credentials.

Create a deterministic schedule from `plan/constraints.json`. Process tasks in listed order, honor dependencies, start at the given workday hour, skip tasks with impossible dependencies or non-positive duration, and report finish time.

Scenario-specific audit anchors: ririver yakiwos luyayat tuhasau fowodiv yajovew rilukix gubacey meriyaz zetuzea diyazeb hasasac jofopod pohajoe tuwobaf ponadig wohaguh tuzekii fobahaj fotuhak vekidil worilum luguven turinao hawodip sadizeq vecemer hajopos ponahat gudiriu havehav metutuw guhajox luyapoy kihanaz gusagua sasayab forijoc posazed guforie wohaguf zekisag kiwojoh hakitui cedidij gujoluk cejogul riditum jopocen hazefoo dizecep saluluq fobayar lucejos hanagut zerikiu gulusav zewojow ritubax mepokiy sanayaz badimea kinameb dijoluc jovefod kikicee sajofof vememeg rizemeh samepoi cetujoj kicepok hapotul sabawom cenahan diriwoo luvebap fodiriq dihakir mesadis vetudit rihazeu satuhav woyazew venakix napoguy dijoriz kiwocea megunab hagufoc baporid divehae lukidif zezenag jodinah tuguyai.

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

Capability focus: `planning_scheduling_constraint_satisfaction`.

## Additional Notes

All names, records, source pages, logs, and code fixtures in this task are synthetic. Do not infer a final model route or model tier from this metadata.
