---
id: task_syn_006118
name: Context continuation update 006118
category: memory_retrieval_context_continuation
grading_type: llm_judge
timeout_seconds: 210
workspace_files:
- source: task_syn_006118/workspace/sessions/session_log.md
  dest: sessions/session_log.md
capability_family: memory_retrieval_context_continuation
intended_difficulty_band: 3
base_scenario_id: scenario_003059
generator_seed: 956366
multi_session: false
---

## Prompt

You are working on synthetic task `task_syn_006118` for the `release readiness` scenario `ripple-ripple-3059`.
Use only the files supplied in the workspace. Do not fetch live data or use credentials.

Read the session log file or files under `sessions/` and produce a context-continuation update. Separate durable preferences, current state, and stale items.

Scenario-specific audit anchors: cesasai hamecej pogupok yakifol josatum cemeven fohaceo zehacep fopotuq luhakir gunawos yakipot yamemeu zejopov pocezew bahahax tucebay hariguz safoyaa lumepob cemetuc yanadid hasanae vedikif pomekig disadih fotucei kiturij cewomek kicedil potuvem tumedin hajoluo fonafop tusariq mejojor nahabas mehafot rimewou gutupov diyazew hawojox fohacey rigunaz vewodia cegudib cekiwoc wotuced baponae wofopof jojonag savedih tucesai nabahaj turimek lucelul nanawom didirin sahadio melupop tuceceq zehajor basahas naguwot johanau zebahav diricew bajogux wohacey foveyaz rikihaa nalujob guluzec rihahad hajotue megutuf gujobag zeludih yajobai cenadij jodisak savegul luvefom mecejon velusao zegurip vewonaq gupomer mecebas zeluvet tusahau yazezev luyadiw podiyax mezediy napoguz.

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

Capability focus: `memory_retrieval_context_continuation`.

## Additional Notes

All names, records, source pages, logs, and code fixtures in this task are synthetic. Do not infer a final model route or model tier from this metadata.
