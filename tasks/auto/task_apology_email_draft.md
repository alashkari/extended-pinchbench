---
id: task_apology_email_draft
name: Apology Email Draft
category: writing
grading_type: automated
timeout_seconds: 120
workspace_files: []
---

# Apology Email Draft

## Prompt

Draft a professional apology email to a customer about a delayed shipment for order **ORD-10042**. Save the email to `apology_email.txt`.

Requirements:

1. Include a `Subject:` line.
2. Clearly apologize for the delayed shipment.
3. Mention order number `ORD-10042`.
4. Do **not** mention "AI" or "language model" anywhere in the email.
5. Keep the tone professional and customer-facing.

## Expected Behavior

The agent should create `apology_email.txt` containing a complete customer apology email with:

- A Subject line acknowledging the delay or order issue
- Apology language (e.g., apologize, sorry, regret)
- Explicit reference to order ORD-10042
- No self-referential AI / language-model wording

## Grading Criteria

- [ ] File `apology_email.txt` is created
- [ ] Contains a Subject: line
- [ ] Contains apology language
- [ ] Mentions order number ORD-10042
- [ ] Does not contain "AI" or "language model"

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import re

    scores = {
        "file_created": 0.0,
        "has_subject": 0.0,
        "has_apology": 0.0,
        "has_order_number": 0.0,
        "no_forbidden_terms": 0.0,
    }

    workspace = Path(workspace_path)
    path = workspace / "apology_email.txt"
    if not path.exists():
        return scores

    scores["file_created"] = 1.0
    content = path.read_text(encoding="utf-8", errors="replace")
    lower = content.lower()

    if re.search(r"(?im)^\s*subject\s*:", content):
        scores["has_subject"] = 1.0

    apology_patterns = [
        r"\bapolog",
        r"\bsorry\b",
        r"\bregret\b",
        r"\bwe\s+sincerely\b",
    ]
    if any(re.search(p, lower) for p in apology_patterns):
        scores["has_apology"] = 1.0

    if re.search(r"\bORD-10042\b", content):
        scores["has_order_number"] = 1.0

    forbidden = re.search(r"\bai\b|language\s+model", lower)
    if not forbidden:
        scores["no_forbidden_terms"] = 1.0

    return scores
```

## Additional Notes

- Grades structure (Subject), required keywords (apology + order number), and forbidden phrasing only.
- No LLM judge is used.
