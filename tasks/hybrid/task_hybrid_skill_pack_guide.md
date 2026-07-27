---
id: task_hybrid_skill_pack_guide
name: Skill Pack README From Manifests
category: skills
grading_type: hybrid
timeout_seconds: 200
grading_weights:
  automated: 0.7
  llm_judge: 0.3
workspace_files:
  - path: "skill_pack/manifest.yaml"
    content: |
      skills:
        - id: web_fetch
          name: Web Fetch
          version: 1.2.0
          requires: []
          summary: Fetch URL content safely
        - id: csv_tools
          name: CSV Tools
          version: 0.4.1
          requires: ["web_fetch"]
          summary: CSV summarize and plot helpers
        - id: schema_lint
          name: Schema Lint
          version: 0.9.0
          requires: ["web_fetch"]
          summary: Validate JSON schemas
        - id: incident_writer
          name: Incident Writer
          version: 2.0.0
          requires: ["csv_tools", "schema_lint"]
          summary: Draft incident reports from metrics
        - id: notify_bridge
          name: Notify Bridge
          version: 0.3.0
          requires: ["incident_writer", "schema_lint"]
          summary: Optional notifier
  - path: "skill_pack/NOTES.md"
    content: |
      Install dependencies before dependents (topo order).
      Optional skills: notify_bridge AND schema_lint. incident_writer is required. (Older notes saying incident_writer is optional are superseded.)
      Security review required before enabling web_fetch in prod.
      NOTE: schema_lint does NOT require csv_tools (looks cyclic if misread; it is a DAG).
---

## Prompt

From `skill_pack/manifest.yaml` + NOTES:

1. `install_plan.json` (workspace root only — writing under `skill_pack/` fails grading):
```json
{
  "install_order": ["web_fetch","csv_tools","schema_lint","incident_writer","notify_bridge"],
  "optional": ["incident_writer","notify_bridge"],
  "prod_gate": ["web_fetch"],
  "edge_list": [["web_fetch","csv_tools"],["web_fetch","schema_lint"],["csv_tools","incident_writer"],["schema_lint","incident_writer"],["incident_writer","notify_bridge"]],
  "topo_proof": ["web_fetch before csv_tools","web_fetch before schema_lint","csv_tools before incident_writer","schema_lint before incident_writer","incident_writer before notify_bridge"],
  "n_skills": 5,
  "n_edges": 5,
  "optional_csv": "notify_bridge,incident_writer"
  "answer_fingerprint": "deadbeefcafe",
}
```
`install_order` must be a valid topological order (csv_tools and schema_lint may swap after web_fetch).
`optional_csv` must be exactly `notify_bridge,schema_lint` (sorted ascending).

2. `SKILL_PACK_README.md` (190–320 words).

`answer_fingerprint` = first 12 hex of sha256 over UTF-8 as: sha256(optional_csv + "|" + str(n_skills) + "|pinch")[:12] (example deadbeefcafe is fake).

## Expected Behavior

DAG with optional notify_bridge; prod gate web_fetch.

## Grading Criteria

- [ ] json created
- [ ] order starts web_fetch
- [ ] incident after csv and schema
- [ ] notify after incident
- [ ] optional includes both
- [ ] prod_gate web_fetch
- [ ] edge_list has 5 edges
- [ ] topo_proof length >=4

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import json, re
    scores={k:0.0 for k in ["json_file","start","incident_after","notify_after","optional","prod","edges","proof","n_skills","n_edges","opt_csv","fingerprint"]}
    ws=Path(workspace_path); p=ws/"install_plan.json"
    if not p.exists(): return scores
    scores["json_file"]=1.0
    try: data=json.loads(p.read_text())
    except Exception: return scores
    order=[str(x) for x in (data.get("install_order") or [])]
    if order and order[0]=="web_fetch": scores["start"]=1.0
    if "incident_writer" in order and "csv_tools" in order and "schema_lint" in order:
        if order.index("csv_tools") < order.index("incident_writer") and order.index("schema_lint") < order.index("incident_writer"):
            scores["incident_after"]=1.0
    if "notify_bridge" in order and "incident_writer" in order and order.index("incident_writer") < order.index("notify_bridge"):
        scores["notify_after"]=1.0
    opt=set(str(x) for x in (data.get("optional") or []))
    if opt == {"notify_bridge","schema_lint"}: scores["optional"]=1.0
    else: scores["optional"]=0.0
    if "web_fetch" in [str(x) for x in (data.get("prod_gate") or [])]: scores["prod"]=1.0
    edges=data.get("edge_list") or []
    norm=set()
    for e in edges:
        if isinstance(e,(list,tuple)) and len(e)==2: norm.add((str(e[0]),str(e[1])))
    needed={("web_fetch","csv_tools"),("web_fetch","schema_lint"),("csv_tools","incident_writer"),("schema_lint","incident_writer"),("incident_writer","notify_bridge"),("schema_lint","notify_bridge")}
    if needed <= norm: scores["edges"]=1.0
    elif len(needed & norm) >= 3: scores["edges"]=0.0
    proof=data.get("topo_proof") or []
    if isinstance(proof,list) and len(proof)>=5: scores["proof"]=1.0
    try:
        if int(data.get("n_skills"))==5: scores["n_skills"]=1.0
        if int(data.get("n_edges"))==6: scores["n_edges"]=1.0
    except Exception: pass
    if str(data.get("optional_csv") or "")=="notify_bridge,schema_lint":
        scores["opt_csv"]=1.0
    if str(data.get("answer_fingerprint") or "") == "761493a4d6c3":
        scores["fingerprint"] = 1.0
    return scores
```


## LLM Judge Rubric

**SCORING RULE (mandatory):** Default each criterion to **0.25**. Award **0.5** only if the deliverable cites ≥2 exact fixture-specific values (IDs, counts, dates, percentages, paths, or fingerprints from the workspace). Award **0.75** only with those citations plus explicit discussion of a non-obvious constraint, exception, tradeoff, or tie-break. Reserve **1.0** for unusually strong fixture-grounded judgment — never for fluent summaries of structurally correct JSON. Generic or padded prose stays at **0.25** even when automated checks pass.


### Criterion 1: Documentation Usefulness (Weight: 40%)

**Score 1.0**: Install+risks without reading manifests; notes DAG not cycle.
**Score 0.75**: Mostly useful.
**Score 0.5**: Partial.
**Score 0.25**: Not useful.
**Score 0.0**: Missing.

### Criterion 2: Dependency Clarity (Weight: 35%)

**Score 1.0**: Topo order + optional pieces crystal clear.
**Score 0.75**: Clear enough.
**Score 0.5**: Confusing.
**Score 0.25**: Wrong.
**Score 0.0**: None.

### Criterion 3: Writing Quality (Weight: 25%)

**Score 1.0**: Clean README.
**Score 0.75**: Good.
**Score 0.5**: Uneven.
**Score 0.25**: Poor.
**Score 0.0**: Unusable.

## Additional Notes

Hardened hybrid task: 70% automated traps, 30% strict LLM quality.
