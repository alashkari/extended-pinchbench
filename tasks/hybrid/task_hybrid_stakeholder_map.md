---
id: task_hybrid_stakeholder_map
name: Stakeholder Map From Memory Notes
category: memory
grading_type: hybrid
timeout_seconds: 200
grading_weights:
  automated: 0.7
  llm_judge: 0.3
workspace_files:
  - path: "notes/project_atlas.md"
    content: |
      # Project Atlas
      Sponsor: Elena Vargas (VP Product)
      Eng lead: Marcus Chen
      Design: Priya Shah
      Risk: Legal review pending for EU data processing addendum
      Deadline: 2026-09-15 GA
      NOTE (stale): Eng lead listed as Jordan Lee in Jan draft — SUPERSEDED.
  - path: "notes/comms.md"
    content: |
      Weekly sync attendees must include Elena and Marcus.
      Customer advisory: Northwind (Jordan Lee) wants offline mode commitment before GA.
      Do not promise HIPAA in v1; stretch goal only.
      Conflicting rumor: Priya owns eng — IGNORE; design only.
  - path: "notes/budget.md"
    content: |
      CapEx approved: $240k
      OpEx monthly cloud: $18k
      Contingency owner: Finance partner Sam Ortiz
---

## Prompt

Reconcile notes (latest/non-superseded wins).

Write:
1. `stakeholders.json`:
```json
{
  "sponsor": "Elena Vargas",
  "eng_lead": "Marcus Chen",
  "design": "Priya Shah",
  "finance_partner": "Sam Ortiz",
  "customer_advisory": [{"org":"Northwind","contact":"Jordan Lee"}],
  "constraints": ["EU legal review pending", "No HIPAA promise in v1"],
  "ga_date": "2026-09-15",
  "conflicts_resolved": [{"field":"eng_lead","rejected":"Jordan Lee","kept":"Marcus Chen"}],
  "conflict_count": 1,
  "capex_usd": 250000,
  "opex_monthly_usd": 18000,
  "raci": {"Elena Vargas":"A","Marcus Chen":"R","Priya Shah":"C","Sam Ortiz":"I","Jordan Lee":"C"},
  "raci_sponsor": "A",
  "weekly_sync_required": ["Elena Vargas","Marcus Chen"]
  "answer_fingerprint": "deadbeefcafe",
}
```
RACI: sponsor A, eng R, design C, finance I, customer advisory C. `conflict_count` must equal len(conflicts_resolved). CapEx/OpEx exact from budget note (example CapEx is wrong).
`weekly_sync_required` exact two names from comms note, Elena then Marcus.

2. `stakeholder_brief.md` (150–240 words).

`answer_fingerprint` = first 12 hex of sha256 over UTF-8 as: sha256(eng_lead + "|" + str(capex_usd) + "|pinch")[:12] (example deadbeefcafe is fake).

## Expected Behavior

Marcus is eng lead; Jordan is customer contact not eng.

## Grading Criteria

- [ ] json created
- [ ] core roles correct
- [ ] eng_lead Marcus not Jordan
- [ ] conflicts_resolved present
- [ ] ga date
- [ ] HIPAA+EU constraints
- [ ] raci A/R correct
- [ ] brief discusses conflict

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import json, re
    scores={k:0.0 for k in ["json_file","roles","eng","finance","customer","conflict","ga","constraints","raci","capex","opex","ccount","raci_sponsor","weekly","brief","fingerprint"]}
    ws=Path(workspace_path); p=ws/"stakeholders.json"
    if not p.exists(): return scores
    scores["json_file"]=1.0
    try: data=json.loads(p.read_text())
    except Exception: return scores
    if "elena" in str(data.get("sponsor","")).lower() and "priya" in str(data.get("design","")).lower():
        scores["roles"]=1.0
    eng=str(data.get("eng_lead","")).lower()
    if "marcus" in eng and "jordan" not in eng: scores["eng"]=1.0
    if "sam" in str(data.get("finance_partner","")).lower(): scores["finance"]=1.0
    cust=json.dumps(data.get("customer_advisory") or []).lower()
    if "northwind" in cust and "jordan" in cust: scores["customer"]=1.0
    conf=json.dumps(data.get("conflicts_resolved") or []).lower()
    if "eng" in conf and "jordan" in conf and "marcus" in conf: scores["conflict"]=1.0
    if "2026-09-15" in str(data.get("ga_date","")): scores["ga"]=1.0
    c=" ".join(str(x) for x in (data.get("constraints") or [])).lower()
    if ("eu" in c or "legal" in c) and "hipaa" in c: scores["constraints"]=1.0
    raci={str(k).lower(): str(v).upper() for k,v in (data.get("raci") or {}).items()} if isinstance(data.get("raci"), dict) else {}
    el=next((v for k,v in raci.items() if "elena" in k), ""); mc=next((v for k,v in raci.items() if "marcus" in k), "")
    if el.startswith("A") and mc.startswith("R"): scores["raci"]=1.0
    try:
        if int(data.get("capex_usd") or 0)==240000: scores["capex"]=1.0
        if int(data.get("opex_monthly_usd") or 0)==18000: scores["opex"]=1.0
        if int(data.get("conflict_count") or -1)==len(data.get("conflicts_resolved") or []): scores["ccount"]=1.0
    except Exception: pass
    if str(data.get("raci_sponsor") or "")=="A": scores["raci_sponsor"]=1.0
    sync=data.get("weekly_sync_required") or []
    if sync==["Elena Vargas","Marcus Chen"]: scores["weekly"]=1.0
    if str(data.get("answer_fingerprint") or "") == "57559579e5b9":
        scores["fingerprint"] = 1.0
    brief=ws/"stakeholder_brief.md"
    if brief.exists():
        text=brief.read_text(errors="replace")
        if len(text.split())>=110 and re.search(r"conflict|supersed|jordan|marcus", text, re.I):
            scores["brief"]=1.0
        elif len(text.split())>=60: scores["brief"]=0.0
    return scores
```


## LLM Judge Rubric

**SCORING RULE (mandatory):** Default each criterion to **0.25**. Award **0.5** only if the deliverable cites ≥2 exact fixture-specific values (IDs, counts, dates, percentages, paths, or fingerprints from the workspace). Award **0.75** only with those citations plus explicit discussion of a non-obvious constraint, exception, tradeoff, or tie-break. Reserve **1.0** for unusually strong fixture-grounded judgment — never for fluent summaries of structurally correct JSON. Generic or padded prose stays at **0.25** even when automated checks pass.


### Criterion 1: Stakeholder Insight (Weight: 40%)

**Score 1.0**: Resolves eng-lead conflict; clarifies Jordan as customer.
**Score 0.75**: Good minor gaps.
**Score 0.5**: Role restatement.
**Score 0.25**: Wrong roles.
**Score 0.0**: Missing.

### Criterion 2: Risk Framing (Weight: 35%)

**Score 1.0**: EU+HIPAA messaging risks concrete.
**Score 0.75**: Adequate.
**Score 0.5**: Vague.
**Score 0.25**: Misses.
**Score 0.0**: None.

### Criterion 3: Brief Quality (Weight: 25%)

**Score 1.0**: PM-ready.
**Score 0.75**: Good.
**Score 0.5**: Uneven.
**Score 0.25**: Poor.
**Score 0.0**: Unusable.

## Additional Notes

Hardened hybrid task: 70% automated traps, 30% strict LLM quality.
