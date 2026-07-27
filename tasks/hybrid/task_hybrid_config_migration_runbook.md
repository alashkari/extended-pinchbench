---
id: task_hybrid_config_migration_runbook
name: Config Migration Runbook
category: skills
grading_type: hybrid
timeout_seconds: 200
grading_weights:
  automated: 0.7
  llm_judge: 0.3
workspace_files:
  - path: "config/old.yaml"
    content: |
      app:
        name: checkout
        replicas: 3
        env: production
      features:
        async_webhooks: false
        canary: false
      limits:
        rps: 200
        burst: 400
      security:
        public_debug_endpoints: false
  - path: "config/new.yaml"
    content: |
      app:
        name: checkout
        replicas: 6
        env: production
      features:
        async_webhooks: true
        canary: true
      limits:
        rps: 350
        burst: 700
      flags:
        webhooks_async_v1: true
      security:
        public_debug_endpoints: true
---

## Prompt

Diff configs. `public_debug_endpoints: true` is security-sensitive → overall risk_level must be `critical` (not merely high) because a production debug endpoint is a severity-critical regression.

Write `migration_plan.json`:
```json
{
  "changes": [{"path":"app.replicas","from":3,"to":6}],
  "feature_flags_enabled": ["async_webhooks","canary","webhooks_async_v1"],
  "security_regressions": ["security.public_debug_endpoints"],
  "risk_level": "medium",
  "apply_order": ["limits","features","flags","app.replicas","security"],
  "validation_gates": ["precheck_debug_false_or_exception","post_apply_rps_ok","post_apply_canary_ok"],
  "rps_delta": 100,
  "answer_fingerprint": "deadbeefcafe",
  "change_count": 0,
  "burst_delta": 100,
  "changed_paths_csv": "app.replicas,limits.rps",
  "rollback": {"replicas":3,"async_webhooks":false,"canary":false,"webhooks_async_v1":false,"public_debug_endpoints":false}
}
```
`apply_order` must place security change last. `rps_delta` = new.rps - old.rps (example 100 is wrong). `validation_gates` must include those three strings.

`changes` must list **every** differing leaf path, including keys added in `new.yaml` that are
absent from `old.yaml`. `change_count` = the number of such paths. `burst_delta` = new.burst -
old.burst. `changed_paths_csv` = all changed leaf paths in dotted form, sorted ascending, joined
by `,` (the example shows only two and is incomplete).

Write `MIGRATION_RUNBOOK.md` with `## Prechecks`, `## Apply`, `## Validate`, `## Rollback` (200–340 words), explicitly blocking prod apply while public_debug_endpoints is true unless exception ticket exists.

`answer_fingerprint` = first 12 hex of sha256 over UTF-8 as: sha256(risk_level + "|" + str(rps_delta) + "|pinch")[:12] (example deadbeefcafe is fake).

## Expected Behavior

Critical risk due to debug endpoints; security last.

## Grading Criteria

- [ ] json created
- [ ] replicas 3->6
- [ ] security_regressions listed
- [ ] risk high
- [ ] security last in apply_order
- [ ] flags include webhooks_async_v1
- [ ] rollback debug false
- [ ] runbook sections + debug warning

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import json, re
    scores={k:0.0 for k in ["json_file","replicas","sec_reg","risk","order","flag","rollback","gates","rps","ccount","runbook","fingerprint",
                            "burst","paths_csv","all_changes"]}
    ws=Path(workspace_path); p=ws/"migration_plan.json"
    if not p.exists(): return scores
    scores["json_file"]=1.0
    try: data=json.loads(p.read_text())
    except Exception: return scores
    changes=json.dumps(data.get("changes") or []).lower()
    if "replicas" in changes and "3" in changes and "6" in changes: scores["replicas"]=1.0
    sec=json.dumps(data.get("security_regressions") or []).lower()
    if "public_debug" in sec: scores["sec_reg"]=1.0
    if str(data.get("risk_level","")).lower()=="critical": scores["risk"]=1.0
    order=[str(x).lower() for x in (data.get("apply_order") or [])]
    want_order=["limits","features","flags","app.replicas","security"]
    if order == want_order or (order and order[-1]=="security" and "limits" in order[0]):
        # require exact
        if [x.replace(" ","") for x in order] == want_order:
            scores["order"]=1.0
    elif order and "security" in order[-1]:
        scores["order"]=0.0
    flags=[str(x).lower() for x in (data.get("feature_flags_enabled") or [])]
    if any("webhooks_async_v1" in f for f in flags): scores["flag"]=1.0
    rb=data.get("rollback") or {}
    if rb.get("public_debug_endpoints") is False or str(rb.get("public_debug_endpoints")).lower()=="false":
        scores["rollback"]=1.0
    gates=set(str(x) for x in (data.get("validation_gates") or []))
    need={"precheck_debug_false_or_exception","post_apply_rps_ok","post_apply_canary_ok"}
    if need <= gates: scores["gates"]=1.0
    try:
        if int(data.get("rps_delta"))==150: scores["rps"]=1.0
    except Exception:
        pass
    try:
        if int(data.get("change_count"))==7 and len(data.get("changes") or [])==7:
            scores["ccount"]=1.0
    except Exception:
        pass
    try:
        if int(data.get("burst_delta"))==300: scores["burst"]=1.0
    except Exception:
        pass
    true_paths=["app.replicas","features.async_webhooks","features.canary",
                "flags.webhooks_async_v1","limits.burst","limits.rps",
                "security.public_debug_endpoints"]
    if str(data.get("changed_paths_csv") or "").strip()==",".join(true_paths):
        scores["paths_csv"]=1.0
    listed=json.dumps(data.get("changes") or []).lower()
    if all(tp.split(".")[-1] in listed for tp in true_paths):
        scores["all_changes"]=1.0
    if str(data.get("answer_fingerprint") or "") == "bb32ba6695bc":
        scores["fingerprint"] = 1.0
    rb_path=ws/"MIGRATION_RUNBOOK.md"
    if rb_path.exists():
        text=rb_path.read_text(errors="replace")
        needed=["prechecks","apply","validate","rollback"]
        hit=sum(1 for n in needed if re.search(rf"^##\s+{n}\s*$", text, re.I|re.M))
        if hit==4 and re.search(r"public_debug|debug_endpoints", text, re.I) and len(text.split())>=160:
            scores["runbook"]=1.0
        elif hit>=3: scores["runbook"]=0.0
    return scores
```


## LLM Judge Rubric

**SCORING RULE (mandatory):** Default each criterion to **0.25**. Award **0.5** only if the deliverable cites ≥2 exact fixture-specific values (IDs, counts, dates, percentages, paths, or fingerprints from the workspace). Award **0.75** only with those citations plus explicit discussion of a non-obvious constraint, exception, tradeoff, or tie-break. Reserve **1.0** for unusually strong fixture-grounded judgment — never for fluent summaries of structurally correct JSON. Generic or padded prose stays at **0.25** even when automated checks pass.


### Criterion 1: Operational Soundness (Weight: 40%)

**Score 1.0**: Treats debug endpoint as blocker; safe ordered apply.
**Score 0.75**: Mostly sound.
**Score 0.5**: Generic.
**Score 0.25**: Unsafe.
**Score 0.0**: Missing.

### Criterion 2: Change Coverage (Weight: 35%)

**Score 1.0**: Covers replicas/limits/flags/security.
**Score 0.75**: Most changes.
**Score 0.5**: Partial.
**Score 0.25**: Omissions.
**Score 0.0**: None.

### Criterion 3: Runbook Clarity (Weight: 25%)

**Score 1.0**: On-call followable.
**Score 0.75**: Good.
**Score 0.5**: Uneven.
**Score 0.25**: Poor.
**Score 0.0**: Unusable.

## Additional Notes

Hardened hybrid task: 70% automated traps, 30% strict LLM quality.
