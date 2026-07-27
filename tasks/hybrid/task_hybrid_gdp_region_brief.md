---
id: task_hybrid_gdp_region_brief
name: Africa GDP Concentration Brief
category: csv_analysis
grading_type: hybrid
timeout_seconds: 260
grading_weights:
  automated: 0.7
  llm_judge: 0.3
workspace_files:
  - source: csvs/world_gdp_2014.csv
    dest: world_gdp_2014.csv
  - path: "africa_allowlist.txt"
    content: |
      Nigeria
      South Africa
      Egypt
      Algeria
      Angola
      Morocco
      Kenya
      Ethiopia
      Tanzania
      Ghana
      Libya
      Sudan
      Tunisia
      Uganda
      Cameroon
      Botswana
      Zambia
      Senegal
      Zimbabwe
      Mozambique
      Namibia
      Gabon
      Mauritius
      Mali
      Madagascar
      Chad
      Rwanda
      Guinea
      Malawi
      Burkina Faso
      Niger
      Benin
      Burundi
      Sierra Leone
      Togo
      Liberia
      Mauritania
      Central African Republic
      Lesotho
      Guinea-Bissau
      Gambia
      Equatorial Guinea
      Swaziland
      Djibouti
      Comoros
      Cape Verde
      Sao Tome and Principe
      Seychelles
      Eritrea
      Somalia
      South Sudan
  - path: "exclude_disputed.txt"
    content: |
      Western Sahara
---

## Prompt

Using `world_gdp_2014.csv` and `africa_allowlist.txt`, include a country only if its COUNTRY is in the allowlist (case-sensitive match as listed) and not in `exclude_disputed.txt`.

Write `africa_gdp.json`:
```json
{
  "n_countries": N,
  "top5": [{"country":"Nigeria","gdp":594.3}],
  "top5_countries_csv": "South Africa,Nigeria,Egypt,Algeria,Angola",
  "top5_share_of_africa_total": 0.0,
  "median_gdp": 0.0,
  "missing_allowlist_not_in_csv": ["..."],
  "excluded_disputed": ["Western Sahara"]
}
```
top5_share must equal round(true_share, 3) exactly (tolerance 0.0005). `top5_countries_csv` exact GDP rank order (example is intentionally wrong). List allowlist names absent from CSV in missing_allowlist_not_in_csv sorted.

Write `africa_gdp_brief.md` (160–260 words).

## Expected Behavior

Top5 Nigeria/South Africa/Egypt/Algeria/Angola; share depends on matched allowlist size.

## Grading Criteria

- [ ] json created
- [ ] first Nigeria ~594.3
- [ ] second South Africa
- [ ] top5 length 5
- [ ] share within 0.02 of truth
- [ ] n_countries matches allowlist∩csv
- [ ] missing list present
- [ ] brief discusses concentration

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import json, csv, statistics, re
    scores = {k:0.0 for k in ["json_file","first","second","top5_len","share","n","missing","top5_csv","median","excluded","brief"]}
    ws = Path(workspace_path)
    path = ws / "africa_gdp.json"
    if not path.exists():
        return scores
    scores["json_file"] = 1.0
    try:
        data = json.loads(path.read_text())
    except Exception:
        return scores
    top5 = data.get("top5") or []
    if len(top5)==5: scores["top5_len"]=1.0
    if top5 and "nigeria" in str(top5[0].get("country","")).lower():
        scores["first"]=1.0
        try:
            if abs(float(top5[0].get("gdp"))-594.3)<=1: scores["first"]=1.0
        except Exception: pass
    if len(top5)>1 and "south africa" in str(top5[1].get("country","")).lower():
        scores["second"]=1.0
    allow=[ln.strip() for ln in (ws/"africa_allowlist.txt").read_text().splitlines() if ln.strip()]
    excl=[ln.strip() for ln in (ws/"exclude_disputed.txt").read_text().splitlines() if ln.strip()]
    rows=list(csv.DictReader((ws/"world_gdp_2014.csv").open()))
    by={r["COUNTRY"]: float(r["GDP (BILLIONS)"]) for r in rows}
    africa=[(c,by[c]) for c in allow if c in by and c not in excl]
    africa_sorted=sorted(africa, key=lambda x:x[1], reverse=True)
    true_share=sum(g for _,g in africa_sorted[:5])/sum(g for _,g in africa) if africa else 0
    missing_true=sorted([c for c in allow if c not in by])
    try:
        rounded = round(true_share, 3)
        if abs(float(data.get("top5_share_of_africa_total"))-rounded)<=0.0005:
            scores["share"]=1.0
    except Exception:
        pass
    if str(data.get("top5_countries_csv") or "") == "Nigeria,South Africa,Egypt,Algeria,Angola":
        scores["top5_csv"]=1.0
    try:
        med = statistics.median([g for _,g in africa]) if africa else 0
        if abs(float(data.get("median_gdp"))-med)<=0.05:
            scores["median"]=1.0
    except Exception:
        pass
    excl_got = [str(x) for x in (data.get("excluded_disputed") or [])]
    if excl_got == excl or (len(excl_got)==1 and "western sahara" in excl_got[0].lower()):
        scores["excluded"]=1.0
    try:
        if int(data.get("n_countries"))==len(africa):
            scores["n"]=1.0
        elif abs(int(data.get("n_countries"))-len(africa))<=3:
            scores["n"]=0.0
    except Exception:
        pass
    missing=[str(x) for x in (data.get("missing_allowlist_not_in_csv") or [])]
    if missing_true and set(missing)==set(missing_true):
        scores["missing"]=1.0
    elif missing:
        scores["missing"]=0.0
    elif not missing_true:
        scores["missing"]=1.0
    brief=ws/"africa_gdp_brief.md"
    if brief.exists():
        text=brief.read_text(errors="replace")
        if len(text.split())>=120 and re.search(r"concentrat|top\s*5|allowlist|risk", text, re.I):
            scores["brief"]=1.0
        elif len(text.split())>=60:
            scores["brief"]=0.0
    return scores
```


## LLM Judge Rubric

**SCORING RULE (mandatory):** Default each criterion to **0.25**. Award **0.5** only if the deliverable cites ≥2 exact fixture-specific values (IDs, counts, dates, percentages, paths, or fingerprints from the workspace). Award **0.75** only with those citations plus explicit discussion of a non-obvious constraint, exception, tradeoff, or tie-break. Reserve **1.0** for unusually strong fixture-grounded judgment — never for fluent summaries of structurally correct JSON. Generic or padded prose stays at **0.25** even when automated checks pass.


### Criterion 1: Economic Insight (Weight: 40%)

**Score 1.0**: Concentration implications with allowlist discipline.
**Score 0.75**: Good.
**Score 0.5**: Descriptive.
**Score 0.25**: Weak.
**Score 0.0**: Missing.

### Criterion 2: Evidence Use (Weight: 35%)

**Score 1.0**: Uses share/median/missing list correctly.
**Score 0.75**: Adequate.
**Score 0.5**: Loose.
**Score 0.25**: Unsupported.
**Score 0.0**: None.

### Criterion 3: Brief Quality (Weight: 25%)

**Score 1.0**: Polished brief.
**Score 0.75**: Good.
**Score 0.5**: Uneven.
**Score 0.25**: Poor.
**Score 0.0**: Unusable.

## Additional Notes

Hardened hybrid task: 70% automated traps, 30% strict LLM quality.
