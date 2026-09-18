---
id: task_syn_007978
name: Generate record transformer 007978
category: code_generation
grading_type: llm_judge
timeout_seconds: 210
workspace_files:
- source: task_syn_007978/workspace/spec/visible_cases.json
  dest: spec/visible_cases.json
capability_family: code_generation
intended_difficulty_band: 3
base_scenario_id: scenario_003989
generator_seed: 1025186
multi_session: false
---

## Prompt

You are working on synthetic task `task_syn_007978` for the `sensor calibration` scenario `lumen-zenith-3989`.
Use only the supplied workspace files. Do not fetch live data or use credentials.

Implement `transform_records(records)`. Keep records whose status is `active` and score is at least 58. Return dictionaries with uppercase `code` and `bucket`, where bucket is `priority` when the score is at least 78, otherwise `watch`. Sort by code. Write the implementation to `submission/solution.py`.

Scenario-specific code anchors: zegubaw gufodix jovekiy bavefoz zeharia jozepob yamezec difozed gufozee pomesaf basadig rigurih yahamei tufodij hazeguk diritul rivepom guwojon bafosao narisap mevetuq gusacer zejobas venabat poriyau dihavev hazewow risadix wopozey jovecez yawodia kifobab bafodic hariyad tuwokie merimef jodipog metuguh tuguzei wotuluj jojozek ribakil hanarim kipoban hasanao jobamep jorijoq memezer savelus veluyat joribau baguwov zefoyaw vesanax nabakiy vegubaz dirilua rigudib saceyac tunarid velufoe hadicef dirilug zeyadih gubahai luzeguj yakiguk cerifol haluzem habakin ceridio mehazep gucezeq bavever bayabas lubagut jokidiu cevetuv cefohaw joyagux yacemey bavekiz mewopoa difozeb badizec guvehad sapotue focefof mevehag dinarih zewofoi ditujoj turihak jobatul riyazem lujosan.

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
