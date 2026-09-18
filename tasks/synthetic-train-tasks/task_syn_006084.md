---
id: task_syn_006084
name: Repair record transformer 006084
category: code_debugging
grading_type: llm_judge
timeout_seconds: 240
workspace_files:
- source: task_syn_006084/workspace/src/buggy_module.py
  dest: src/buggy_module.py
- source: task_syn_006084/workspace/tests/visible_cases.json
  dest: tests/visible_cases.json
capability_family: code_debugging
intended_difficulty_band: 4
base_scenario_id: scenario_003042
generator_seed: 955108
multi_session: false
---

## Prompt

You are working on synthetic task `task_syn_006084` for the `policy review` scenario `amber-lumen-3042`.
Use only the supplied workspace files. Do not fetch live data or use credentials.

`src/buggy_module.py` is intended to satisfy this behavior: Implement `transform_records(records)`. Keep records whose status is `active` and score is at least 64. Return dictionaries with uppercase `code` and `bucket`, where bucket is `priority` when the score is at least 84, otherwise `watch`. Sort by code. Write the corrected implementation to `submission/fixed_module.py` with the same public function.

Scenario-specific code anchors: dizewoa ritujob hadicec yajotud bazesae yadinaf luturig wozeveh bacenai fonajoj bapopok savemel sarifom vehagun nagufoo vejokip foforiq rizeyar vebaves cejozet cemewou dihamev kikizew fosavex lutujoy kirivez fosapoa jotuwob jotusac medinad ricecee yariguf nayazeg zezetuh gujoyai vevevej nakiwok kimejol tucepom riguven guguyao lutusap gujoveq hadicer kiceves yamecet veyazeu saguluv mecezew mesadix gutuzey wozesaz zezesaa luvemeb sahatuc bazedid yadinae wosapof meguzeg zezewoh guhasai bafodij mepowok luyasal kiyadim zeguwon popoveo hawobap tuguceq luzedir tukijos cepowot pomewou kiyaluv tuzeluw hatuvex ridiyay riyakiz tutukia yajogub gugujoc hanagud metuvee vedisaf yagutug guvezeh divenai posavej kinawok kivekil dimedim melugun zenaluo guhacep kidiwoq fodicer.

The submitted Python file must use only the standard library and expose the requested public function.
Keep the implementation deterministic and handle malformed records by skipping them when the behavior description implies a numeric conversion.
Run or reason through the visible cases before finishing.

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
