---
id: task_hybrid_tampa_council_brief
name: Tampa Council Meeting Brief
category: meeting_analysis
grading_type: hybrid
timeout_seconds: 260
grading_weights:
  automated: 0.7
  llm_judge: 0.3
workspace_files:
  - source: meetings/2026-04-02-tampa-city-council-transcript.md
    dest: council_transcript.md
---

## Prompt

From `council_transcript.md`:

1. `council_extract.json`:
```json
{
  "approx_motion_mentions": 84,
  "mayor_mention_count": 30,
  "motion_mayor_ratio": 2.5,
  "topics": ["budget","zoning","public_comment"],
  "topics_sorted_csv": "budget,public_comment,zoning",
  "public_comment_mentioned": true,
  "topic_vocabulary_adherence": true,
  "ordinance_mention_count": 12,
  "second_mention_count": 40,
  "counts_csv": "mayor:30,motion:84,ordinance:12,second:40"
  "answer_fingerprint": "deadbeefcafe",
}
```
Counts are case-insensitive whole-word counts of `motion` and `mayor`.
`motion_mayor_ratio` = round(motion/mayor, 1). Example value is wrong — compute from counts.
`topics` must be **exactly** these three labels (any order): `budget`, `zoning`, `public_comment`.
`topics_sorted_csv` = `budget,public_comment,zoning`.

`ordinance_mention_count` and `second_mention_count` are case-insensitive whole-word counts of
`ordinance` and `second` (the example numbers above are placeholders — count them yourself).
`counts_csv` = the four counts as `word:count`, words in ascending alphabetical order, joined by `,`.

2. `council_brief.md` (170–280 words) using only grounded topics. The brief must state the exact
`motion` and `mayor` counts as digits.

`answer_fingerprint` = first 12 hex of sha256 over UTF-8 as: sha256(str(approx_motion_mentions) + "|" + str(mayor_mention_count) + "|" + topics_sorted_csv + "|pinch")[:12] (example deadbeefcafe is fake).

## Expected Behavior

Exact counts motion=84 mayor=30.

## Grading Criteria

- [ ] json created
- [ ] motion count exact
- [ ] mayor count exact
- [ ] topics 3..5
- [ ] topics subset of vocabulary
- [ ] public_comment bool
- [ ] brief file
- [ ] brief grounded

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import json, re
    scores = {k:0.0 for k in ["json_file","motion","mayor","topics_len","vocab","public","ratio","topics_csv","brief_file","brief","fingerprint",
                              "ordinance","second","counts_csv","brief_cites"]}
    try:
        vocab={"budget","zoning","public_comment","transportation","housing","appointments","consent_agenda","ordinances","neighborhoods","utilities"}
        ws=Path(workspace_path)
        p=ws/"council_extract.json"; src=ws/"council_transcript.md"
        if not p.exists(): return scores
        scores["json_file"]=1.0
        data=json.loads(p.read_text())
        text=src.read_text(errors="replace") if src.exists() else ""

        def wc(word):
            return len(re.findall(r"\b%s\b" % word, text, re.I))

        true_m=wc("motion"); true_y=wc("mayor")
        true_o=wc("ordinance"); true_s=wc("second")
        try:
            if int(data.get("approx_motion_mentions"))==true_m: scores["motion"]=1.0
        except Exception: pass
        try:
            if int(data.get("mayor_mention_count"))==true_y: scores["mayor"]=1.0
        except Exception: pass
        try:
            if int(data.get("ordinance_mention_count"))==true_o: scores["ordinance"]=1.0
        except Exception: pass
        try:
            if int(data.get("second_mention_count"))==true_s: scores["second"]=1.0
        except Exception: pass

        expected_counts = ",".join(f"{w}:{c}" for w, c in sorted(
            {"motion": true_m, "mayor": true_y, "ordinance": true_o, "second": true_s}.items()))
        if str(data.get("counts_csv") or "").strip() == expected_counts:
            scores["counts_csv"] = 1.0

        topics=data.get("topics") or []
        if isinstance(topics,list) and 3<=len(topics)<=5: scores["topics_len"]=1.0
        need={"budget","zoning","public_comment"}
        tl=set(str(t).lower() for t in topics)
        if topics and all(str(t).lower() in vocab for t in topics) and need <= tl and len(topics)==3: scores["vocab"]=1.0
        if isinstance(data.get("public_comment_mentioned"), bool): scores["public"]=1.0
        try:
            if true_y and abs(float(data.get("motion_mayor_ratio")) - round(true_m/true_y, 1)) <= 0.05:
                scores["ratio"]=1.0
        except Exception: pass
        topics_l=[str(t).lower() for t in topics]
        if topics_l and str(data.get("topics_sorted_csv") or "").lower()==",".join(sorted(topics_l)):
            scores["topics_csv"]=1.0
        if str(data.get("answer_fingerprint") or "") == "099c764a3a9e":
            scores["fingerprint"] = 1.0

        brief=ws/"council_brief.md"
        if brief.exists():
            scores["brief_file"]=1.0
            bt=brief.read_text(errors="replace")
            if len(bt.split())>=130 and re.search(r"council|motion|public|mayor", bt, re.I):
                scores["brief"]=1.0
            if re.search(r"\b%d\b" % true_m, bt) and re.search(r"\b%d\b" % true_y, bt):
                scores["brief_cites"]=1.0
    except Exception:
        pass
    return scores
```


## LLM Judge Rubric

**SCORING RULE (mandatory):** Default each criterion to **0.25**. Award **0.5** only if the deliverable cites ≥2 exact fixture-specific values (IDs, counts, dates, percentages, paths, or fingerprints from the workspace). Award **0.75** only with those citations plus explicit discussion of a non-obvious constraint, exception, tradeoff, or tie-break. Reserve **1.0** for unusually strong fixture-grounded judgment — never for fluent summaries of structurally correct JSON. Generic or padded prose stays at **0.25** even when automated checks pass.


### Criterion 1: Grounding (Weight: 40%)

**Score 1.0**: No hallucinated agenda; topics from vocabulary.
**Score 0.75**: Mostly grounded.
**Score 0.5**: Some unsupported.
**Score 0.25**: Hallucination.
**Score 0.0**: Missing.

### Criterion 2: Civic Briefing Quality (Weight: 35%)

**Score 1.0**: Useful civic briefing.
**Score 0.75**: Useful minor gaps.
**Score 0.5**: Partial.
**Score 0.25**: Not useful.
**Score 0.0**: None.

### Criterion 3: Clarity (Weight: 25%)

**Score 1.0**: Clear civic prose.
**Score 0.75**: Good.
**Score 0.5**: Uneven.
**Score 0.25**: Poor.
**Score 0.0**: Unusable.

## Additional Notes

Hardened hybrid task: 70% automated traps, 30% strict LLM quality.
