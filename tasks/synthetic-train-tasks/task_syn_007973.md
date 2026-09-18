---
id: task_syn_007973
name: Quantitative reading summary 007973
category: statistical_quantitative_analysis
grading_type: llm_judge
timeout_seconds: 210
workspace_files:
- source: task_syn_007973/workspace/measurements/readings.csv
  dest: measurements/readings.csv
capability_family: statistical_quantitative_analysis
intended_difficulty_band: 3
base_scenario_id: scenario_003987
generator_seed: 1025001
multi_session: false
---

## Prompt

You are working on synthetic task `task_syn_007973` for the `knowledge-base upkeep` scenario `juniper-xenial-3987`.
Use only the files supplied in the workspace. Do not fetch live data or use credentials.

Analyze `measurements/readings.csv`. Ignore rows whose group is `ignore` or whose weight is zero. Compute count, mean, median, weighted mean, per-group means, and sample ids with values at least 130.

Scenario-specific audit anchors: guvehar samegus wovevet zeyatuu lupocev wocehaw savemex cebazey guhawoz sanabaa divebab sawopoc sazemed fowoyae bagumef cepobag hatuluh nakirii cezewoj najobak popobal forizem dizewon ceyanao yaporip jobafoq wobagur tufoyas ribajot lulukiu habavev balusaw wocegux vedihay zeluzez mepokia dihasab riguyac cediced nacesae vebakif nafopog sadimeh lubawoi tufojoj sasabak cezemel bapozem popolun hatuluo turivep zejosaq bayamer hafoces fosarit riridiu podifov tunabaw safotux tupomey sabanaz zejozea kizefob medisac hazetud yahakie tubavef kipofog vedidih bazelui hanaguj jovedik kijogul vemecem bayakin worinao vefonap nazesaq fokifor powosas tucelut jojokiu lumecev riribaw yapovex vehariy zeyakiz guyapoa mezegub mezefoc mepozed memeyae dimefof riceceg fojodih cegufoi.

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

Capability focus: `statistical_quantitative_analysis`.

## Additional Notes

All names, records, source pages, logs, and code fixtures in this task are synthetic. Do not infer a final model route or model tier from this metadata.
