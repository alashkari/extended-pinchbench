---
id: task_hybrid_incident_customer_email
name: Customer Incident Notification Email
category: writing
grading_type: hybrid
timeout_seconds: 180
grading_weights:
  automated: 0.7
  llm_judge: 0.3
workspace_files:
  - path: "incident_facts.json"
    content: |
      {
        "incident_id": "INC-2044",
        "severity": "SEV-2",
        "product": "Checkout API",
        "customer": "Northwind Retail",
        "requests_total": 50000,
        "requests_failed": 8500,
        "window_start_utc": "2026-07-28T14:05:00Z",
        "window_end_utc": "2026-07-28T14:47:00Z",
        "http_status": 503,
        "root_cause": "Misconfigured connection pool limit after a routine deploy",
        "mitigation": "Rolled back deploy v2.14.3 to v2.14.2; pool limit corrected",
        "current_status": "Resolved",
        "next_steps": ["Postmortem by 2026-07-30", "Add canary check for pool saturation"],
        "do_not_say": ["competitor", "data breach", "ransomware", "negligence", "guarantee"],
        "do_not_invent": ["compensation", "credits", "lawsuit", "PII loss"]
      }
---

## Prompt

Using `incident_facts.json`, compute impact_pct = round(100 * requests_failed / requests_total) exactly (integer).

Write:
1. `customer_email.txt` with Subject including INC-2044; must state impact_pct, both UTC timestamps, HTTP 503, rollback mitigation, Resolved, postmortem 2026-07-30. Forbidden: any do_not_say or do_not_invent terms. No invented compensation.

2. `email_qa.json`:
```json
{"impact_pct": 20, "word_count": N, "mentions_incident_id": true, "avoids_forbidden": true, "duration_minutes": 42, "product_slug": "checkout_api", "severity": "SEV-2", "failed_per_minute": 200.0, "success_pct": 82.5, "next_steps_count": 3, "answer_fingerprint": "deadbeefcafe"}
```
`duration_minutes` = minutes between window_start and window_end (42). `word_count` = body words excluding Subject line; must match actual within **±1**. `product_slug` must be lowercase hyphenated product name (`checkout-api`, not underscore).

`failed_per_minute` = round(requests_failed / duration_minutes, 1). `success_pct` =
round(100 * (1 - requests_failed / requests_total), 2). `next_steps_count` = number of entries in
`next_steps`. The three example values above are all wrong — compute them.

The email body (excluding the Subject line) must be **120–200 words**.

`answer_fingerprint` = sha256(str(impact_pct)+"|"+str(duration_minutes)+"|pinch")[:12].

## Expected Behavior

impact 17%, duration 42 minutes.

## Grading Criteria

- [ ] email created
- [ ] subject INC-2044
- [ ] impact 18%
- [ ] duration or both timestamps
- [ ] mitigation rollback
- [ ] no forbidden terms
- [ ] email_qa impact_pct 18 and duration 42
- [ ] word_count within 5

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import json, re
    scores = {k:0.0 for k in ["email_file","subject","impact","times","mitigation","resolved","status503","noforbidden","qa_fields","qa_wc","slug","sev","fingerprint",
                              "fpm","success_pct","next_steps","body_len"]}
    try:
        ws = Path(workspace_path)
        path = ws / "customer_email.txt"
        if not path.exists():
            return scores
        scores["email_file"] = 1.0
        text = path.read_text(errors="replace"); lower = text.lower()
        if re.search(r"(?im)^\s*subject\s*:.*INC-2044", text):
            scores["subject"] = 1.0
        if re.search(r"\b17\s*%|\b17\s*percent", text, re.I):
            scores["impact"] = 1.0
        if ("14:05" in text and "14:47" in text) or re.search(r"\b42\s*min", lower):
            scores["times"] = 1.0
        if re.search(r"roll\s*back|v2\.14\.2|connection pool", lower):
            scores["mitigation"] = 1.0
        if re.search(r"\bresolved\b", lower):
            scores["resolved"] = 1.0
        if "503" in text:
            scores["status503"] = 1.0
        forbidden = ["competitor","data breach","ransomware","negligence","guarantee","compensation","credits","lawsuit","pii loss"]
        if not any(f in lower for f in forbidden):
            scores["noforbidden"] = 1.0
        qa_path = ws / "email_qa.json"
        if qa_path.exists():
            qa = json.loads(qa_path.read_text())
            if int(qa.get("impact_pct")) == 17 and int(qa.get("duration_minutes")) == 42 and qa.get("mentions_incident_id") is True and qa.get("avoids_forbidden") is True:
                scores["qa_fields"] = 1.0
            body = re.sub(r"(?im)^\s*subject\s*:.*$", "", text).strip()
            wc = len(body.split())
            declared = qa.get("word_count")
            if isinstance(declared, int) and abs(declared - wc) <= 1:
                scores["qa_wc"] = 1.0
            if 120 <= wc <= 200:
                scores["body_len"] = 1.0
            if str(qa.get("product_slug") or "") == "checkout-api":
                scores["slug"] = 1.0
            if str(qa.get("severity") or "") == "SEV-2":
                scores["sev"] = 1.0
            if str(qa.get("answer_fingerprint") or "") == "d0ce371a754b":
                scores["fingerprint"] = 1.0
            try:
                if abs(float(qa.get("failed_per_minute")) - 202.4) <= 0.05:
                    scores["fpm"] = 1.0
            except Exception:
                pass
            try:
                if abs(float(qa.get("success_pct")) - 83.0) <= 0.005:
                    scores["success_pct"] = 1.0
            except Exception:
                pass
            try:
                if int(qa.get("next_steps_count")) == 2:
                    scores["next_steps"] = 1.0
            except Exception:
                pass
    except Exception:
        pass
    return scores
```


## LLM Judge Rubric

**SCORING RULE (mandatory):** Default each criterion to **0.25**. Award **0.5** only if the deliverable cites ≥2 exact fixture-specific values (IDs, counts, dates, percentages, paths, or fingerprints from the workspace). Award **0.75** only with those citations plus explicit discussion of a non-obvious constraint, exception, tradeoff, or tie-break. Reserve **1.0** for unusually strong fixture-grounded judgment — never for fluent summaries of structurally correct JSON. Generic or padded prose stays at **0.25** even when automated checks pass.


### Criterion 1: Empathy and Clarity (Weight: 40%)

**Score 1.0**: Apologetic, clear, no drama; states computed impact (17%) precisely.
**Score 0.75**: Good tone minor issues.
**Score 0.5**: Flat/off.
**Score 0.25**: Bad tone.
**Score 0.0**: Missing.

### Criterion 2: Fact Discipline (Weight: 35%)

**Score 1.0**: Only provided facts; no compensation/legal invention; correct 17%/42m.
**Score 0.75**: Mostly disciplined.
**Score 0.5**: Some invention.
**Score 0.25**: Significant invention.
**Score 0.0**: Fabricated.

### Criterion 3: Customer-Ready Polish (Weight: 25%)

**Score 1.0**: Send-ready.
**Score 0.75**: Nearly.
**Score 0.5**: Needs edit.
**Score 0.25**: Rough.
**Score 0.0**: Unusable.

## Additional Notes

Hardened hybrid task: 70% automated traps, 30% strict LLM quality.
