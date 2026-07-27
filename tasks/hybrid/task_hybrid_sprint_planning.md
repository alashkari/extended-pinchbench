---
id: task_hybrid_sprint_planning
name: Sprint Planning Board From Backlog
category: productivity
grading_type: hybrid
timeout_seconds: 200
grading_weights:
  automated: 0.7
  llm_judge: 0.3
workspace_files:
  - path: "backlog.csv"
    content: |
      id,title,points,priority,blocked_by,owner,exclusive_with
      T-101,Auth rate limit,3,P0,,alice,
      T-102,Webhook retries,5,P0,T-101,bob,
      T-103,Dashboard polish,2,P2,,carol,
      T-104,Fix timezone DST bug,3,P1,,alice,T-108
      T-105,Add audit log export,8,P1,T-104,bob,
      T-106,Docs refresh,1,P3,,carol,
      T-107,Payment idempotency,5,P0,,dave,
      T-108,Flaky e2e quarantine,2,P1,,carol,T-104
      T-109,Canary auto-rollback,5,P0,,alice,
      T-110,Metrics cardinality cap,3,P1,T-109,bob,
---

## Prompt

Plan a sprint with **capacity 16**.

Rules (all must apply):
1. Priority order P0 > P1 > P2 > P3
2. Never select a ticket whose `blocked_by` is not also selected
3. Never select both sides of an `exclusive_with` pair
4. Do not exceed 18 points
5. Among equal priority, prefer smaller id
6. **Owner diversity**: selected set must include **at least 3 distinct owners**
7. Prefer filling capacity exactly when possible under the rules

Write:
1. `sprint_board.json`:
```json
{
  "capacity_points": 16,
  "selected": [{"id":"T-101","points":3,"priority":"P0","owner":"alice"}],
  "deferred": [{"id":"T-103","reason":"..."}],
  "total_selected_points": 16,
  "owners": ["alice","bob","dave"],
  "selected_ids_csv": "T-101,T-102,T-107,T-109",
  "deferred_ids_sorted": ["T-103","T-104","T-105","T-106","T-108","T-110"],
  "capacity_remaining": 0,
  "selection_order": ["T-101","T-107","T-109","T-102"],
  "answer_fingerprint": "deadbeefcafe",
  "blocked_excluded": [],
  "exclusive_excluded": []
}
```
`selected_ids_csv`: selected ids in **ascending id order**, comma-separated no spaces (example above is intentionally not sorted — do not copy it).
`selection_order`: ids in the order they were chosen under the priority rules (P0 ascending id, then next feasible).
`deferred_ids_sorted`: every non-selected id, sorted ascending.
`capacity_remaining` must be 0 for an exact fill.
`answer_fingerprint` = first 12 hex chars of sha256(selected_ids_csv + "|" + "16" + "|pinch") using UTF-8 (example value is a placeholder).
`blocked_excluded`: tickets not selected because blocker missing (empty for optimal plan).
`exclusive_excluded`: tickets not selected due to exclusive_with with a selected ticket (empty when neither side selected).

2. `sprint_plan.md` (140–260 words): cite the exclusive conflict and owner-diversity constraint explicitly.

## Expected Behavior

Capacity 16. P0s T-101+T-107+T-109=13. Adding T-102 overflows. Filling with T-104=16 leaves only 2 owners (fails diversity).
Valid fill: T-101,T-107,T-109,T-108,T-106 (3+5+5+2+1=16), owners alice/dave/carol. selection_order P0s then P1 T-108 then P3 T-106.
selected_ids_csv sorted: T-101,T-106,T-107,T-108,T-109. Deferred: T-102,T-103,T-104,T-105,T-110.

## Grading Criteria

- [ ] sprint_board.json created
- [ ] capacity 18
- [ ] exact optimal selected set
- [ ] total_selected_points 18
- [ ] deps respected
- [ ] >=3 owners
- [ ] no exclusive pair co-selected
- [ ] sprint_plan.md mentions exclusive and diversity

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import json, re
    scores = {k:0.0 for k in ["board_file","capacity","exact_set","points18","deps","owners3","no_exclusive","ids_csv","deferred_sorted","sel_order","cap_rem","fingerprint","plan"]}
    try:
        ws = Path(workspace_path)
        p = ws / "sprint_board.json"
        if not p.exists():
            return scores
        scores["board_file"] = 1.0
        data = json.loads(p.read_text())
        backlog = {
            "T-101": {"points":3,"blocked_by":"","owner":"alice","exclusive_with":""},
            "T-102": {"points":5,"blocked_by":"T-101","owner":"bob","exclusive_with":""},
            "T-103": {"points":2,"blocked_by":"","owner":"carol","exclusive_with":""},
            "T-104": {"points":3,"blocked_by":"","owner":"alice","exclusive_with":"T-108"},
            "T-105": {"points":8,"blocked_by":"T-104","owner":"bob","exclusive_with":""},
            "T-106": {"points":1,"blocked_by":"","owner":"carol","exclusive_with":""},
            "T-107": {"points":5,"blocked_by":"","owner":"dave","exclusive_with":""},
            "T-108": {"points":2,"blocked_by":"","owner":"carol","exclusive_with":"T-104"},
            "T-109": {"points":5,"blocked_by":"","owner":"alice","exclusive_with":""},
            "T-110": {"points":3,"blocked_by":"T-109","owner":"bob","exclusive_with":""},
        }
        if data.get("capacity_points") == 16:
            scores["capacity"] = 1.0
        selected = data.get("selected") or []
        ids = [str(x.get("id")) for x in selected if isinstance(x, dict)]
        pts = sum(backlog[tid]["points"] for tid in ids if tid in backlog)
        ideal = {"T-101","T-106","T-107","T-108","T-109"}
        if set(ids) == ideal:
            scores["exact_set"] = 1.0
        if pts == 16 and data.get("total_selected_points") == 16:
            scores["points18"] = 1.0
        deps_ok = all((not backlog[t]["blocked_by"]) or backlog[t]["blocked_by"] in ids for t in ids if t in backlog)
        if ids and deps_ok:
            scores["deps"] = 1.0
        owners = {backlog[t]["owner"] for t in ids if t in backlog}
        if len(owners) >= 3:
            scores["owners3"] = 1.0
        excl_ok = True
        for t in ids:
            other = backlog.get(t, {}).get("exclusive_with") or ""
            if other and other in ids:
                excl_ok = False
        if ids and excl_ok:
            scores["no_exclusive"] = 1.0
        if str(data.get("selected_ids_csv") or "") == "T-101,T-106,T-107,T-108,T-109":
            scores["ids_csv"] = 1.0
        if (data.get("deferred_ids_sorted") or []) == ["T-102","T-103","T-104","T-105","T-110"]:
            scores["deferred_sorted"] = 1.0
        if data.get("selection_order") == ["T-101","T-107","T-109","T-108","T-106"]:
            scores["sel_order"] = 1.0
        if int(data.get("capacity_remaining") if data.get("capacity_remaining") is not None else -1) == 0:
            scores["cap_rem"] = 1.0
        if str(data.get("answer_fingerprint") or "") == "bf12c56958fe":
            scores["fingerprint"] = 1.0
        plan = ws / "sprint_plan.md"
        if plan.exists():
            text = plan.read_text(errors="replace")
            if len(text.split()) >= 100 and re.search(r"exclusive|conflict", text, re.I) and re.search(r"owner|divers", text, re.I):
                scores["plan"] = 1.0
    except Exception:
        pass
    return scores
```


## LLM Judge Rubric

**SCORING RULE (mandatory):** Default each criterion to **0.25**. Award **0.5** only if the deliverable cites ≥2 exact fixture-specific values (IDs, counts, dates, percentages, paths, or fingerprints from the workspace). Award **0.75** only with those citations plus explicit discussion of a non-obvious constraint, exception, tradeoff, or tie-break. Reserve **1.0** for unusually strong fixture-grounded judgment — never for fluent summaries of structurally correct JSON. Generic or padded prose stays at **0.25** even when automated checks pass.


### Criterion 1: Constraint Handling (Weight: 40%)

**Score 1.0**: Explicitly explains exclusive_with and owner-diversity effects on the selected set with ticket ids.
**Score 0.75**: Mentions both constraints with minor gaps.
**Score 0.5**: Mentions only one constraint or stays generic.
**Score 0.25**: Ignores key constraints.
**Score 0.0**: Missing.

### Criterion 2: Selection Correctness Narrative (Weight: 35%)

**Score 1.0**: Rationale matches a feasible 18-point plan including T-109 canary work and excluding T-108/T-104 conflict cleanly.
**Score 0.75**: Mostly coherent.
**Score 0.5**: Partial.
**Score 0.25**: Contradicts the board.
**Score 0.0**: Missing.

### Criterion 3: Planning Tone (Weight: 25%)

**Score 1.0**: Crisp eng planning note citing concrete risks.
**Score 0.75**: Good.
**Score 0.5**: Padded.
**Score 0.25**: Poor.
**Score 0.0**: Unusable.

## Additional Notes

Hardened hybrid task: 70% automated traps, 30% strict LLM quality. Designed so Qwen3.6-27B-Q6_K lands below SOTA.
