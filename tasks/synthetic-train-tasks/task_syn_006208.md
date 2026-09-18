---
id: task_syn_006208
name: Captured source synthesis 006208
category: web_information_gathering_source_synthesis
grading_type: llm_judge
timeout_seconds: 210
workspace_files:
- source: task_syn_006208/workspace/captured/page_a.md
  dest: captured/page_a.md
- source: task_syn_006208/workspace/captured/page_b.md
  dest: captured/page_b.md
- source: task_syn_006208/workspace/captured/page_c.md
  dest: captured/page_c.md
capability_family: web_information_gathering_source_synthesis
intended_difficulty_band: 3
base_scenario_id: scenario_003104
generator_seed: 959696
multi_session: true
---

## Prompt

You are working on synthetic task `task_syn_006208` for the `queue triage` scenario `keystone-violet-3104`.
Use only the files supplied in the workspace. Do not fetch live data or use credentials.

Use the captured source files under `captured/`; do not fetch live pages. Select the metric value by preferring a reviewed source and using latest date only as a tie breaker. Report conflicting metric values and cite the selected file.

Scenario-specific audit anchors: luzediu rivenav lusapow cekihax gusatuy sazefoz yadihaa wopoyab tuhawoc vehahad risarie cejobaf banadig wovepoh podinai jonacej rizekik tusaril gusajom tumemen vepoceo kipolup turinaq ritunar cemebas jobamet zejowou rizekiv harituw luwonax wovewoy zemewoz luwotua diridib cejonac vetuwod naceyae hafojof halubag zegusah woturii foharij kimevek ripowol yasayam hajohan zeluceo narikip zepowoq zesadir satuces zeribat pofojou fohajov narinaw joluyax sayasay yabaguz bamesaa guluyab yazeluc mediwod sayamee sapomef mebahag bayakih lubazei polufoj rizejok habakil johapom habafon zesatuo wosanap riguwoq kidikir wofomes jokilut rizepou tukiguv luhavew megupox focewoy satucez dikiria wodigub cepoguc halubad yaguhae fofofof dicezeg naguveh zeguhai gujomej zenamek cegujol.

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
Some source notes include French words such as priorite, preuve, and etape; keep the output schema in English.
This task may require continuing context across multiple session files.

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

Capability focus: `web_information_gathering_source_synthesis`.

## Additional Notes

All names, records, source pages, logs, and code fixtures in this task are synthetic. Do not infer a final model route or model tier from this metadata.
