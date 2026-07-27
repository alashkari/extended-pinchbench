---
id: task_hybrid_cohort_retention_memo
name: Cohort Retention Analysis Memo
category: analysis
grading_type: hybrid
timeout_seconds: 200
grading_weights:
  automated: 0.7
  llm_judge: 0.3
workspace_files:
  - path: "cohorts.csv"
    content: |
      cohort_month,users,d30_retained,d90_retained,revenue_d90,notes
      2026-01,1000,420,310,52000,baseline
      2026-02,1100,451,330,54000,baseline
      2026-03,1200,504,348,56100,baseline
      2026-04,1250,475,300,51000,suspect_regression
      2026-05,1300,572,420,62400,recovery
      2026-06,800,560,400,48000,SEASONAL_PROMO_DISTRACTOR_small_n
---

## Prompt

Analyze `cohorts.csv`.

Ignore rows where notes contains `DISTRACTOR` when choosing best/worst d90 cohorts (still include them in rates maps if you want, but best/worst must exclude distractors).

d90_rate = round(d90_retained/users, 2)
d30_rate similarly.
revenue_per_user = round(revenue_d90/users, 1)
mom_d90_delta for month M = d90_rate(M) - d90_rate(M-1) using non-distractor adjacent months only where possible.

Tie-break for best d90: higher revenue_d90 wins.

Write:
1. `retention_stats.json`:
```json
{
  "d30_rates": {"2026-01": 0.42},
  "d90_rates": {"2026-01": 0.31},
  "worst_d90_cohort": "2026-04",
  "best_d90_cohort": "2026-05",
  "d90_revenue_per_user": {"2026-01": 52.0},
  "mom_d90_delta": {"2026-04": -0.05, "2026-05": 0.06},
  "excluded_distractors": ["2026-06"],
  "d90_rates_csv": "2026-01:0.31,2026-02:0.30",
  "worst_mom_month": "2026-05",
  "spread_x100": 1,
  "n_scored_cohorts": 6
}
```
All six months must appear in `d30_rates`, `d90_rates`, and `d90_revenue_per_user`.

`d90_rates_csv` = every month ascending as `YYYY-MM:rate`, joined by `,`, rates at 2 decimals (the example above is truncated and has a wrong February value — do not copy it).
`worst_mom_month` = the month with the most negative `mom_d90_delta`.
`spread_x100` = round(100 × (highest non-distractor d90_rate − lowest non-distractor d90_rate)).
`n_scored_cohorts` = number of cohorts eligible for best/worst after excluding distractors (the example 6 is wrong).

2. `retention_memo.md` (170–280 words) diagnosing April and why June must not be treated as best.

## Expected Behavior

April worst 0.24; May best 0.32 among non-distractors; June 0.50 is a distractor and is excluded from best/worst.

## Grading Criteria

- [ ] json created
- [ ] jan d30 0.42 d90 0.31
- [ ] worst 2026-04
- [ ] best 2026-05 not 2026-06
- [ ] excluded includes 2026-06
- [ ] mom delta april negative
- [ ] rev per user jan 52.0
- [ ] memo warns about distractor

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import json, re
    scores = {k:0.0 for k in ["json_file","jan","worst","best","excluded","mom","rev","memo",
                              "all_d90","all_rpu","rates_csv","worst_mom","spread","n_scored"]}
    try:
        ws = Path(workspace_path)
        p = ws / "retention_stats.json"
        if not p.exists():
            return scores
        scores["json_file"] = 1.0
        data = json.loads(p.read_text())

        def near(x, t, tol=0.011):
            try: return abs(float(x)-t) <= tol
            except Exception: return False

        d30 = data.get("d30_rates") or {}
        d90 = data.get("d90_rates") or {}
        rpu = data.get("d90_revenue_per_user") or {}

        if near(d30.get("2026-01"), 0.42) and near(d90.get("2026-01"), 0.31):
            scores["jan"] = 1.0
        if str(data.get("worst_d90_cohort", "")).startswith("2026-04"):
            scores["worst"] = 1.0
        if str(data.get("best_d90_cohort", "")).startswith("2026-05"):
            scores["best"] = 1.0
        excl = [str(x) for x in (data.get("excluded_distractors") or [])]
        if any("2026-06" in x for x in excl):
            scores["excluded"] = 1.0
        mom = data.get("mom_d90_delta") or {}
        try:
            if float(mom.get("2026-04")) < 0:
                scores["mom"] = 1.0
        except Exception:
            pass
        if near(rpu.get("2026-01"), 52.0, 0.15):
            scores["rev"] = 1.0

        true_d90 = {"2026-01":0.31,"2026-02":0.30,"2026-03":0.29,
                    "2026-04":0.24,"2026-05":0.32,"2026-06":0.50}
        true_rpu = {"2026-01":52.0,"2026-02":49.1,"2026-03":46.8,
                    "2026-04":40.8,"2026-05":48.0,"2026-06":60.0}
        if all(near(d90.get(m), v) for m, v in true_d90.items()):
            scores["all_d90"] = 1.0
        if all(near(rpu.get(m), v, 0.15) for m, v in true_rpu.items()):
            scores["all_rpu"] = 1.0

        expected_csv = ",".join(f"{m}:{true_d90[m]:.2f}" for m in sorted(true_d90))
        if str(data.get("d90_rates_csv") or "").strip() == expected_csv:
            scores["rates_csv"] = 1.0
        if str(data.get("worst_mom_month") or "").startswith("2026-04"):
            scores["worst_mom"] = 1.0
        try:
            if int(data.get("spread_x100")) == 8:
                scores["spread"] = 1.0
        except Exception:
            pass
        try:
            if int(data.get("n_scored_cohorts")) == 5:
                scores["n_scored"] = 1.0
        except Exception:
            pass

        memo = ws / "retention_memo.md"
        if memo.exists():
            text = memo.read_text(errors="replace")
            if (len(text.split()) >= 130 and re.search(r"april|2026-04", text, re.I)
                    and re.search(r"distract|seasonal|promo|june|2026-06", text, re.I)):
                scores["memo"] = 1.0
    except Exception:
        pass
    return scores
```


## LLM Judge Rubric

**SCORING RULE (mandatory):** Default each criterion to **0.25**. Award **0.5** only if the deliverable cites ≥2 exact fixture-specific values (IDs, counts, dates, percentages, paths, or fingerprints from the workspace). Award **0.75** only with those citations plus explicit discussion of a non-obvious constraint, exception, tradeoff, or tie-break. Reserve **1.0** for unusually strong fixture-grounded judgment — never for fluent summaries of structurally correct JSON. Generic or padded prose stays at **0.25** even when automated checks pass.


### Criterion 1: Analytical Insight (Weight: 40%)

**Score 1.0**: Diagnoses April dip and explicitly rejects June distractor.
**Score 0.75**: Good with minor gap.
**Score 0.5**: Descriptive.
**Score 0.25**: Weak.
**Score 0.0**: Missing.

### Criterion 2: Actionable Recommendations (Weight: 35%)

**Score 1.0**: Two concrete follow-ups tied to April regression.
**Score 0.75**: Actionable slightly generic.
**Score 0.5**: Vague.
**Score 0.25**: Useless.
**Score 0.0**: None.

### Criterion 3: Memo Quality (Weight: 25%)

**Score 1.0**: Crisp analytics memo.
**Score 0.75**: Good.
**Score 0.5**: Uneven.
**Score 0.25**: Poor.
**Score 0.0**: Unusable.

## Additional Notes

Hardened hybrid task: 70% automated traps, 30% strict LLM quality.
