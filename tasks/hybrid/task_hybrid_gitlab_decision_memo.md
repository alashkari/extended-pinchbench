---
id: task_hybrid_gitlab_decision_memo
name: GitLab Meeting Decision Memo
category: meeting_analysis
grading_type: hybrid
timeout_seconds: 260
grading_weights:
  automated: 0.7
  llm_judge: 0.3
workspace_files:
  - source: meetings/2021-06-28-gitlab-product-marketing-meeting.md
    dest: meeting_transcript.md
---

## Prompt

From `meeting_transcript.md` create:

1. `decisions.json`:
```json
{
  "meeting_date": "2021-06-28",
  "decisions": [{"decision":"...","owner_hint":"...","evidence_quote":"..."}],
  "deadlines": [{"item":"...","when":"...","evidence_quote":"..."}],
  "messaging_tagline": "more speed, less risk",
  "events_mentioned": ["re:Invent","Google Next","KubeCon"],
  "decision_count": 3,
  "deadline_count": 1,
  "events_normalized_csv": "kubecon,google next,re:invent"
}
```
Require >=3 decisions and >=1 deadline. `decision_count`/`deadline_count` must equal array lengths.
`events_normalized_csv` = lowercased event names sorted ascending, comma-separated (normalize `re:Invent`→`re:invent`). Example sort is wrong.
Each decision/deadline MUST include a short `evidence_quote` copied from the transcript (substring match). Do not invent owners.

2. `decision_memo.md` (170–280 words).

## Expected Behavior

Grounded extraction with quotes.

## Grading Criteria

- [ ] json created
- [ ] date 2021-06-28
- [ ] >=3 decisions with quotes
- [ ] >=1 deadline with quote
- [ ] tagline speed/risk
- [ ] events include >=2 of reinvent/kubecon/google next
- [ ] quotes found in transcript
- [ ] memo substantive

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import json, re
    scores = {k:0.0 for k in ["json_file","date","n_dec","deadline","tagline","events","quotes","counts_match","events_csv","memo"]}
    try:
        ws = Path(workspace_path)
        path = ws / "decisions.json"
        src = ws / "meeting_transcript.md"
        if not path.exists():
            return scores
        scores["json_file"]=1.0
        data=json.loads(path.read_text())
        text = src.read_text(errors="replace") if src.exists() else ""
        if "2021-06-28" in str(data.get("meeting_date","")): scores["date"]=1.0
        decisions=data.get("decisions") or []
        if isinstance(decisions,list) and len(decisions)>=3: scores["n_dec"]=1.0
        deadlines=data.get("deadlines") or []
        if isinstance(deadlines,list) and deadlines: scores["deadline"]=1.0
        tag=str(data.get("messaging_tagline","")).lower()
        if "speed" in tag and "risk" in tag: scores["tagline"]=1.0
        blob=json.dumps(data).lower()
        ev=sum(1 for ptn in [r"re:?\s*invent", r"kubecon", r"google\s*next"] if re.search(ptn, blob))
        if ev>=2: scores["events"]=1.0
        quotes=[]
        for item in list(decisions)+list(deadlines):
            if isinstance(item,dict) and item.get("evidence_quote"):
                quotes.append(str(item.get("evidence_quote") or "").strip())
        if quotes and text:
            ok=sum(1 for q in quotes if len(q)>=8 and q.lower() in text.lower())
            if ok==len(quotes) and ok>=3: scores["quotes"]=1.0
        try:
            if int(data.get("decision_count"))==len(decisions) and int(data.get("deadline_count"))==len(deadlines):
                scores["counts_match"]=1.0
        except Exception:
            pass
        evs=[str(x).lower().strip() for x in (data.get("events_mentioned") or [])]
        expect=",".join(sorted(evs))
        if str(data.get("events_normalized_csv") or "").lower()==expect and len(evs)>=2:
            scores["events_csv"]=1.0
        memo=ws/"decision_memo.md"
        if memo.exists():
            mt=memo.read_text(errors="replace")
            if len(mt.split())>=130 and re.search(r"decision|deadline|tagline|event", mt, re.I):
                scores["memo"]=1.0
    except Exception:
        pass
    return scores
```


## LLM Judge Rubric

**SCORING RULE (mandatory):** Default each criterion to **0.25**. Award **0.5** only if the deliverable cites ≥2 exact fixture-specific values (IDs, counts, dates, percentages, paths, or fingerprints from the workspace). Award **0.75** only with those citations plus explicit discussion of a non-obvious constraint, exception, tradeoff, or tie-break. Reserve **1.0** for unusually strong fixture-grounded judgment — never for fluent summaries of structurally correct JSON. Generic or padded prose stays at **0.25** even when automated checks pass.


### Criterion 1: Decision Capture (Weight: 40%)

**Score 1.0**: Accurate decisions with real quotes; no invented owners.
**Score 0.75**: Mostly accurate.
**Score 0.5**: Mixed.
**Score 0.25**: Errors/hallucination.
**Score 0.0**: Missing.

### Criterion 2: Usefulness (Weight: 35%)

**Score 1.0**: Absentee can act from memo.
**Score 0.75**: Mostly.
**Score 0.5**: Needs transcript.
**Score 0.25**: Not useful.
**Score 0.0**: None.

### Criterion 3: Writing Quality (Weight: 25%)

**Score 1.0**: Crisp PMM memo.
**Score 0.75**: Good.
**Score 0.5**: Uneven.
**Score 0.25**: Poor.
**Score 0.0**: Unusable.

## Additional Notes

Hardened hybrid task: 70% automated traps, 30% strict LLM quality.
