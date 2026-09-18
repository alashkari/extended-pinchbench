---
id: task_syn_006270
name: Quantitative reading summary 006270
category: statistical_quantitative_analysis
grading_type: llm_judge
timeout_seconds: 270
workspace_files:
- source: task_syn_006270/workspace/measurements/readings.csv
  dest: measurements/readings.csv
capability_family: statistical_quantitative_analysis
intended_difficulty_band: 5
base_scenario_id: scenario_003135
generator_seed: 961990
multi_session: false
---

## Prompt

You are working on synthetic task `task_syn_006270` for the `sensor calibration` scenario `prairie-ripple-3135`.
Use only the files supplied in the workspace. Do not fetch live data or use credentials.

Analyze `measurements/readings.csv`. Ignore rows whose group is `ignore` or whose weight is zero. Compute count, mean, median, weighted mean, per-group means, and sample ids with values at least 130.

Scenario-specific audit anchors: fojotue haharif hafojog kihameh tumetui lujodij baguwok haguvel rimeyam nahayan kibatuo havekip ricefoq pojozer tujoves zejogut mesafou gunabav baluwow babayax vedipoy kibacez cewowoa guharib najobac pobakid woyalue yazemef yasarig hawoceh wocepoi wokirij foveguk meyavel fohagum zeporin zezehao fotudip sapojoq nasayar sabawos forikit guwokiu nazejov batudiw pomekix wowofoy sadidiz johajoa posawob poripoc ludijod luripoe poludif tulujog diluyah guvewoi jofocej wodiyak satuzel fofokim yagusan rinanao hawokip fosafoq pomecer megutus baricet wodiyau baveguv cegujow diyapox zefonay mediwoz rihajoa lukijob luforic zenaved meditue kidituf cezedig kimeceh fotugui mecepoj jozejok wozejol folujom yajopon joyasao yarifop vecekiq tudinar natutus diwojot kimeyau guyacev.

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

Capability focus: `statistical_quantitative_analysis`.

## Additional Notes

All names, records, source pages, logs, and code fixtures in this task are synthetic. Do not infer a final model route or model tier from this metadata.
