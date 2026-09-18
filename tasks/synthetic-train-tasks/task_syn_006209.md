---
id: task_syn_006209
name: Constraint schedule build 006209
category: planning_scheduling_constraint_satisfaction
grading_type: llm_judge
timeout_seconds: 240
workspace_files:
- source: task_syn_006209/workspace/plan/constraints.json
  dest: plan/constraints.json
capability_family: planning_scheduling_constraint_satisfaction
intended_difficulty_band: 4
base_scenario_id: scenario_003105
generator_seed: 959733
multi_session: false
---

## Prompt

You are working on synthetic task `task_syn_006209` for the `incident follow-up` scenario `lumen-juniper-3105`.
Use only the files supplied in the workspace. Do not fetch live data or use credentials.

Create a deterministic schedule from `plan/constraints.json`. Process tasks in listed order, honor dependencies, start at the given workday hour, skip tasks with impossible dependencies or non-positive duration, and report finish time.

Scenario-specific audit anchors: yajobav luyacew cevekix sagusay banabaz dicegua ribabab nawoluc gubanad yamerie fosadif sacekig popoguh hayadii pofovej cebanak zemehal mevefom hanadin vepobao sadisap guyasaq luvegur fozelus wolufot rilumeu fokifov divediw kijosax kiwoyay foveriz wonawoa ricekib guvekic vegujod zewowoe zefoguf kiluzeg batutuh lupogui woyasaj dizejok kicecel foyafom kijoven mekiveo riguhap tubaluq woguver zecehas samegut kisakiu guririv hahasaw fohanax kiguvey cenabaz zefokia guvenab namedic yaguhad gupodie metumef guwokig cenafoh zecehai bapomej nafozek folubal zebazem wokijon tubadio sazebap lufodiq jozerir sacezes posawot bavediu cetumev foworiw ridipox gucezey nacesaz hananaa mepoceb cekicec hamegud zejodie safozef sawosag naluluh woluvei jocesaj medimek fowomel cevemem.

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
