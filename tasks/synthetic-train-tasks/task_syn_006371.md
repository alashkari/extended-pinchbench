---
id: task_syn_006371
name: Repair record transformer 006371
category: code_debugging
grading_type: llm_judge
timeout_seconds: 150
workspace_files:
- source: task_syn_006371/workspace/src/buggy_module.py
  dest: src/buggy_module.py
- source: task_syn_006371/workspace/tests/visible_cases.json
  dest: tests/visible_cases.json
capability_family: code_debugging
intended_difficulty_band: 1
base_scenario_id: scenario_003186
generator_seed: 965727
multi_session: false
---

## Prompt

You are working on synthetic task `task_syn_006371` for the `training roster` scenario `onyx-zenith-3186`.
Use only the supplied workspace files. Do not fetch live data or use credentials.

`src/buggy_module.py` is intended to satisfy this behavior: Implement `transform_records(records)`. Keep records whose status is `active` and score is at least 46. Return dictionaries with uppercase `code` and `bucket`, where bucket is `priority` when the score is at least 66, otherwise `watch`. Sort by code. Write the corrected implementation to `submission/fixed_module.py` with the same public function.

Scenario-specific code anchors: cesakib baworic sahapod dimefoe najonaf halupog nawomeh zevekii nabafoj yazeyak foguril guririm jotucen bayaveo diworip dihanaq vewodir jokipos povenat hawopou babakiv samehaw lutucex guriluy rijotuz luludia gugusab bameric wosalud nayague wokikif dihajog josaluh hakikii jowovej joyabak kiworil nayayam cewotun vezeveo megupop vewobaq dimegur tujopos guzenat jovebau hakiyav diguguw cedihax luwoluy dibatuz pogudia luwokib jowotuc poluved difowoe disajof hakigug nalubah vetugui wolumej fopovek joceyal nadiwom hapotun tuhario kilubap cefohaq tuluwor kizejos narinat nacekiu naluvev lufoyaw medikix pomesay dinahaz gubagua dijonab poveyac menamed cekibae difojof yapobag dijozeh focekii riluyaj forivek potujol dinaham banazen mevepoo yayanap rizeyaq haguyar natuyas.

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

Capability focus: `code_debugging`.

## Additional Notes

All names, records, source pages, logs, and code fixtures in this task are synthetic. Do not infer a final model route or model tier from this metadata.
