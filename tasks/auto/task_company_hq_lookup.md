---
id: task_company_hq_lookup
name: Stripe Headquarters Lookup
category: research
grading_type: automated
timeout_seconds: 120
workspace_files: []
---

## Prompt

Where is Stripe Inc headquartered? Research the answer and save it to `answer.txt`.

## Expected Behavior

The agent should:

1. Look up Stripe Inc's headquarters location from a reliable source
2. Create `answer.txt` in the workspace
3. State that the company is headquartered in San Francisco (California / United States is fine as additional context)

## Grading Criteria

- [ ] File `answer.txt` created
- [ ] File mentions San Francisco
- [ ] File mentions California or US/United States (optional bonus)
- [ ] Answer is non-empty and readable

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import re

    scores = {
        "file_created": 0.0,
        "san_francisco": 0.0,
        "california_or_us": 0.0,
        "readable": 0.0,
    }

    answer_file = Path(workspace_path) / "answer.txt"
    if not answer_file.exists():
        return scores

    content = answer_file.read_text(encoding="utf-8", errors="ignore")
    lowered = content.lower()
    scores["file_created"] = 1.0

    if "san francisco" in lowered:
        scores["san_francisco"] = 1.0

    if (
        "california" in lowered
        or "united states" in lowered
        or re.search(r"\b(us|u\.s\.|usa|u\.s\.a\.)\b", lowered)
    ):
        scores["california_or_us"] = 1.0

    if len(content.strip()) >= 10:
        scores["readable"] = 1.0

    return scores
```