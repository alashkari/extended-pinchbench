---
id: task_hybrid_stock_volatility_brief
name: Apple Stock Volatility Brief
category: csv_analysis
grading_type: hybrid
timeout_seconds: 260
grading_weights:
  automated: 0.7
  llm_judge: 0.3
workspace_files:
  - source: csvs/apple_stock_2014.csv
    dest: apple_stock_2014.csv
---

## Prompt

Using `apple_stock_2014.csv` (`AAPL_x` date, `AAPL_y` adj close):

Daily return_pct = 100*(close_t/close_{t-1}-1).

Also compute winsorized returns at empirical 1st/99th percentiles (clamp), then stddev of winsorized series (population stddev).

Write `volatility.json`:
```json
{
  "trading_days": N,
  "n_returns": N-1,
  "first_date": "YYYY-MM-DD",
  "last_date": "YYYY-MM-DD",
  "avg_daily_return_pct": 0.0,
  "stddev_daily_return_pct": 0.0,
  "winsor_stddev_daily_return_pct": 0.0,
  "best_day": {"date":"YYYY-MM-DD","return_pct":0.0},
  "worst_day": {"date":"YYYY-MM-DD","return_pct":0.0},
  "date_span_days": 365,
  "winsor_lo_pct": 0.0,
  "winsor_hi_pct": 0.0
}
```
Round rates to 3 decimals. Use the CSV's actual last date (do not assume Dec 31).
`date_span_days` = (last_date - first_date).days (not inclusive of both ends as +1). Example 365 is wrong — compute from actual dates.
`winsor_lo_pct`/`winsor_hi_pct` = the empirical 1st/99th percentile clamp values used, rounded to 3 decimals.

Write `volatility_brief.md` (160–260 words) comparing raw vs winsorized vol.

## Expected Behavior

first 2014-01-02 last 2014-12-12; 240 trading days; best 2014-04-24 ~7.398; worst 2014-01-28 ~-7.507.

## Grading Criteria

- [ ] json created
- [ ] first_date 2014-01-02
- [ ] last_date 2014-12-12
- [ ] trading_days 240
- [ ] best date/return correct
- [ ] worst date/return correct
- [ ] winsor stddev present ~1.33
- [ ] brief compares winsor vs raw

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import json, csv, statistics, re
    scores = {k:0.0 for k in ["json_file","first","last","days","nret","best","worst","winsor","span","winsor_bounds","brief"]}
    ws = Path(workspace_path)
    path = ws / "volatility.json"
    csv_path = ws / "apple_stock_2014.csv"
    if not path.exists():
        return scores
    scores["json_file"] = 1.0
    try:
        data = json.loads(path.read_text())
    except Exception:
        return scores
    if str(data.get("first_date","")).startswith("2014-01-02"):
        scores["first"] = 1.0
    if str(data.get("last_date","")).startswith("2014-12-12"):
        scores["last"] = 1.0
    try:
        if int(data.get("trading_days")) == 240:
            scores["days"] = 1.0
        if int(data.get("n_returns", -1)) == 239:
            scores["nret"] = 1.0
        elif abs(int(data.get("trading_days"))-240) <= 5:
            scores["days"] = 0.0
    except Exception:
        pass
    if csv_path.exists():
        rows=list(csv.DictReader(csv_path.open()))
        closes=[float(r["AAPL_y"]) for r in rows]; dates=[r["AAPL_x"] for r in rows]
        rets=[100.0*(closes[i]/closes[i-1]-1.0) for i in range(1,len(closes))]
        bi=max(range(len(rets)), key=lambda i: rets[i]); wi=min(range(len(rets)), key=lambda i: rets[i])
        xs=sorted(rets); lo=xs[max(0,int(0.01*len(xs)))]; hi=xs[min(len(xs)-1,int(0.99*len(xs)))]
        w=[min(hi,max(lo,r)) for r in rets]; wsd=statistics.pstdev(w)
        best=data.get("best_day") or {}; worst=data.get("worst_day") or {}
        try:
            if str(best.get("date"))==dates[bi+1] and abs(float(best.get("return_pct"))-rets[bi])<=0.05:
                scores["best"]=1.0
            elif abs(float(best.get("return_pct"))-rets[bi])<=0.2:
                scores["best"]=0.0
            if str(worst.get("date"))==dates[wi+1] and abs(float(worst.get("return_pct"))-rets[wi])<=0.05:
                scores["worst"]=1.0
            elif abs(float(worst.get("return_pct"))-rets[wi])<=0.2:
                scores["worst"]=0.0
            if abs(float(data.get("winsor_stddev_daily_return_pct"))-wsd)<=0.05:
                scores["winsor"]=1.0
            elif 1.0 <= float(data.get("winsor_stddev_daily_return_pct")) <= 1.6:
                scores["winsor"]=0.0
        except Exception:
            pass
        try:
            if int(data.get("date_span_days")) == 344:
                scores["span"] = 1.0
        except Exception:
            pass
        try:
            if abs(float(data.get("winsor_lo_pct"))-round(lo,3))<=0.002 and abs(float(data.get("winsor_hi_pct"))-round(hi,3))<=0.002:
                scores["winsor_bounds"] = 1.0
        except Exception:
            pass
    brief=ws/"volatility_brief.md"
    if brief.exists():
        text=brief.read_text(errors="replace")
        if len(text.split())>=120 and re.search(r"winsor", text, re.I) and re.search(r"volatil|risk|std", text, re.I):
            scores["brief"]=1.0
        elif len(text.split())>=60:
            scores["brief"]=0.0
    return scores
```


## LLM Judge Rubric

**SCORING RULE (mandatory):** Default each criterion to **0.25**. Award **0.5** only if the deliverable cites ≥2 exact fixture-specific values (IDs, counts, dates, percentages, paths, or fingerprints from the workspace). Award **0.75** only with those citations plus explicit discussion of a non-obvious constraint, exception, tradeoff, or tie-break. Reserve **1.0** for unusually strong fixture-grounded judgment — never for fluent summaries of structurally correct JSON. Generic or padded prose stays at **0.25** even when automated checks pass.


### Criterion 1: Quantitative Interpretation (Weight: 40%)

**Score 1.0**: Correctly interprets raw vs winsorized volatility.
**Score 0.75**: Mostly correct.
**Score 0.5**: Superficial.
**Score 0.25**: Misinterprets.
**Score 0.0**: Missing.

### Criterion 2: Decision Relevance (Weight: 35%)

**Score 1.0**: Risk implications without overclaim.
**Score 0.75**: Relevant.
**Score 0.5**: Weak link.
**Score 0.25**: Irrelevant.
**Score 0.0**: None.

### Criterion 3: Writing Quality (Weight: 25%)

**Score 1.0**: Polished risk brief.
**Score 0.75**: Good.
**Score 0.5**: Uneven.
**Score 0.25**: Poor.
**Score 0.0**: Unusable.

## Additional Notes

Hardened hybrid task: 70% automated traps, 30% strict LLM quality.
