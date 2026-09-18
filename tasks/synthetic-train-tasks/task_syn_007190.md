---
id: task_syn_007190
name: Mini repository maintenance scan 007190
category: repository_navigation_software_maintenance
grading_type: llm_judge
timeout_seconds: 270
workspace_files:
- source: task_syn_007190/workspace/repo/config/modules.json
  dest: repo/config/modules.json
- source: task_syn_007190/workspace/repo/src/ingest.py
  dest: repo/src/ingest.py
- source: task_syn_007190/workspace/repo/src/export.py
  dest: repo/src/export.py
- source: task_syn_007190/workspace/repo/src/audit.py
  dest: repo/src/audit.py
- source: task_syn_007190/workspace/repo/src/notify.py
  dest: repo/src/notify.py
- source: task_syn_007190/workspace/repo/src/cleanup.py
  dest: repo/src/cleanup.py
- source: task_syn_007190/workspace/repo/docs/changelog.md
  dest: repo/docs/changelog.md
capability_family: repository_navigation_software_maintenance
intended_difficulty_band: 5
base_scenario_id: scenario_003595
generator_seed: 996030
multi_session: false
---

## Prompt

You are working on synthetic task `task_syn_007190` for the `inventory audit` scenario `harbor-umbra-3595`.
Use only the files supplied in the workspace. Do not fetch live data or use credentials.

Inspect the mini repository under `repo/`. Create a maintenance report with enabled modules, deprecated modules, TODO markers with their module names, and any enabled module whose source file is missing.

Scenario-specific audit anchors: powobao pocevep lusafoq wopopor bagubas yanakit nameguu lubadiv wofoyaw jopomex habariy pofozez fozejoa cezeyab tuceguc sahahad lunakie hasanaf yajomeg cegutuh yarilui guwopoj yacejok gubacel zecenam sazeven diyario lufojop guluzeq yacehar jonames cejotut basajou meforiv vevebaw yabakix wogusay bagumez cerikia sacezeb nametuc kifosad pogunae wowopof luyawog hanaluh tupowoi kinavej rijobak pogukil mesajom yanazen safonao rihanap nasariq yafogur lukikis nanamet ponazeu tujohav fotumew vecevex zevemey venavez fowovea yanapob fomezec sajopod diwowoe tuvekif mebafog cejobah riporii meririj cejosak worikil joguzem tumejon naverio tulucep sariceq basanar gujolus mezejot sahawou mezenav zemevew navejox disanay tufofoz fotunaa zefosab yakiric jowozed nayamee diyabaf.

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

Capability focus: `repository_navigation_software_maintenance`.

## Additional Notes

All names, records, source pages, logs, and code fixtures in this task are synthetic. Do not infer a final model route or model tier from this metadata.
