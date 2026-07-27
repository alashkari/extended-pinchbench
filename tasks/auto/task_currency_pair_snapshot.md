---
id: task_currency_pair_snapshot
name: EUR/USD Currency Snapshot
category: research
grading_type: automated
timeout_seconds: 180
workspace_files: []
---

## Prompt

Look up a current EUR/USD exchange rate snapshot and save it to `eurusd.txt`. Include the currency pair name, a numeric rate, and the date of the quote (or the date you looked it up).

## Expected Behavior

The agent should:

1. Fetch a current EUR/USD rate from a finance site or FX API
2. Create `eurusd.txt` in the workspace
3. Include the pair (EUR/USD or similar), a numeric rate, and a date

Grading checks format only — live rates are not verified.

## Grading Criteria

- [ ] File `eurusd.txt` created
- [ ] File mentions EUR/USD or EURUSD
- [ ] File contains a rate-like number
- [ ] File contains a date pattern
- [ ] File content length is at least 20 characters

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import re

    scores = {
        "file_created": 0.0,
        "pair_present": 0.0,
        "rate_present": 0.0,
        "date_present": 0.0,
        "length_ok": 0.0,
    }

    out_file = Path(workspace_path) / "eurusd.txt"
    if not out_file.exists():
        return scores

    content = out_file.read_text(encoding="utf-8", errors="ignore")
    scores["file_created"] = 1.0

    if re.search(r"EUR\s*/\s*USD|EURUSD|EUR-USD", content, re.IGNORECASE):
        scores["pair_present"] = 1.0

    if re.search(r"\b\d+\.\d{2,}\b", content):
        scores["rate_present"] = 1.0

    date_patterns = [
        r"\d{4}-\d{2}-\d{2}",
        r"\d{1,2}/\d{1,2}/\d{2,4}",
        r"(January|February|March|April|May|June|July|August|September|October|November|December)\s+\d{1,2},?\s+\d{4}",
    ]
    if any(re.search(p, content, re.IGNORECASE) for p in date_patterns):
        scores["date_present"] = 1.0

    if len(re.sub(r"\s+", " ", content).strip()) >= 20:
        scores["length_ok"] = 1.0

    return scores
```
