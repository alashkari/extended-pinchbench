---
id: task_hybrid_webhook_failure_postmortem
name: Webhook Failure Postmortem
category: integrations
grading_type: hybrid
timeout_seconds: 200
grading_weights:
  automated: 0.7
  llm_judge: 0.3
workspace_files:
  - path: "webhooks.jsonl"
    content: |
      {"id":"wh_1","endpoint":"https://a.example/hook","status":200,"latency_ms":120,"ts":"2026-07-28T10:00:00Z"}
      {"id":"wh_2","endpoint":"https://b.example/hook","status":500,"latency_ms":900,"ts":"2026-07-28T10:00:01Z"}
      {"id":"wh_3","endpoint":"https://b.example/hook","status":502,"latency_ms":1100,"ts":"2026-07-28T10:00:02Z"}
      {"id":"wh_4","endpoint":"https://a.example/hook","status":200,"latency_ms":130,"ts":"2026-07-28T10:00:03Z"}
      {"id":"wh_5","endpoint":"https://b.example/hook","status":504,"latency_ms":1500,"ts":"2026-07-28T10:00:04Z"}
      {"id":"wh_6","endpoint":"https://c.example/hook","status":200,"latency_ms":80,"ts":"2026-07-28T10:00:05Z"}
      {"id":"wh_7","endpoint":"https://b.example/hook","status":500,"latency_ms":950,"ts":"2026-07-28T10:00:06Z"}
      {"id":"wh_8","endpoint":"https://a.example/hook","status":429,"latency_ms":60,"ts":"2026-07-28T10:00:07Z"}
      {"id":"wh_9","endpoint":"https://d.example/hook","status":503,"latency_ms":800,"ts":"2026-07-28T10:00:08Z"}
      {"id":"wh_10","endpoint":"https://d.example/hook","status":500,"latency_ms":820,"ts":"2026-07-28T10:00:09Z"}
      {"id":"wh_11","endpoint":"https://c.example/hook","status":200,"latency_ms":90,"ts":"2026-07-28T10:00:10Z"}
      {"id":"wh_12","endpoint":"https://b.example/hook","status":500,"latency_ms":980,"ts":"2026-07-28T10:00:11Z"}
---

## Prompt

From `webhooks.jsonl` (12 events):

Nearest-rank percentiles on latency list sorted ascending:
p50 = element at index ceil(0.50*n)-1
p95 = element at index ceil(0.95*n)-1

Write `webhook_stats.json`:
```json
{
  "n": 12,
  "success_2xx": 4,
  "fail_5xx": 7,
  "fail_429": 1,
  "worst_endpoint": "https://b.example/hook",
  "worst_endpoint_5xx_count": 5,
  "second_worst_endpoint": "https://d.example/hook",
  "p50_latency_ms": 0,
  "p95_latency_ms": 0,
  "p50_index": 6,
  "p95_index": 11,
  "percentile_method": "nearest-rank",
  "fail_5xx_endpoints_csv": "b.example,d.example"
  "answer_fingerprint": "deadbeefcafe",
}
```
Indices are 0-based into the sorted latency array (example p50_index is wrong — recompute).
`fail_5xx_endpoints_csv` = unique endpoints with any 5xx, sorted by 5xx count desc, host only (b.example then d.example).

Write `postmortem.md` with `## Summary`, `## Impact`, `## Root Cause Hypothesis`, `## Action Items` (180–300 words); actions must name b.example first.

`answer_fingerprint` = sha256(str(p50_latency_ms) + "|" + str(p95_latency_ms) + "|pinch")[:12] (deadbeefcafe is fake).

## Expected Behavior

b has 5 five-xx; d has 2; success 4; 429 one. latencies sorted: 60,80,90,120,130,800,820,900,950,980,1100,1500. n=12; p50 index ceil(6)-1=5 →800; p95 index ceil(11.4)-1=11 →1500.

## Grading Criteria

- [ ] json created
- [ ] n=12
- [ ] success 4 / fail5 7 / 429 1
- [ ] worst b count 5
- [ ] second_worst d
- [ ] p50 800
- [ ] p95 1500
- [ ] postmortem sections + b.example

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import json, re, math
    scores={k:0.0 for k in ["json_file","n","counts","worst","second","p50","p95","idx","method","ep_csv","pm","fingerprint"]}
    ws=Path(workspace_path); p=ws/"webhook_stats.json"
    if not p.exists(): return scores
    scores["json_file"]=1.0
    try: data=json.loads(p.read_text())
    except Exception: return scores
    if int(data.get("n",0))==12: scores["n"]=1.0
    if int(data.get("success_2xx",-1))==4 and int(data.get("fail_5xx",-1))==7 and int(data.get("fail_429",-1))==1:
        scores["counts"]=1.0
    if "b.example" in str(data.get("worst_endpoint","")) and int(data.get("worst_endpoint_5xx_count",-1))==5:
        scores["worst"]=1.0
    if "d.example" in str(data.get("second_worst_endpoint","")): scores["second"]=1.0
    try:
        if int(data.get("p50_latency_ms"))==800: scores["p50"]=1.0
        if int(data.get("p95_latency_ms"))==1500: scores["p95"]=1.0
        if int(data.get("p50_index"))==5 and int(data.get("p95_index"))==11: scores["idx"]=1.0
    except Exception: pass
    if str(data.get("percentile_method") or "").lower()=="nearest-rank":
        scores["method"]=1.0
    if str(data.get("fail_5xx_endpoints_csv") or "") == "b.example,d.example":
        scores["ep_csv"]=1.0
    if str(data.get("answer_fingerprint") or "") == "d5dea1d7127b":
        scores["fingerprint"] = 1.0
    pm=ws/"postmortem.md"
    if pm.exists():
        text=pm.read_text(errors="replace")
        secs=["summary","impact","root cause hypothesis","action items"]
        hit=sum(1 for s in secs if re.search(rf"^##\s+{re.escape(s)}\s*$", text, re.I|re.M))
        if hit==4 and "b.example" in text and len(text.split())>=140:
            scores["pm"]=1.0
        elif hit>=3: scores["pm"]=0.0
    return scores
```


## LLM Judge Rubric

**SCORING RULE (mandatory):** Default each criterion to **0.25**. Award **0.5** only if the deliverable cites ≥2 exact fixture-specific values (IDs, counts, dates, percentages, paths, or fingerprints from the workspace). Award **0.75** only with those citations plus explicit discussion of a non-obvious constraint, exception, tradeoff, or tie-break. Reserve **1.0** for unusually strong fixture-grounded judgment — never for fluent summaries of structurally correct JSON. Generic or padded prose stays at **0.25** even when automated checks pass.


### Criterion 1: Incident Analysis (Weight: 40%)

**Score 1.0**: Focuses on b.example 5xx; separates 429 and d.example.
**Score 0.75**: Mostly correct.
**Score 0.5**: Diffuse.
**Score 0.25**: Wrong.
**Score 0.0**: Missing.

### Criterion 2: Actionability (Weight: 35%)

**Score 1.0**: Concrete actions prioritizing b.example.
**Score 0.75**: Actionable.
**Score 0.5**: Generic.
**Score 0.25**: Not actionable.
**Score 0.0**: None.

### Criterion 3: Postmortem Writing (Weight: 25%)

**Score 1.0**: Blameless postmortem quality.
**Score 0.75**: Good.
**Score 0.5**: Uneven.
**Score 0.25**: Poor.
**Score 0.0**: Unusable.

## Additional Notes

Hardened hybrid task: 70% automated traps, 30% strict LLM quality.
