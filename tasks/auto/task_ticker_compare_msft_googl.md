---
id: task_ticker_compare_msft_googl
name: MSFT vs GOOGL Ticker Compare
category: research
grading_type: automated
timeout_seconds: 180
workspace_files: []
---

## Prompt

Research the current stock prices of Microsoft (MSFT) and Alphabet (GOOGL). Save a short comparison to `compare_report.txt` that includes both ticker symbols, a numeric price for each, and the date of the quote (or the date you looked it up).

## Expected Behavior

The agent should:

1. Look up current (or latest available) prices for MSFT and GOOGL via web search or a financial data source
2. Create `compare_report.txt` in the workspace
3. Include both tickers, numeric prices, and a date reference
4. Write enough content for a readable mini-report (at least ~80 characters)

Live prices are not verified by grading — only structure and presence of required fields.

## Grading Criteria

- [ ] File `compare_report.txt` created
- [ ] File contains "MSFT"
- [ ] File contains "GOOGL"
- [ ] File contains at least two price-like numbers
- [ ] File contains a date pattern
- [ ] File content length is at least 80 characters

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import re

    scores = {
        "file_created": 0.0,
        "msft_present": 0.0,
        "googl_present": 0.0,
        "two_prices_present": 0.0,
        "date_present": 0.0,
        "length_ok": 0.0,
    }

    report_file = Path(workspace_path) / "compare_report.txt"
    if not report_file.exists():
        return scores

    content = report_file.read_text(encoding="utf-8", errors="ignore")
    scores["file_created"] = 1.0

    if re.search(r"\bMSFT\b", content, re.IGNORECASE):
        scores["msft_present"] = 1.0
    if re.search(r"\bGOOGL\b", content, re.IGNORECASE):
        scores["googl_present"] = 1.0

    price_matches = re.findall(
        r"\$\s*\d+(?:\.\d+)?|\b\d+\.\d{2}\b",
        content,
    )
    if len(price_matches) >= 2:
        scores["two_prices_present"] = 1.0

    date_patterns = [
        r"\d{4}-\d{2}-\d{2}",
        r"\d{1,2}/\d{1,2}/\d{2,4}",
        r"(January|February|March|April|May|June|July|August|September|October|November|December)\s+\d{1,2},?\s+\d{4}",
        r"\d{1,2}\s+(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)[a-z]*\s+\d{4}",
    ]
    if any(re.search(p, content, re.IGNORECASE) for p in date_patterns):
        scores["date_present"] = 1.0

    if len(re.sub(r"\s+", " ", content).strip()) >= 80:
        scores["length_ok"] = 1.0

    return scores
```
