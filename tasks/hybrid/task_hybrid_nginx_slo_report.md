---
id: task_hybrid_nginx_slo_report
name: Nginx Dual-SLO Report
category: log_analysis
grading_type: hybrid
timeout_seconds: 260
grading_weights:
  automated: 0.7
  llm_judge: 0.3
workspace_files:
  - source: logs/nginx_access_json.log
    dest: nginx_access_json.log
---

## Prompt

Analyze `nginx_access_json.log` (status in `response`, request line in `request`).

SLOs:
- 4xx client-error rate must be < 5%
- availability = 100*(1 - n_5xx/total) must be >= 99.9%

Write `slo_report.json`:
```json
{
  "total_requests": 1000,
  "n_4xx": 690,
  "n_5xx": 0,
  "client_error_rate_pct": 69.0,
  "availability_pct": 100.0,
  "slo_4xx_met": false,
  "slo_availability_met": true,
  "top_4xx_paths": [{"path":"/downloads/product_2","count":355,"share_of_4xx":0.514}],
  "burn_order": ["/downloads/product_2","/downloads/product_1"],
  "burn_order_csv": "/downloads/product_2|/downloads/product_1",
  "top1_share_x1000": 500,
  "dual_slo_status": "4xx_fail,availability_pass",
  "n_2xx": 100,
  "n_3xx": 200,
  "status_class_csv": "2xx:100,3xx:200,4xx:690,5xx:0",
  "n_4xx_paths": 5,
  "top2_gap": 10
  "answer_fingerprint": "deadbeefcafe",
}
```
`share_of_4xx` = count/n_4xx rounded to 3 decimals (0.514).
`burn_order`: paths with share_of_4xx >= 0.5, sorted by 4xx count desc. (product_1 is 0.486 — below threshold, exclude it.)
`top1_share_x1000` = int(round(share_of_4xx*1000)). Example 500 is wrong — compute it.

`n_2xx` and `n_3xx` are counts of 2xx and 3xx responses. The four class counts must sum to
`total_requests`. `status_class_csv` = `2xx:<n>,3xx:<n>,4xx:<n>,5xx:<n>` (example numbers wrong).
`n_4xx_paths` = number of distinct request paths that returned any 4xx.
`top2_gap` = 4xx count of the top path minus the 4xx count of the second path.

Write `slo_narrative.md` (150–250 words) with prioritized remediations following burn_order.

`answer_fingerprint` = first 12 hex of sha256 over UTF-8 as: sha256(dual_slo_status + "|" + str(top1_share_x1000) + "|pinch")[:12] (example deadbeefcafe is fake).

## Expected Behavior

690/1000=69%; availability 100%; burn_order only product_2 (share>=0.5).

## Grading Criteria

- [ ] json created
- [ ] totals correct
- [ ] rates correct
- [ ] slo flags correct
- [ ] top path product_2 count 355
- [ ] share ~0.514
- [ ] burn_order starts product_2
- [ ] narrative prioritizes burn_order

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import json, re
    scores = {k:0.0 for k in ["json_file","totals","rates","flags","top","share","burn","burn_csv","share_x1000","dual","narr","fingerprint",
                              "classes","class_csv","n_paths","top2_gap"]}
    ws = Path(workspace_path)
    p = ws / "slo_report.json"
    if not p.exists():
        return scores
    scores["json_file"]=1.0
    try:
        data=json.loads(p.read_text())
    except Exception:
        return scores
    try:
        if int(data.get("n_2xx"))==36 and int(data.get("n_3xx"))==274:
            scores["classes"]=1.0
    except Exception: pass
    if str(data.get("status_class_csv") or "").strip()=="2xx:36,3xx:274,4xx:690,5xx:0":
        scores["class_csv"]=1.0
    try:
        if int(data.get("n_4xx_paths"))==2:
            scores["n_paths"]=1.0
    except Exception: pass
    try:
        if int(data.get("top2_gap"))==20:
            scores["top2_gap"]=1.0
    except Exception: pass
    try:
        if int(data.get("total_requests"))==1000 and int(data.get("n_4xx"))==690 and int(data.get("n_5xx"))==0:
            scores["totals"]=1.0
        elif abs(int(data.get("n_4xx",0))-690)<=20:
            scores["totals"]=0.0
    except Exception: pass
    try:
        if abs(float(data.get("client_error_rate_pct"))-69.0)<=0.2 and abs(float(data.get("availability_pct"))-100.0)<=0.05:
            scores["rates"]=1.0
    except Exception: pass
    if data.get("slo_4xx_met") is False and data.get("slo_availability_met") is True:
        scores["flags"]=1.0
    tops=data.get("top_4xx_paths") or []
    if tops and "product_2" in str(tops[0].get("path","")).lower():
        try:
            if int(tops[0].get("count"))==355: scores["top"]=1.0
            else: scores["top"]=0.0
        except Exception: scores["top"]=0.0
    try:
        if tops and abs(float(tops[0].get("share_of_4xx"))-round(355/690,3))<=0.001:
            scores["share"]=1.0
        elif tops and float(tops[0].get("share_of_4xx",0))>0.4:
            scores["share"]=0.0
    except Exception: pass
    burn=[str(x) for x in (data.get("burn_order") or [])]
    if len(burn)==1 and "product_2" in burn[0] and not any("product_1" in b for b in burn):
        scores["burn"]=1.0
    if str(data.get("burn_order_csv") or "") == "/downloads/product_2":
        scores["burn_csv"]=1.0
    try:
        if int(data.get("top1_share_x1000")) == 514:
            scores["share_x1000"]=1.0
    except Exception:
        pass
    if str(data.get("dual_slo_status") or "") == "4xx_fail,availability_pass":
        scores["dual"] = 1.0
    if str(data.get("answer_fingerprint") or "") == "f40d2b962ff3":
        scores["fingerprint"] = 1.0
    narr=ws/"slo_narrative.md"
    if narr.exists():
        text=narr.read_text(errors="replace")
        if len(text.split())>=110 and re.search(r"product_2", text) and re.search(r"burn|priorit|first", text, re.I):
            scores["narr"]=1.0
        elif len(text.split())>=60:
            scores["narr"]=0.0
    return scores
```


## LLM Judge Rubric

**SCORING RULE (mandatory):** Default each criterion to **0.25**. Award **0.5** only if the deliverable cites ≥2 exact fixture-specific values (IDs, counts, dates, percentages, paths, or fingerprints from the workspace). Award **0.75** only with those citations plus explicit discussion of a non-obvious constraint, exception, tradeoff, or tie-break. Reserve **1.0** for unusually strong fixture-grounded judgment — never for fluent summaries of structurally correct JSON. Generic or padded prose stays at **0.25** even when automated checks pass.


### Criterion 1: Ops Judgment (Weight: 40%)

**Score 1.0**: Correct dual-SLO reading; remediations follow burn_order.
**Score 0.75**: Good minor gaps.
**Score 0.5**: Generic.
**Score 0.25**: Wrong focus.
**Score 0.0**: Missing.

### Criterion 2: Specificity (Weight: 35%)

**Score 1.0**: Cites rates/paths/shares.
**Score 0.75**: Somewhat specific.
**Score 0.5**: Generic.
**Score 0.25**: Vague.
**Score 0.0**: None.

### Criterion 3: Narrative Quality (Weight: 25%)

**Score 1.0**: SRE-style note.
**Score 0.75**: Good.
**Score 0.5**: Uneven.
**Score 0.25**: Poor.
**Score 0.0**: Unusable.

## Additional Notes

Hardened hybrid task: 70% automated traps, 30% strict LLM quality.
