---
id: task_hybrid_competitor_matrix
name: Competitor Feature Matrix Brief
category: research
grading_type: hybrid
timeout_seconds: 200
grading_weights:
  automated: 0.7
  llm_judge: 0.3
workspace_files:
  - path: "competitors_a.md"
    content: |
      # Source A (sales eng notes)
      AcmeFlow: $29/user/mo; SAML yes; offline full; API 120 rpm; HIPAA yes
      BeaconHQ: $19/user/mo; SAML no (OIDC only); offline none; API 300 rpm; HIPAA no
      Crestline: $39/user/mo; SAML yes; offline partial; API 200 rpm; HIPAA yes
  - path: "competitors_b.md"
    content: |
      # Source B (conflicting / newer)
      AcmeFlow API is actually 150 rpm after 2026-06 upgrade (Source A outdated).
      Crestline offline upgraded to full in beta — but GA still partial; for scoring treat as partial.
      BeaconHQ claims HIPAA via BAA add-on — REJECT for this buyer unless base HIPAA is true (it is not).
---

## Prompt

Reconcile Source A with Source B overrides.

Buyer needs: HIPAA=true AND SAML=true AND offline in {full,partial} AND api_rpm >= 210.

Write:
1. `feature_matrix.json`:
```json
{
  "products":[
    {"name":"AcmeFlow","price_per_user_mo":29,"saml":true,"offline":"full","api_rpm":150,"hipaa":true}
  ],
  "eligible_for_buyer":["..."],
  "eligible_csv":"AcmeFlow,Crestline",
  "recommended":"...",
  "price_spread_usd":10,
  "answer_fingerprint": "deadbeefcafe",
  "rejection_reasons":{"BeaconHQ":"...","AcmeFlow":"api_rpm<160"}
}
```
Use reconciled AcmeFlow api_rpm=150. Crestline offline remains partial. BeaconHQ hipaa=false.
`eligible_csv` must be the empty string (example listing vendors is wrong — none qualify under api_rpm >= 210).
`price_spread_usd` is Crestline-Acme = 10 but only for reference; still required.
Reject AcmeFlow and Crestline for api_rpm; Beacon for hipaa/saml.

Also include `n_eligible`, `cheapest_name` (lowest price of all three products, eligible or not),
`failed_constraints_csv` listing each rejected vendor and the single constraint it fails as
`Vendor:constraint`, vendors ascending, joined by `,`. Use the constraint names `hipaa`, `saml`,
`offline`, `api_rpm`; if a vendor fails several, name the first one in that order.

Eligible must satisfy all buyer constraints. If multiple, prefer lower price then higher api_rpm.

2. `competitive_brief.md` (160–280 words) explaining reconciliation.

`answer_fingerprint` = first 12 hex of sha256 over UTF-8 as: sha256(recommended + "|" + "210" + "|pinch")[:12] (example deadbeefcafe is fake).

## Expected Behavior

api_rpm floor 210: AcmeFlow 150 and Crestline 200 both fail. No vendor is eligible. recommended must be exactly `none`. eligible_csv must be empty string. rejection must include AcmeFlow and Crestline for api_rpm, Beacon for hipaa.

## Grading Criteria

- [ ] json created
- [ ] AcmeFlow api_rpm 150
- [ ] Beacon hipaa false
- [ ] Crestline offline partial
- [ ] eligible includes AcmeFlow and Crestline
- [ ] recommended AcmeFlow
- [ ] Beacon rejected for HIPAA/SAML
- [ ] brief mentions reconciliation

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import json, re
    scores = {k:0.0 for k in ["json_file","api150","beacon_hipaa","crest_partial","eligible","recommended","reject_beacon","reject_acme","eligible_csv","price_spread","no_crest_reject","brief","fingerprint",
                              "n_eligible","cheapest","failed_csv"]}
    ws = Path(workspace_path)
    p = ws / "feature_matrix.json"
    if not p.exists():
        return scores
    scores["json_file"] = 1.0
    try:
        data = json.loads(p.read_text())
    except Exception:
        return scores
    products = {str(x.get("name","")).lower(): x for x in (data.get("products") or []) if isinstance(x, dict)}
    acme = products.get("acmeflow") or next((v for k,v in products.items() if "acme" in k), None)
    if acme is not None:
        try:
            if int(acme.get("api_rpm")) == 150:
                scores["api150"] = 1.0
            elif int(acme.get("api_rpm")) in (120,150):
                scores["api150"] = 0.0
        except Exception:
            pass
    beacon = products.get("beaconhq") or next((v for k,v in products.items() if "beacon" in k), None)
    if beacon is not None and beacon.get("hipaa") is False:
        scores["beacon_hipaa"] = 1.0
    crest = products.get("crestline") or next((v for k,v in products.items() if "crest" in k), None)
    if crest is not None and str(crest.get("offline","")).lower() == "partial":
        scores["crest_partial"] = 1.0
    elig = [str(x).lower() for x in (data.get("eligible_for_buyer") or [])]
    if len(elig)==0:
        scores["eligible"] = 1.0
    if str(data.get("recommended","")).strip().lower() == "none":
        scores["recommended"] = 1.0
    reasons = json.dumps(data.get("rejection_reasons") or {}).lower()
    if "beacon" in reasons and ("hipaa" in reasons or "saml" in reasons):
        scores["reject_beacon"] = 1.0
    if str(data.get("eligible_csv") if data.get("eligible_csv") is not None else "MISSING") == "":
        scores["eligible_csv"] = 1.0
    try:
        if int(data.get("n_eligible")) == 0:
            scores["n_eligible"] = 1.0
    except Exception:
        pass
    if "beacon" in str(data.get("cheapest_name") or "").lower():
        scores["cheapest"] = 1.0
    if str(data.get("failed_constraints_csv") or "").replace(" ", "") == "AcmeFlow:api_rpm,BeaconHQ:hipaa,Crestline:api_rpm":
        scores["failed_csv"] = 1.0
    if "acme" in reasons and ("api" in reasons or "210" in reasons or "rpm" in reasons):
        scores["reject_acme"] = 1.0
    # Crestline is now rejected for api_rpm under the 210 floor.
    if "crest" in reasons and ("api" in reasons or "210" in reasons or "rpm" in reasons):
        scores["no_crest_reject"] = 1.0
    try:
        if int(data.get("price_spread_usd")) == 10:
            scores["price_spread"] = 1.0
    except Exception:
        pass
    if str(data.get("answer_fingerprint") or "") == "16af7281efb3":
        scores["fingerprint"] = 1.0
    brief = ws / "competitive_brief.md"
    if brief.exists():
        text = brief.read_text(errors="replace")
        if len(text.split()) >= 120 and re.search(r"reconcil|source b|override|210|none|crest", text, re.I):
            scores["brief"] = 1.0
        elif len(text.split()) >= 60:
            scores["brief"] = 0.0
    return scores
```


## LLM Judge Rubric

**SCORING RULE (mandatory):** Default each criterion to **0.25**. Award **0.5** only if the deliverable cites ≥2 exact fixture-specific values (IDs, counts, dates, percentages, paths, or fingerprints from the workspace). Award **0.75** only with those citations plus explicit discussion of a non-obvious constraint, exception, tradeoff, or tie-break. Reserve **1.0** for unusually strong fixture-grounded judgment — never for fluent summaries of structurally correct JSON. Generic or padded prose stays at **0.25** even when automated checks pass.


### Criterion 1: Reconciliation (Weight: 40%)

**Score 1.0**: Clearly applies Source B overrides and keeps Crestline offline as partial.
**Score 0.75**: Mostly correct.
**Score 0.5**: Misses an override.
**Score 0.25**: Confused sources.
**Score 0.0**: Missing.

### Criterion 2: Buyer Fit (Weight: 35%)

**Score 1.0**: No vendor eligible under api>=210; Crestline and AcmeFlow both rejected for rpm.
**Score 0.75**: Right recommend, incomplete eligibility.
**Score 0.5**: Partial.
**Score 0.25**: Wrong.
**Score 0.0**: Missing.

### Criterion 3: Brief Quality (Weight: 25%)

**Score 1.0**: PM-ready comparative brief.
**Score 0.75**: Good.
**Score 0.5**: Uneven.
**Score 0.25**: Poor.
**Score 0.0**: Unusable.

## Additional Notes

Hardened hybrid task: 70% automated traps, 30% strict LLM quality.
