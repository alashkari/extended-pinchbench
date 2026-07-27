---
id: task_hybrid_fraud_rule_proposal
name: Fraud Rule Proposal From Events
category: analysis
grading_type: hybrid
timeout_seconds: 200
grading_weights:
  automated: 0.7
  llm_judge: 0.3
workspace_files:
  - path: "events.jsonl"
    content: |
      {"txn_id":"t1","user":"u1","amount":20,"country":"US","device_age_days":400,"chargeback":false,"split":"train"}
      {"txn_id":"t2","user":"u2","amount":900,"country":"NG","device_age_days":1,"chargeback":true,"split":"train"}
      {"txn_id":"t3","user":"u3","amount":50,"country":"US","device_age_days":200,"chargeback":false,"split":"train"}
      {"txn_id":"t4","user":"u2","amount":850,"country":"NG","device_age_days":1,"chargeback":true,"split":"train"}
      {"txn_id":"t5","user":"u4","amount":40,"country":"CA","device_age_days":30,"chargeback":false,"split":"train"}
      {"txn_id":"t6","user":"u5","amount":950,"country":"NG","device_age_days":2,"chargeback":true,"split":"train"}
      {"txn_id":"t7","user":"u6","amount":15,"country":"US","device_age_days":10,"chargeback":false,"split":"train"}
      {"txn_id":"t8","user":"u7","amount":120,"country":"GB","device_age_days":5,"chargeback":false,"split":"train"}
      {"txn_id":"t9","user":"u8","amount":880,"country":"NG","device_age_days":1,"chargeback":true,"split":"holdout"}
      {"txn_id":"t10","user":"u9","amount":900,"country":"NG","device_age_days":1,"chargeback":false,"split":"holdout"}
      {"txn_id":"t11","user":"u10","amount":50,"country":"NG","device_age_days":1,"chargeback":false,"split":"holdout"}
      {"txn_id":"t12","user":"u11","amount":920,"country":"NG","device_age_days":2,"chargeback":true,"split":"holdout"}
---

## Prompt

Train a candidate rule on `split=train` only, evaluate precision/recall on `split=holdout`.

Candidate rule form:
amount >= A AND device_age_days <= D AND country in CSET

Choose A,D,CSET to maximize holdout F1 among rules with holdout precision == 1.0.
If multiple, prefer higher recall, then higher A. The intended rule is A=920, D=2, CSET=["NG"] (A=900 now false-positives on t10 which is NG).

Note decoy: t10 is NG + high-amount + new device but NOT chargeback — amount threshold must clear 900.

Write:
1. `fraud_profile.json`:
```json
{
  "n_train": 8,
  "n_holdout": 4,
  "train_chargeback_rate": 0.375,
  "candidate_rule": {"amount_gte": 800, "device_age_days_lte": 2, "country_in": ["NG"]},
  "holdout_precision": 1.0,
  "holdout_recall": 1.0,
  "holdout_f1": 1.0,
  "false_positive_example_avoided": "t10",
  "holdout_tp_ids": ["t9","t12"],
  "holdout_fn_ids": ["t9"],
  "holdout_tn_ids": ["t10","t11"],
  "rule_literal": "amount>=800 AND device_age_days<=2 AND country in [NG]",
  "answer_fingerprint": "deadbeefcafe",
  "f1_str": "1.000",
  "holdout_fp_ids": ["t10"],
  "n_holdout_positives": 1,
  "confusion_csv": "tp:2,fp:1,fn:0,tn:1"
}
```
`holdout_fp_ids` lists holdout transactions the rule flags that are not chargebacks.
`n_holdout_positives` = number of actual chargebacks in the holdout split.
`confusion_csv` = `tp:<n>,fp:<n>,fn:<n>,tn:<n>` in exactly that key order.
The three example values above are wrong — derive them from your rule.
`holdout_tp_ids` must be ["t12"]; also include `holdout_fn_ids`=["t9"]. `holdout_tn_ids`=["t10","t11"].
`rule_literal` must be exactly `amount>=920 AND device_age_days<=2 AND country in [NG]`.
`holdout_f1` must be 0.667 (±0.001). `f1_str` must be the string `"0.667"` (example wrong).
`holdout_tp_ids` must be ["t12"]; also include `holdout_fn_ids`=["t9"]. `holdout_tn_ids`=["t11"] (t10 is an avoided FP, not a TN under the chosen rule — wait: with A=920, t10 is TN because amount 900 < 920).
Actually: under A=920, holdout flags only t12. So tp={t12}, fn={t9}, tn={t10,t11}, fp={}.
2. `fraud_proposal.md` (160–280 words) discussing overfitting and monitoring.

`answer_fingerprint` = first 12 hex of sha256 over UTF-8 as: sha256(str(amount_gte) + "|" + str(device_age_days_lte) + "|" + country + "|" + str(holdout_f1 rounded to 3 decimals) + "|pinch")[:12] (example deadbeefcafe is fake).

## Expected Behavior

Holdout positives t9,t12. Rule A=920 matches only t12 → P=1, R=0.5, F1=2/3. A=900 would FP on t10. t9 is FN.

## Grading Criteria

- [ ] json created
- [ ] n_train 8 n_holdout 4
- [ ] train rate 0.375
- [ ] rule NG + amount>=800 + device<=2
- [ ] holdout precision 1
- [ ] holdout recall 1
- [ ] avoids t10 FP called out
- [ ] proposal mentions holdout/overfit

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import json, re
    scores = {k:0.0 for k in ["json_file","counts","rate","rule","prec","rec","fp","f1","tp_ids","fn_ids","tn_ids","literal","f1_str","proposal","fingerprint",
                              "fp_ids","n_pos","confusion"]}
    ws = Path(workspace_path)
    p = ws / "fraud_profile.json"
    if not p.exists():
        return scores
    scores["json_file"] = 1.0
    try:
        data = json.loads(p.read_text())
    except Exception:
        return scores
    if int(data.get("n_train",0))==8 and int(data.get("n_holdout",0))==4:
        scores["counts"]=1.0
    try:
        if abs(float(data.get("train_chargeback_rate"))-0.375)<=0.001:
            scores["rate"]=1.0
    except Exception:
        pass
    rule=data.get("candidate_rule") or {}
    try:
        ok = float(rule.get("amount_gte",0)) == 920
        ok = ok and float(rule.get("device_age_days_lte",99)) <= 2
        countries=[str(c).upper() for c in (rule.get("country_in") or [])]
        ok = ok and countries==["NG"]
        scores["rule"]=1.0 if ok else 0.0
    except Exception:
        pass
    try:
        if abs(float(data.get("holdout_precision"))-1.0)<=1e-6: scores["prec"]=1.0
        if abs(float(data.get("holdout_recall"))-0.5)<=1e-6: scores["rec"]=1.0
    except Exception:
        pass
    if str(data.get("false_positive_example_avoided","")).lower().strip() in {"t10"}:
        scores["fp"]=1.0
    try:
        if abs(float(data.get("holdout_f1"))-round(2/3,3))<=0.002: scores["f1"]=1.0
    except Exception:
        scores["f1"]=0.0
    if set(str(x) for x in (data.get("holdout_tp_ids") or []))=={"t12"}:
        scores["tp_ids"]=1.0
    if set(str(x) for x in (data.get("holdout_fn_ids") or []))=={"t9"}:
        scores["fn_ids"]=1.0
    if set(str(x) for x in (data.get("holdout_tn_ids") or []))=={"t10","t11"}:
        scores["tn_ids"]=1.0
    if str(data.get("rule_literal") or "") == "amount>=920 AND device_age_days<=2 AND country in [NG]":
        scores["literal"]=1.0
    if str(data.get("f1_str") or "") == "0.667":
        scores["f1_str"]=1.0
    if str(data.get("answer_fingerprint") or "") == "ab18207cd4fc":
        scores["fingerprint"] = 1.0
    fp_ids = data.get("holdout_fp_ids")
    if isinstance(fp_ids, list) and len(fp_ids) == 0:
        scores["fp_ids"] = 1.0
    try:
        if int(data.get("n_holdout_positives")) == 2:
            scores["n_pos"] = 1.0
    except Exception:
        pass
    if str(data.get("confusion_csv") or "").replace(" ", "") == "tp:1,fp:0,fn:1,tn:2":
        scores["confusion"] = 1.0
    prop=ws/"fraud_proposal.md"
    if prop.exists():
        text=prop.read_text(errors="replace")
        if len(text.split())>=130 and re.search(r"holdout|overfit", text, re.I) and re.search(r"false\s*positive|precision|monitor", text, re.I):
            scores["proposal"]=1.0
        elif len(text.split())>=70:
            scores["proposal"]=0.0
    return scores
```


## LLM Judge Rubric

**SCORING RULE (mandatory):** Default each criterion to **0.25**. Award **0.5** only if the deliverable cites ≥2 exact fixture-specific values (IDs, counts, dates, percentages, paths, or fingerprints from the workspace). Award **0.75** only with those citations plus explicit discussion of a non-obvious constraint, exception, tradeoff, or tie-break. Reserve **1.0** for unusually strong fixture-grounded judgment — never for fluent summaries of structurally correct JSON. Generic or padded prose stays at **0.25** even when automated checks pass.


### Criterion 1: Rule Soundness (Weight: 40%)

**Score 1.0**: Holdout-aware rule; explains why country filter avoids US decoy.
**Score 0.75**: Sound minor caveats missing.
**Score 0.5**: Hand-wavy.
**Score 0.25**: Unsound.
**Score 0.0**: Missing.

### Criterion 2: Production Risk (Weight: 35%)

**Score 1.0**: FP risk + concrete monitoring metric.
**Score 0.75**: Adequate.
**Score 0.5**: Generic.
**Score 0.25**: Ignores risk.
**Score 0.0**: None.

### Criterion 3: Proposal Writing (Weight: 25%)

**Score 1.0**: Clear fraud proposal.
**Score 0.75**: Good.
**Score 0.5**: Uneven.
**Score 0.25**: Poor.
**Score 0.0**: Unusable.

## Additional Notes

Hardened hybrid task: 70% automated traps, 30% strict LLM quality.
