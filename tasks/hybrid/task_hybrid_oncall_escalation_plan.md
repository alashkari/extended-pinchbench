---
id: task_hybrid_oncall_escalation_plan
name: PagerDuty Escalation Plan From Fixture
category: integrations
grading_type: hybrid
timeout_seconds: 200
grading_weights:
  automated: 0.7
  llm_judge: 0.3
workspace_files:
  - path: "pagerduty.json"
    content: |
      {
        "schedule": {"primary":"Alex Kim","secondary":"Riley Ng","manager":"Samira Ortiz"},
        "open_incidents": [
          {"id":"PD-100","severity":"SEV-1","service":"payments","age_min":42,"acked":false},
          {"id":"PD-110","severity":"SEV-1","service":"checkout","age_min":28,"acked":true},
          {"id":"PD-208","severity":"SEV-2","service":"search","age_min":10,"acked":true},
          {"id":"PD-220","severity":"SEV-2","service":"api","age_min":25,"acked":false},
          {"id":"PD-301","severity":"SEV-3","service":"notifications","age_min":5,"acked":false}
        ],
        "policy": {
          "sev1_ack_sla_min": 5,
          "sev1_escalate_after_min": 15,
          "sev2_ack_sla_min": 15,
          "sev2_escalate_after_min": 20,
          "page_manager_on_sev1_escalate": true
        }
      }
---

## Prompt

Rules:
- immediate_escalate if SEV-1 and age_min > sev1_escalate_after_min and (acked is false OR still want secondary eyes — treat unacked only for escalate, BUT if SEV-1 acked and age_min > 2*sev1_escalate_after_min also escalate)
  Clarification used by grader:
  - SEV-1 unacked & age>15 → escalate
  - SEV-1 acked & age>30 → escalate
  - SEV-2 unacked & age>20 → escalate
- watch: SEV-2 acked OR SEV-1 acked with age<=30
- no_action: SEV-3 unless age_min>60

pages_needed: manager if any SEV-1 is in immediate_escalate and page_manager_on_sev1_escalate.

Write `escalation_actions.json`:
```json
{
  "immediate_escalate": [{"id":"PD-100","to":"Riley Ng"}],
  "watch": [{"id":"PD-110"}],
  "no_action": [{"id":"PD-301"}],
  "pages_needed": ["Samira Ortiz"],
  "escalate_ids_csv": "PD-100,PD-220",
  "watch_ids_csv": "PD-110,PD-208",
  "no_action_ids_csv": "PD-208,PD-301",
  "n_escalate": 2,
  "unacked_over_ack_sla_csv": "PD-100",
  "manager_paged": false
  "answer_fingerprint": "deadbeefcafe",
}
```
IDs in csv fields must be sorted ascending. Example csv values are intentionally wrong — apply the policy.

`unacked_over_ack_sla_csv` = every unacked incident whose `age_min` exceeds the **ack SLA** for its
severity (SEV-3 has no ack SLA and is never listed). `n_escalate` = size of `immediate_escalate`.
`manager_paged` = whether the manager must be paged under the policy.

Every entry in `immediate_escalate` must carry a `to` field naming the secondary on-call.

Also write `escalation_plan.md` (150–250 words).

`answer_fingerprint` = first 12 hex of sha256 over UTF-8 as: sha256(escalate_ids_csv + "|" + watch_ids_csv + "|pinch")[:12] (example deadbeefcafe is fake).

## Expected Behavior

PD-100 escalate (unacked SEV-1). PD-110 watch (acked SEV-1 age 28<=30). PD-220 escalate. PD-208 watch. PD-301 no_action.
escalate_ids_csv=PD-100,PD-220. watch_ids_csv=PD-110,PD-208. pages_needed Samira.

## Grading Criteria

- [ ] json created
- [ ] PD-100 escalate to Riley
- [ ] PD-220 escalate
- [ ] PD-110 watch not escalate
- [ ] PD-208 watch
- [ ] PD-301 no_action
- [ ] Samira pages_needed
- [ ] plan substantive

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import json, re
    scores={k:0.0 for k in ["json_file","pd100","pd220","pd110_watch","pd208","pd301","page","esc_csv","watch_csv","plan","fingerprint",
                            "noact_csv","n_escalate","ack_sla_csv","manager_paged","all_to"]}
    ws=Path(workspace_path); p=ws/"escalation_actions.json"
    if not p.exists(): return scores
    scores["json_file"]=1.0
    try: data=json.loads(p.read_text())
    except Exception: return scores
    def ids(items):
        out=[]
        for it in items or []:
            raw = str(it.get("id","") if isinstance(it,dict) else it)
            m = re.search(r"(?:PD-?)?(\d+)", raw, re.I)
            out.append(f"PD-{m.group(1)}" if m else raw)
        return out
    esc=ids(data.get("immediate_escalate")); watch=ids(data.get("watch")); noact=ids(data.get("no_action"))
    if "PD-100" in esc:
        scores["pd100"]=1.0
        for it in (data.get("immediate_escalate") or []):
            if isinstance(it,dict) and "100" in str(it.get("id","")) and "riley" in str(it.get("to","")).lower():
                scores["pd100"]=1.0
    if "PD-220" in esc: scores["pd220"]=1.0
    if "PD-110" in watch and "PD-110" not in esc: scores["pd110_watch"]=1.0
    if "PD-208" in watch and "PD-208" not in esc: scores["pd208"]=1.0
    if "PD-301" in noact: scores["pd301"]=1.0
    if str(data.get("escalate_ids_csv") or "") == "PD-100,PD-220":
        scores["esc_csv"]=1.0
    if str(data.get("watch_ids_csv") or "") == "PD-110,PD-208":
        scores["watch_csv"]=1.0
    if str(data.get("answer_fingerprint") or "") == "ec12d75ff6be":
        scores["fingerprint"] = 1.0
    if str(data.get("no_action_ids_csv") or "") == "PD-301":
        scores["noact_csv"]=1.0
    try:
        if int(data.get("n_escalate"))==2: scores["n_escalate"]=1.0
    except Exception: pass
    if str(data.get("unacked_over_ack_sla_csv") or "") == "PD-100,PD-220":
        scores["ack_sla_csv"]=1.0
    if data.get("manager_paged") is True:
        scores["manager_paged"]=1.0
    esc_items=data.get("immediate_escalate") or []
    if esc_items and all(isinstance(it,dict) and str(it.get("to","")).strip() for it in esc_items):
        scores["all_to"]=1.0
    pages=[str(x) for x in (data.get("pages_needed") or [])]
    if any("samira" in x.lower() for x in pages): scores["page"]=1.0
    plan=ws/"escalation_plan.md"
    if plan.exists():
        text=plan.read_text(errors="replace")
        if len(text.split())>=110 and re.search(r"PD-100|SEV-1", text) and re.search(r"PD-220|SEV-2", text):
            scores["plan"]=1.0
        elif len(text.split())>=60: scores["plan"]=0.0
    return scores
```


## LLM Judge Rubric

**SCORING RULE (mandatory):** Default each criterion to **0.25**. Award **0.5** only if the deliverable cites ≥2 exact fixture-specific values (IDs, counts, dates, percentages, paths, or fingerprints from the workspace). Award **0.75** only with those citations plus explicit discussion of a non-obvious constraint, exception, tradeoff, or tie-break. Reserve **1.0** for unusually strong fixture-grounded judgment — never for fluent summaries of structurally correct JSON. Generic or padded prose stays at **0.25** even when automated checks pass.


### Criterion 1: Policy Application (Weight: 40%)

**Score 1.0**: Applies SEV-1/SEV-2 escalate edges correctly; PD-110 watched.
**Score 0.75**: Mostly correct.
**Score 0.5**: Partial.
**Score 0.25**: Incorrect.
**Score 0.0**: Missing.

### Criterion 2: On-Call Usability (Weight: 35%)

**Score 1.0**: Primary can execute immediately.
**Score 0.75**: Mostly usable.
**Score 0.5**: Needs interpretation.
**Score 0.25**: Not usable.
**Score 0.0**: None.

### Criterion 3: Writing Quality (Weight: 25%)

**Score 1.0**: Clear incident-command prose.
**Score 0.75**: Good.
**Score 0.5**: Uneven.
**Score 0.25**: Poor.
**Score 0.0**: Unusable.

## Additional Notes

Hardened hybrid task: 70% automated traps, 30% strict LLM quality.
