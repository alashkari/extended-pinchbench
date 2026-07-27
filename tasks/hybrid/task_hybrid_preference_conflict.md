---
id: task_hybrid_preference_conflict
name: Preference Conflict Resolution Note
category: memory
grading_type: hybrid
timeout_seconds: 200
grading_weights:
  automated: 0.7
  llm_judge: 0.3
workspace_files:
  - path: "memory/preferences_v1.md"
    content: |
      User preferences (2026-01):
      - Deploy window: Tuesdays 16:00-18:00 UTC
      - Page urgency: SMS + Slack
      - Language: British English
      - Risk appetite: conservative (require 2 approvals for prod)
  - path: "memory/preferences_v2.md"
    content: |
      User preferences (2026-04 update):
      - Deploy window: Thursdays 14:00-16:00 UTC
      - Page urgency: Slack only (no SMS)  # supersedes SMS
      - Language: British English
      - Risk appetite: still conservative
  - path: "memory/preferences_v3.md"
    content: |
      User preferences (2026-07 update):
      - Deploy window unchanged from April (Thursdays 14:00-16:00 UTC)
      - Page urgency unchanged (Slack only)
      - Language: American English  # supersedes British English
      - Risk appetite: balanced (1 approval for low-risk; 2 for high-risk)  # supersedes always-2
      - Note: January SMS and Tuesday window remain superseded.
---

## Prompt

Field-level latest-wins across v1→v3.

Write `resolved_preferences.json`:
```json
{
  "deploy_window": {"days":["Thursday"],"start_utc":"14:00","end_utc":"16:00","source_version":"v2"},
  "paging": ["Slack"],
  "language": "British English",
  "risk_appetite": "balanced",
  "approvals": {"low_risk":1,"high_risk":2,"source_version":"v3"},
  "provenance": {
    "deploy_window": "v2",
    "paging": "v2",
    "language": "v1",
    "approvals": "v3"
  },
  "superseded": ["SMS paging","Tuesday deploy window","always-2-approvals"],
  "superseded_csv": "Tuesday deploy window|SMS paging|always-2-approvals",
  "language_source_version": "v1",
  "risk_appetite_source_version": "v3",
  "supersession_count": 2,
  "paging_csv": "Slack",
  "unchanged_fields_csv": "language",
  "n_versions": 3,
  "deploy_window_str": "Thursday 14:00-16:00 UTC",
  "answer_fingerprint": "deadbeefcafe"
}
```
Field-level latest-wins: language is American English from v3 (example still says British/v1 — wrong).
`superseded_csv` must be exactly `SMS paging|Tuesday deploy window|always-2-approvals|British English` (example order and contents are wrong).
`language_source_version` must be `v3`. `risk_appetite_source_version` must be `v3`. `supersession_count` must be 4.
`unchanged_fields_csv` must be the empty string `""` (no field is identical across all three versions).
`paging_csv` must be exactly `Slack`.

Write `conflict_resolution.md` (130–210 words) explaining field-level provenance.

`answer_fingerprint` = first 12 hex of sha256 over UTF-8 as: sha256(superseded_csv + "|" + risk_appetite_source_version + "|pinch")[:12] (example deadbeefcafe is fake).

## Expected Behavior

Deploy from v2, approvals from v3, language American English from v3. Four supersessions. No field unchanged across all versions.

## Grading Criteria

- [ ] json created
- [ ] Thursday 14-16
- [ ] Slack only
- [ ] approvals 1/2
- [ ] provenance deploy v2
- [ ] provenance approvals v3
- [ ] superseded SMS+Tuesday
- [ ] memo mentions provenance

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import json, re
    scores={k:0.0 for k in ["json_file","day","window","paging","approvals","prov_deploy","prov_appr","prov_lang","prov_paging","superseded_csv","lang_src","risk_src","ss_count","paging_csv","memo","fingerprint",
                            "unchanged_csv","n_versions","window_str"]}
    ws=Path(workspace_path); p=ws/"resolved_preferences.json"
    if not p.exists(): return scores
    scores["json_file"]=1.0
    try: data=json.loads(p.read_text())
    except Exception: return scores
    window=data.get("deploy_window") or {}
    days=[str(d).lower() for d in (window.get("days") or [])]
    if any("thur" in d for d in days) and not any("tue" in d for d in days): scores["day"]=1.0
    if "14:00" in str(window.get("start_utc","")) and "16:00" in str(window.get("end_utc","")): scores["window"]=1.0
    paging=[str(p).lower() for p in (data.get("paging") or [])]
    if paging and all("slack" in p for p in paging) and not any("sms" in p for p in paging): scores["paging"]=1.0
    ap=data.get("approvals") or {}
    try:
        if int(ap.get("low_risk"))==1 and int(ap.get("high_risk"))==2: scores["approvals"]=1.0
    except Exception: pass
    prov=data.get("provenance") or {}
    if str(prov.get("deploy_window","")).lower() in {"v2","2"} or "v2" in str(window.get("source_version","")).lower():
        scores["prov_deploy"]=1.0
    if str(prov.get("approvals","")).lower() in {"v3","3"} or "v3" in str(ap.get("source_version","")).lower():
        scores["prov_appr"]=1.0
    if str(prov.get("language","")).lower() in {"v3","3"}:
        scores["prov_lang"]=1.0
    if str(prov.get("paging","")).lower() in {"v2","2"}:
        scores["prov_paging"]=1.0
    if str(data.get("superseded_csv") or "") == "SMS paging|Tuesday deploy window|always-2-approvals|British English":
        scores["superseded_csv"]=1.0
    if str(data.get("language_source_version") or "") == "v3":
        scores["lang_src"]=1.0
    if str(data.get("risk_appetite_source_version") or "") == "v3":
        scores["risk_src"]=1.0
    try:
        if int(data.get("supersession_count"))==4: scores["ss_count"]=1.0
    except Exception: pass
    if str(data.get("paging_csv") or "")=="Slack": scores["paging_csv"]=1.0
    if str(data.get("answer_fingerprint") or "") == "56632db48d14":
        scores["fingerprint"] = 1.0
    if str(data.get("unchanged_fields_csv") if data.get("unchanged_fields_csv") is not None else "MISSING") == "":
        scores["unchanged_csv"] = 1.0
    try:
        if int(data.get("n_versions")) == 3:
            scores["n_versions"] = 1.0
    except Exception:
        pass
    if str(data.get("deploy_window_str") or "").strip() == "Thursday 14:00-16:00 UTC":
        scores["window_str"] = 1.0
    lang_ok = "american" in str(data.get("language") or "").lower()
    memo=ws/"conflict_resolution.md"
    if memo.exists():
        text=memo.read_text(errors="replace")
        if (len(text.split())>=100 and re.search(r"provenance|version|v2|v3", text, re.I)
                and re.search(r"american", text, re.I) and lang_ok):
            scores["memo"]=1.0
    return scores
```


## LLM Judge Rubric

**SCORING RULE (mandatory):** Default each criterion to **0.25**. Award **0.5** only if the deliverable cites ≥2 exact fixture-specific values (IDs, counts, dates, percentages, paths, or fingerprints from the workspace). Award **0.75** only with those citations plus explicit discussion of a non-obvious constraint, exception, tradeoff, or tie-break. Reserve **1.0** for unusually strong fixture-grounded judgment — never for fluent summaries of structurally correct JSON. Generic or padded prose stays at **0.25** even when automated checks pass.


### Criterion 1: Conflict Handling (Weight: 40%)

**Score 1.0**: Field-level latest-wins clear; no stale mix.
**Score 0.75**: Mostly clear.
**Score 0.5**: Confusing.
**Score 0.25**: Wrong.
**Score 0.0**: Missing.

### Criterion 2: Agent Guidance (Weight: 35%)

**Score 1.0**: Concrete behavioral rules with provenance.
**Score 0.75**: Adequate.
**Score 0.5**: Vague.
**Score 0.25**: Misleading.
**Score 0.0**: None.

### Criterion 3: Writing Quality (Weight: 25%)

**Score 1.0**: Crisp note.
**Score 0.75**: Good.
**Score 0.5**: Uneven.
**Score 0.25**: Poor.
**Score 0.0**: Unusable.

## Additional Notes

Hardened hybrid task: 70% automated traps, 30% strict LLM quality.
