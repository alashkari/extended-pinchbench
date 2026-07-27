---
id: task_hybrid_oncall_handoff
name: On-Call Handoff Packet
category: productivity
grading_type: hybrid
timeout_seconds: 200
grading_weights:
  automated: 0.7
  llm_judge: 0.3
workspace_files:
  - path: "shift_notes.md"
    content: |
      # Outgoing on-call notes (Alex → Jordan)
      Window claimed: 2026-07-27 1:00 PM EDT to 2026-07-28 1:00 PM EDT
      (EDT = UTC-4)

      Open pages:
      - PagerDuty #4821 SEV-2: checkout latency p95 > 800ms since 09:12 UTC. Mitigated by scaling checkout-api to 12 pods. Still above SLO (target 400ms). Owner: platform. acked=false; age_min=50
      - PagerDuty #4828 SEV-3: nightly backup job missed window; rerun scheduled 22:00 UTC. Owner: data. acked=true
      - PagerDuty #4799 SEV-2: OLD — search 5xx spike on 2026-07-20. SUPERSEDED / closed in postmortem; do not carry forward.
      - PagerDuty #4833 SEV-1: payments auth errors 2% for 25 minutes; age_min=25; acked=false. Escalate if unacked > 15 min.

      Policy: escalate_now if (SEV-1 and unacked and age_min > 15) OR (SEV-2 and unacked and age_min > 45).

      Follow-ups due before EOD Tuesday:
      1) Confirm checkout p95 < 400ms for 2 consecutive hours
      2) Verify backup rerun success and update runbook link in Notion

      Do NOT restart payments-worker without checking #payments-war-room first.
---

## Prompt

From `shift_notes.md` produce:

1. `handoff.json`:
```json
{
  "incoming_oncall": "Jordan",
  "outgoing_oncall": "Alex",
  "window_start_utc": "2026-07-27T17:00:00Z",
  "window_end_utc": "2026-07-28T17:00:00Z",
  "open_incidents": [{"id":"4821","severity":"SEV-2","acked":false,"summary":"..."}],
  "excluded_superseded": ["4799"],
  "escalate_now": ["4833"],
  "open_ids_csv": "4821,4833,4828",
  "escalate_now_csv": "4833",
  "answer_fingerprint": "deadbeefcafe",
  "n_open": 3,
  "warnings_csv": "payments-worker",
  "n_escalate": 1,
  "superseded_count": 0,
  "window_hours": 12,
  "sev_counts_csv": "SEV-1:1,SEV-2:2",
  "follow_ups": ["..."],
  "warnings": ["..."]
}
```
`n_escalate` = size of `escalate_now`. `superseded_count` = number of excluded superseded incidents.
`window_hours` = length of the shift window in whole hours. `sev_counts_csv` = severity counts over
the **open** incidents only, severities ascending, as `SEV-n:<count>`. The four example values above
are wrong — derive them.
Convert EDT window to UTC (EDT=UTC-4). Exclude superseded incidents from `open_incidents`. Compute `escalate_now` from the stated policy (age_min=25 for #4833; age_min=50 for #4821 → SEV-2 unacked over 45 → escalate BOTH).
`open_ids_csv` = open incident ids sorted ascending. `escalate_now_csv` must be exactly `4821,4833` (example is wrong).

2. `handoff.md` (130–220 words) Slack handoff covering only active incidents, UTC times, and escalate_now.

`answer_fingerprint` = sha256(open_ids_csv + "|" + escalate_now_csv + "|pinch")[:12] (deadbeefcafe is fake).

## Expected Behavior

UTC window 17:00Z. open incidents 4821,4828,4833 (not 4799). escalate_now 4821 and 4833.

## Grading Criteria

- [ ] handoff.json created
- [ ] UTC window correct
- [ ] superseded 4799 excluded from open
- [ ] excluded_superseded contains 4799
- [ ] escalate_now is exactly 4833
- [ ] open includes 4821 and 4833
- [ ] warnings mention payments-worker
- [ ] handoff.md substantive with UTC

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import json, re
    scores = {k:0.0 for k in ["json_file","window","no_4799","excluded","escalate","open_core","warnings","open_csv","esc_csv","n_open","warn_csv","md","fingerprint",
                              "n_escalate","superseded_count","window_hours","sev_counts","md_cites"]}
    ws = Path(workspace_path)
    p = ws / "handoff.json"
    if not p.exists():
        return scores
    scores["json_file"] = 1.0
    try:
        data = json.loads(p.read_text())
    except Exception:
        return scores
    start = str(data.get("window_start_utc",""))
    end = str(data.get("window_end_utc",""))
    if "2026-07-27T17:00" in start.replace(" ","") and "2026-07-28T17:00" in end.replace(" ",""):
        scores["window"] = 1.0
    elif "17:00" in start and "2026-07-27" in start:
        scores["window"] = 0.0
    incidents = data.get("open_incidents") or []
    ids = set()
    for it in incidents:
        if isinstance(it, dict):
            ids.add(re.sub(r"\D","", str(it.get("id",""))))
        else:
            ids.add(re.sub(r"\D","", str(it)))
    if "4799" not in ids:
        scores["no_4799"] = 1.0
    excl = json.dumps(data.get("excluded_superseded") or []).lower()
    if "4799" in excl:
        scores["excluded"] = 1.0
    esc = json.dumps(data.get("escalate_now") or [])
    esc_ids = set(re.findall(r"4833|4821|4828|4799", esc))
    if esc_ids == {"4833", "4821"}:
        scores["escalate"] = 1.0
    elif "4833" in esc_ids:
        scores["escalate"] = 0.0
    if "4821" in ids and "4833" in ids:
        scores["open_core"] = 1.0
    elif "4833" in ids:
        scores["open_core"] = 0.0
    warns = " ".join(str(x) for x in (data.get("warnings") or [])).lower()
    if "payments-worker" in warns or "payments worker" in warns:
        scores["warnings"] = 1.0
    if str(data.get("open_ids_csv") or "") == "4821,4828,4833":
        scores["open_csv"] = 1.0
    if str(data.get("escalate_now_csv") or "") == "4821,4833":
        scores["esc_csv"] = 1.0
    if str(data.get("warnings_csv") or "") == "payments-worker":
        scores["warn_csv"] = 1.0
    if str(data.get("answer_fingerprint") or "") == "46727a64bfe3":
        scores["fingerprint"] = 1.0
    try:
        if int(data.get("n_open")) == 3:
            scores["n_open"] = 1.0
    except Exception:
        pass
    try:
        if int(data.get("n_escalate")) == 2:
            scores["n_escalate"] = 1.0
    except Exception:
        pass
    try:
        if int(data.get("superseded_count")) == 1:
            scores["superseded_count"] = 1.0
    except Exception:
        pass
    try:
        if int(data.get("window_hours")) == 24:
            scores["window_hours"] = 1.0
    except Exception:
        pass
    if str(data.get("sev_counts_csv") or "").replace(" ", "") == "SEV-1:1,SEV-2:1,SEV-3:1":
        scores["sev_counts"] = 1.0
    md = ws / "handoff.md"
    if md.exists():
        text = md.read_text(errors="replace")
        if len(text.split()) >= 100 and re.search(r"17:00|UTC", text) and re.search(r"4833|escalat", text, re.I):
            scores["md"] = 1.0
        if "4821" in text and "4833" in text and "4799" not in text:
            scores["md_cites"] = 1.0
    return scores
```


## LLM Judge Rubric

**SCORING RULE (mandatory):** Default each criterion to **0.25**. Award **0.5** only if the deliverable cites ≥2 exact fixture-specific values (IDs, counts, dates, percentages, paths, or fingerprints from the workspace). Award **0.75** only with those citations plus explicit discussion of a non-obvious constraint, exception, tradeoff, or tie-break. Reserve **1.0** for unusually strong fixture-grounded judgment — never for fluent summaries of structurally correct JSON. Generic or padded prose stays at **0.25** even when automated checks pass.


### Criterion 1: Operational Precision (Weight: 40%)

**Score 1.0**: Correctly converts EDT→UTC, drops superseded #4799, and escalates #4821 and #4833.
**Score 0.75**: Mostly precise with one minor slip.
**Score 0.5**: Mixes stale/active incidents.
**Score 0.25**: Major confusion.
**Score 0.0**: Missing.

### Criterion 2: Actionability (Weight: 35%)

**Score 1.0**: Handoff makes escalate_now and payments-worker warning unmistakable.
**Score 0.75**: Actionable with minor ambiguity.
**Score 0.5**: Vague.
**Score 0.25**: Not actionable.
**Score 0.0**: None.

### Criterion 3: Slack Writing (Weight: 25%)

**Score 1.0**: Concise Slack-ready note citing UTC times.
**Score 0.75**: Good.
**Score 0.5**: Verbose.
**Score 0.25**: Poor.
**Score 0.0**: Unusable.

## Additional Notes

Hardened hybrid task: 70% automated traps, 30% strict LLM quality.
