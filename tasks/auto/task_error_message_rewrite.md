---
id: task_error_message_rewrite
name: Error Message Rewrite
category: writing
grading_type: automated
timeout_seconds: 90
workspace_files:
  - path: "raw_error.txt"
    content: |
      Traceback (most recent call last):
        File "/app/services/billing/invoice.py", line 142, in generate_invoice
          pdf = renderer.render(template_path, context)
        File "/app/lib/pdf/renderer.py", line 58, in render
          return self._engine.convert(html)
        File "/usr/local/lib/python3.11/site-packages/weasyprint/__init__.py", line 201, in write_pdf
          raise RuntimeError("Failed to write PDF: disk quota exceeded")
      RuntimeError: Failed to write PDF: disk quota exceeded

      Request ID: req_9f3a2c
---

# Error Message Rewrite

## Prompt

Read the stacktrace in `raw_error.txt` and rewrite it as a short, user-facing error message. Save the result to `user_error.txt`.

Requirements:

1. At most **40 words**.
2. Include either `try again` or `contact support` (or both).
3. Do **not** include traceback text, `File "` paths, or raw exception dump lines.
4. Be clear and helpful for a non-technical user.

## Expected Behavior

The agent should produce a brief plain-language message explaining that invoice/PDF generation failed (or a similar user-facing summary), suggest trying again or contacting support, and omit stacktrace details.

## Grading Criteria

- [ ] File `user_error.txt` is created
- [ ] Word count is ≤ 40
- [ ] Contains "try again" or "contact support"
- [ ] Does not contain traceback / File path markers

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import re

    scores = {
        "file_created": 0.0,
        "word_count_ok": 0.0,
        "has_recovery_phrase": 0.0,
        "no_traceback": 0.0,
    }

    workspace = Path(workspace_path)
    path = workspace / "user_error.txt"
    if not path.exists():
        return scores

    scores["file_created"] = 1.0
    content = path.read_text(encoding="utf-8", errors="replace").strip()
    words = re.findall(r"\b\w+\b", content)
    word_count = len(words)

    if word_count <= 40 and word_count > 0:
        scores["word_count_ok"] = 1.0
    elif word_count <= 50:
        scores["word_count_ok"] = 0.5

    lower = content.lower()
    if "try again" in lower or "contact support" in lower:
        scores["has_recovery_phrase"] = 1.0

    traceback_markers = [
        r"traceback\s*\(most recent call last\)",
        r'(?i)file\s+"[^"]+"',
        r"(?i)file\s+'/[^']+'",
        r"/app/",
        r"/usr/local/",
        r"weasyprint",
        r"line\s+\d+",
    ]
    if not any(re.search(p, content) for p in traceback_markers):
        scores["no_traceback"] = 1.0

    return scores
```

## Additional Notes

- Length and keyword/forbidden-content checks only; tone is not LLM-judged.
