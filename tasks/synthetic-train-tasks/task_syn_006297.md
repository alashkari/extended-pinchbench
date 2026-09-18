---
id: task_syn_006297
name: Generate record transformer 006297
category: code_generation
grading_type: llm_judge
timeout_seconds: 180
workspace_files:
- source: task_syn_006297/workspace/spec/visible_cases.json
  dest: spec/visible_cases.json
capability_family: code_generation
intended_difficulty_band: 2
base_scenario_id: scenario_003149
generator_seed: 962989
multi_session: false
---

## Prompt

You are working on synthetic task `task_syn_006297` for the `training roster` scenario `delta-nimbus-3149`.
Use only the supplied workspace files. Do not fetch live data or use credentials.

Implement `transform_records(records)`. Keep records whose status is `active` and score is at least 52. Return dictionaries with uppercase `code` and `bucket`, where bucket is `priority` when the score is at least 72, otherwise `watch`. Sort by code. Write the implementation to `submission/solution.py`.

Scenario-specific code anchors: vevewof yamepog hapowoh sadidii meceluj worikik disabal yanapom kijoyan mezeceo kiludip bafopoq cemeyar nanaris vekilut kihaceu jotuyav yadifow dizenax jojofoy kijobaz hagutua jomedib hamenac riwofod johacee cevenaf kibasag safofoh zeyafoi naguhaj meguyak kijopol vepokim cehacen foripoo vegudip fotuyaq mejocer kisasas meguvet pomeriu tuluvev napohaw tupojox velucey lujomez jopowoa zemewob pozebac didigud pojonae vesazef lululug wobasah zeriwoi veforij cefoguk lunawol lugulum fovenan fokirio lupowop celudiq fodikir kidifos cehasat kiguceu cenayav verimew cedifox wozenay foceguz poyahaa fogurib rituwoc josajod gukikie disasaf hafosag kituyah ritujoi jojobaj yazevek kisapol gufosam jogufon jojonao sadisap bakinaq cenamer yayagus zerivet gupopou bawozev kipomew.

The submitted Python file must use only the standard library and expose the requested public function.
Keep the implementation deterministic and handle malformed records by skipping them when the behavior description implies a numeric conversion.

## Expected Behavior

A correct solution writes the requested Python module under `submission/`, exposes the requested function, passes the visible cases, and generalizes to structurally similar hidden cases.

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

Capability focus: `code_generation`.

## Additional Notes

All names, records, source pages, logs, and code fixtures in this task are synthetic. Do not infer a final model route or model tier from this metadata.
