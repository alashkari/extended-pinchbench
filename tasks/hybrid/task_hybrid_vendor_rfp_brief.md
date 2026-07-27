---
id: task_hybrid_vendor_rfp_brief
name: Vendor RFP Decision Brief
category: research
grading_type: hybrid
timeout_seconds: 200
grading_weights:
  automated: 0.7
  llm_judge: 0.3
workspace_files:
  - path: "vendor_quotes.json"
    content: |
      {
        "requirements": {
          "must_have": ["SSO/SAML", "audit_logs", "EU_data_residency", "99.9_uptime_sla", "on_prem_agent", "SOC2_type2"],
          "budget_annual_usd_max": 120000,
          "users": 450,
          "soft_weights": {"support_24x7": 3, "contract_months_le_12": 2, "on_prem_agent": 1}
        },
        "vendors": [
          {"name":"NorthstarOps","annual_usd":98000,"features":["SSO/SAML","audit_logs","EU_data_residency","99.9_uptime_sla","on_prem_agent","SOC2_type2"],"support":"24x7","contract_months":12,"notes":"Strong EU residency; impl 6 weeks."},
          {"name":"PulseBoard","annual_usd":72000,"features":["SSO/SAML","audit_logs","99.9_uptime_sla"],"support":"business_hours","contract_months":24,"notes":"Missing EU residency; cheapest; long lock-in."},
          {"name":"HarborMetrics","annual_usd":135000,"features":["SSO/SAML","audit_logs","EU_data_residency","99.9_uptime_sla","AI_insights"],"support":"24x7","contract_months":12,"notes":"Over budget; best analytics."},
          {"name":"LumenTrace","annual_usd":118000,"features":["SSO/SAML","audit_logs","EU_data_residency","99.9_uptime_sla"],"support":"24x7","contract_months":12,"notes":"Eligible but no on_prem_agent; slightly pricier."}
        ]
      }
---

## Prompt

Using only `vendor_quotes.json`:

Eligibility = ALL must_have features AND annual_usd <= budget.

Soft score for eligible vendors only:
- +3 if support == 24x7
- +2 if contract_months <= 12
- +1 if features includes on_prem_agent

Recommend the eligible vendor with highest soft score; break ties by lower annual_usd.

Write:
1. `rfp_decision.json`:
```json
{
  "eligible_vendors": ["..."],
  "ineligible": [{"name":"...","reasons":["..."]}],
  "scorecard": [{"name":"...","soft_score":0,"annual_usd":0}],
  "recommended": "...",
  "annual_cost_usd": 0,
  "soft_score_sum": 11,
  "scorecard_names_csv": "LumenTrace,NorthstarOps",  "answer_fingerprint": "deadbeefcafe",

  "negotiation_ask": "..."
}
```
`scorecard` only eligible vendors, sorted by soft_score desc then annual_usd asc.
`soft_score_sum` = sum of soft_score across scorecard (must be 11).
`scorecard_names_csv` = scorecard names in rank order (soft_score desc), comma-separated no spaces. Example above is reversed on purpose — do not copy it.
`negotiation_ask` must propose a concrete ask for the winner.

2. `rfp_brief.md` (180–300 words).

`answer_fingerprint` = first 12 hex of sha256 over UTF-8 as: sha256(recommended + "|" + str(annual_cost_usd) + "|" + str(soft_score_sum) + "|pinch")[:12] (example deadbeefcafe is fake).

## Expected Behavior

Only NorthstarOps has on_prem_agent among must-haves. LumenTrace now ineligible. PulseBoard missing EU+agent; Harbor over budget. Recommend NorthstarOps soft=6 cost 98000. soft_score_sum=6. scorecard_names_csv=NorthstarOps.

## Grading Criteria

- [ ] json created
- [ ] eligible exactly NorthstarOps+LumenTrace
- [ ] PulseBoard ineligible for residency
- [ ] Harbor ineligible for budget
- [ ] recommended NorthstarOps
- [ ] scorecard soft_score 6 for Northstar
- [ ] negotiation_ask non-empty
- [ ] brief cites soft score

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import json, re
    scores = {k:0.0 for k in ["json_file","eligible","pulse","harbor","recommended","soft6","soft5","order","ask","sum11","names_csv","brief","fingerprint"]}
    ws = Path(workspace_path)
    p = ws / "rfp_decision.json"
    if not p.exists():
        return scores
    scores["json_file"] = 1.0
    try:
        data = json.loads(p.read_text())
    except Exception:
        return scores
    elig = [str(x) for x in (data.get("eligible_vendors") or [])]
    elig_l = [e.lower() for e in elig]
    if len(elig)==1 and any("northstar" in e for e in elig_l):
        scores["eligible"] = 1.0
    elif any("lumen" in e for e in elig_l):
        scores["eligible"] = 0.0
    inelig = json.dumps(data.get("ineligible") or []).lower()
    if "pulse" in inelig and ("residenc" in inelig or "eu" in inelig):
        scores["pulse"] = 1.0
    if "harbor" in inelig and ("budget" in inelig or "120000" in inelig or "exceed" in inelig):
        scores["harbor"] = 1.0
    if "northstar" in str(data.get("recommended","")).lower():
        scores["recommended"] = 1.0
    scores["soft5"] = 0.0
    scores["order"] = 0.0
    sc = data.get("scorecard") or []
    for row in sc:
        if isinstance(row, dict) and "northstar" in str(row.get("name","")).lower():
            try:
                if int(row.get("soft_score")) == 6:
                    scores["soft6"] = 1.0
            except Exception:
                pass
    inelig_blob = json.dumps(data.get("ineligible") or []).lower()
    if "lumen" in inelig_blob and ("on_prem" in inelig_blob or "agent" in inelig_blob or "must" in inelig_blob):
        scores["soft5"] = 1.0
    if len(sc) == 1 and "northstar" in str(sc[0].get("name","")).lower():
        scores["order"] = 1.0
    ask = str(data.get("negotiation_ask") or "").lower()
    if ask and int(data.get("annual_cost_usd") or 0)==98000 and "on_prem" in ask and ("week" in ask or "impl" in ask) and "98000" in ask.replace(",",""):
        scores["ask"] = 1.0
    try:
        if int(data.get("soft_score_sum") or 0) == 6:
            scores["sum11"] = 1.0
    except Exception:
        pass
    if str(data.get("scorecard_names_csv") or "") == "NorthstarOps":
        scores["names_csv"] = 1.0
    if str(data.get("answer_fingerprint") or "") == "8a85882596f4":
        scores["fingerprint"] = 1.0
    brief = ws / "rfp_brief.md"
    if brief.exists():
        text = brief.read_text(errors="replace")
        if len(text.split()) >= 140 and re.search(r"soft.?score|scorecard|northstar", text, re.I) and re.search(r"lumen|pulse|harbor", text, re.I):
            scores["brief"] = 1.0
        elif len(text.split()) >= 70:
            scores["brief"] = 0.0
    return scores
```


## LLM Judge Rubric

**SCORING RULE (mandatory):** Default each criterion to **0.25**. Award **0.5** only if the deliverable cites ≥2 exact fixture-specific values (IDs, counts, dates, percentages, paths, or fingerprints from the workspace). Award **0.75** only with those citations plus explicit discussion of a non-obvious constraint, exception, tradeoff, or tie-break. Reserve **1.0** for unusually strong fixture-grounded judgment — never for fluent summaries of structurally correct JSON. Generic or padded prose stays at **0.25** even when automated checks pass.


### Criterion 1: Decision Quality (Weight: 40%)

**Score 1.0**: Correctly selects only Northstar (on_prem must-have) and rejects Lumen/Pulse/Harbor with right reasons.
**Score 0.75**: Correct winner, thin scorecard narrative.
**Score 0.5**: Wrong ranking logic.
**Score 0.25**: Wrong winner.
**Score 0.0**: Missing.

### Criterion 2: Negotiation Insight (Weight: 35%)

**Score 1.0**: Concrete negotiation ask tied to price/on-prem/implementation.
**Score 0.75**: Adequate ask.
**Score 0.5**: Generic.
**Score 0.25**: None useful.
**Score 0.0**: Missing.

### Criterion 3: Exec Writing (Weight: 25%)

**Score 1.0**: Decision-first exec brief.
**Score 0.75**: Good.
**Score 0.5**: Uneven.
**Score 0.25**: Poor.
**Score 0.0**: Unusable.

## Additional Notes

Hardened hybrid task: 70% automated traps, 30% strict LLM quality.
