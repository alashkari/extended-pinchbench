---
id: task_syn_006105
name: Generate record transformer 006105
category: code_generation
grading_type: llm_judge
timeout_seconds: 270
workspace_files:
- source: task_syn_006105/workspace/spec/visible_cases.json
  dest: spec/visible_cases.json
capability_family: code_generation
intended_difficulty_band: 5
base_scenario_id: scenario_003053
generator_seed: 955885
multi_session: false
---

## Prompt

You are working on synthetic task `task_syn_006105` for the `policy review` scenario `lumen-cedar-3053`.
Use only the supplied workspace files. Do not fetch live data or use credentials.

Implement `transform_records(records)`. Keep records whose status is `active` and score is at least 70. Return dictionaries with uppercase `code` and `bucket`, where bucket is `priority` when the score is at least 90, otherwise `watch`. Sort by code. Write the implementation to `submission/solution.py`.

Scenario-specific code anchors: poriluv tuluzew dipobax fozebay tumekiz zekifoa bazekib hahaluc rijobad vebabae lubatuf sazefog gunaluh narijoi cegumej mepovek sawoyal cewonam yahatun savedio havefop nagudiq fojojor verifos nabamet lurisau sabaluv tufoluw woyacex kizeriy sanasaz gujobaa vedidib kipovec rimekid veyasae dijocef rifodig vepodih wokihai ribawoj yabapok sanatul tulukim ridiwon fogudio cehawop halubaq yatumer fomefos povesat folumeu baguriv havetuw gukivex jowoguy gucevez vesalua metulub zekihac guyamed hazegue merizef vesaveg kisaceh cecejoi gutuyaj wobaguk luhasal wotudim fojokin havesao tusadip riluzeq sasasar dikibas gunayat mezenau nameluv didikiw yabahax divehay celuwoz disasaa zepotub yawotuc lusakid verisae lujoguf satupog yaribah nagutui yajosaj vebanak yagucel sanalum.

The submitted Python file must use only the standard library and expose the requested public function.
Keep the implementation deterministic and handle malformed records by skipping them when the behavior description implies a numeric conversion.
Ignore files or comments that do not describe the requested function behavior.

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
