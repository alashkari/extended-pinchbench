---
id: task_hybrid_rfc_summary_memo
name: RFC Summary Decision Memo
category: writing
grading_type: hybrid
timeout_seconds: 200
grading_weights:
  automated: 0.7
  llm_judge: 0.3
workspace_files:
  - path: "rfc_draft.md"
    content: |
      # RFC-118: Async Webhook Delivery

      ## Motivation
      Sync webhook delivery adds p95 latency and customer timeouts.

      ## Proposal
      Durable queue via NATS JetStream. API returns 202 with delivery_id.
      Retry schedule: 1s, 5s, 30s, 5m (max 10 attempts). DLQ `webhooks-dlq`.

      ## Alternatives
      1) Raise sync timeout to 15s — rejected (worse UX).
      2) SQS instead of NATS — defer; team expertise is NATS.
      3) Exactly-once via transactional outbox — defer to v1.1 (costly now).

      ## Risks
      - At-least-once requires idempotency keys.
      - Per-endpoint ordering not guaranteed across workers.
      - Shadow mode may double-deliver if not carefully gated.

      ## Rollout
      Shadow 7d → 10% → 50% → 100%. Flag `webhooks_async_v1`.
      Rollback: disable flag; keep sync path 30 days.

      ## Open Questions
      - Delivery status API in v1 or v1.1?
      - Should SEV paging trigger on DLQ depth > 100?
---

## Prompt

Write:
1. `rfc_memo.md` with EXACT headers:
`# RFC-118 Decision Memo`
`## Recommendation`
`## Why`
`## Risks`
`## Rollout`
`## Conditions`
`## Open Questions`
Recommendation line must be exactly: `Approve with conditions`
`## Conditions` must list **exactly 4** numbered conditions, including:
1) idempotency docs before 100% rollout
2) shadow-mode double-delivery gate
3) DLQ paging threshold decision owner assigned
4) delivery status API scoped to v1.1 (not blocked on v1)
Total memo ≤ 240 words.

2. `rfc_extract.json`:
```json
{"rfc_id":"RFC-118","queue":"NATS JetStream","max_attempts":10,"feature_flag":"webhooks_async_v1","initial_response_code":202,"deferred_alternatives":["SQS","transactional outbox"],"deferred_csv":"transactional outbox|SQS","n_conditions":2,"answer_fingerprint":"deadbeefcafe"}
```
`deferred_csv` must be exactly `SQS|transactional outbox`. `n_conditions` must be 4 (example is wrong).
Also include `retry_schedule_csv` (the retry backoff steps in order, joined by `,`, exactly as written
in the RFC), `dlq_name`, `n_open_questions`, and `rejected_alternative` (the alternative the RFC
rejected outright rather than deferring). `## Open Questions` in the memo must carry every open
question from the RFC.
`answer_fingerprint` = sha256(deferred_csv + "|" + str(n_conditions) + "|pinch")[:12] (deadbeefcafe is fake).

## Expected Behavior

Strict header/condition/extract requirements.

## Grading Criteria

- [ ] memo file
- [ ] all headers
- [ ] exact recommendation phrase
- [ ] exactly 3 conditions
- [ ] mentions idempotency and shadow
- [ ] word count <= 240
- [ ] extract json accurate
- [ ] deferred_alternatives includes SQS and outbox

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import json, re
    scores = {k: 0.0 for k in ["memo", "headers", "rec", "three_cond", "key_conds", "words", "json_ok", "deferred", "deferred_csv", "n_cond", "fingerprint",
                               "core_fields", "retry_csv", "dlq", "n_open_q", "rejected_alt", "open_q_memo"]}
    try:
        ws = Path(workspace_path)
        memo = ws / "rfc_memo.md"
        if memo.exists():
            scores["memo"] = 1.0
            text = memo.read_text(encoding="utf-8", errors="replace") or ""
            headers = [
                r"^#\s+RFC-118 Decision Memo\s*$",
                r"^##\s+Recommendation\s*$",
                r"^##\s+Why\s*$",
                r"^##\s+Risks\s*$",
                r"^##\s+Rollout\s*$",
                r"^##\s+Conditions\s*$",
                r"^##\s+Open Questions\s*$",
            ]
            hit = sum(1 for h in headers if re.search(h, text, re.M))
            scores["headers"] = 1.0 if hit == 7 else 0.0
            if re.search(r"Approve with conditions", text or ""):
                scores["rec"] = 1.0
            cond_section = re.search(r"##\s+Conditions(.*?)(?:##|\Z)", text, re.S | re.I)
            if cond_section:
                body = cond_section.group(1) or ""
                nums = re.findall(r"(?m)^\s*(?:\d+[\).]|[-*])\s+\S+", body)
                if len(nums) == 4:
                    scores["three_cond"] = 1.0
                blob = body.lower()
                if "idempoten" in blob and "shadow" in blob and ("dlq" in blob or "paging" in blob):
                    scores["key_conds"] = 1.0
            scores["words"] = 1.0 if len(text.split()) <= 240 else 0.0
            oq = re.search(r"##\s+Open Questions(.*?)(?:##|\Z)", text, re.S | re.I)
            if oq:
                blob = (oq.group(1) or "").lower()
                if ("delivery status" in blob or "v1.1" in blob) and ("dlq" in blob and "100" in blob):
                    scores["open_q_memo"] = 1.0
        jp = ws / "rfc_extract.json"
        if jp.exists():
            data = json.loads(jp.read_text(encoding="utf-8"))
            deferred = json.dumps(data.get("deferred_alternatives") or []).lower()
            if "sqs" in deferred and "outbox" in deferred:
                scores["deferred"] = 1.0
            if str(data.get("deferred_csv") or "") == "SQS|transactional outbox":
                scores["deferred_csv"] = 1.0
            try:
                if (str(data.get("rfc_id") or "") == "RFC-118"
                        and "jetstream" in str(data.get("queue") or "").lower()
                        and int(data.get("max_attempts")) == 10
                        and str(data.get("feature_flag") or "") == "webhooks_async_v1"
                        and int(data.get("initial_response_code")) == 202):
                    scores["core_fields"] = 1.0
            except Exception:
                pass
            if str(data.get("retry_schedule_csv") or "").replace(" ", "") == "1s,5s,30s,5m":
                scores["retry_csv"] = 1.0
            if str(data.get("dlq_name") or "").strip().strip("`") == "webhooks-dlq":
                scores["dlq"] = 1.0
            try:
                if int(data.get("n_open_questions")) == 2:
                    scores["n_open_q"] = 1.0
            except Exception:
                pass
            if re.search(r"sync\s*timeout|15s", str(data.get("rejected_alternative") or ""), re.I):
                scores["rejected_alt"] = 1.0
            try:
                if int(data.get("n_conditions")) == 4:
                    scores["n_cond"] = 1.0
            except Exception:
                pass
            if str(data.get("answer_fingerprint") or "") == "d0dbacacfc06":
                scores["fingerprint"] = 1.0
            ok = 0
            if str(data.get("rfc_id") or "").upper() == "RFC-118":
                ok += 1
            if "nats" in str(data.get("queue") or "").lower():
                ok += 1
            try:
                if int(data.get("max_attempts") or 0) == 10:
                    ok += 1
            except Exception:
                pass
            if str(data.get("feature_flag") or "") == "webhooks_async_v1":
                ok += 1
            try:
                if int(data.get("initial_response_code") or 0) == 202:
                    ok += 1
            except Exception:
                pass
            scores["json_ok"] = 1.0 if ok == 5 else 0.0
    except Exception:
        pass
    return scores
```


## LLM Judge Rubric

**SCORING RULE (mandatory):** Default each criterion to **0.25**. Award **0.5** only if the deliverable cites ≥2 exact fixture-specific values (IDs, counts, dates, percentages, paths, or fingerprints from the workspace). Award **0.75** only with those citations plus explicit discussion of a non-obvious constraint, exception, tradeoff, or tie-break. Reserve **1.0** for unusually strong fixture-grounded judgment — never for fluent summaries of structurally correct JSON. Generic or padded prose stays at **0.25** even when automated checks pass.


### Criterion 1: Decision Usefulness (Weight: 40%)

**Score 1.0**: Memo enables approve/reject; 3 conditions are concrete and rollout-tied.
**Score 0.75**: Useful minor vagueness.
**Score 0.5**: Summary without sharp conditions.
**Score 0.25**: Not decision-oriented.
**Score 0.0**: Missing.

### Criterion 2: Compression (Weight: 35%)

**Score 1.0**: Keeps critical risks/rollout; respects brevity.
**Score 0.75**: Mostly concise.
**Score 0.5**: Padded or missing risk.
**Score 0.25**: Poor.
**Score 0.0**: Fails.

### Criterion 3: Stakeholder Tone (Weight: 25%)

**Score 1.0**: EM-appropriate precise neutral.
**Score 0.75**: Good.
**Score 0.5**: Uneven.
**Score 0.25**: Off.
**Score 0.0**: Unusable.

## Additional Notes

Hardened hybrid task: 70% automated traps, 30% strict LLM quality.
