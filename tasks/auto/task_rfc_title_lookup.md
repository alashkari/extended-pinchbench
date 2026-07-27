---
id: task_rfc_title_lookup
name: RFC 791 Title Lookup
category: research
grading_type: automated
timeout_seconds: 120
workspace_files: []
---

## Prompt

What is the full title of RFC 791? Research it and save the answer to `answer.txt`.

## Expected Behavior

The agent should:

1. Look up RFC 791 on rfc-editor.org, IETF, or another reliable source
2. Create `answer.txt` in the workspace
3. Include the full title, which contains "Internet Protocol"

## Grading Criteria

- [ ] File `answer.txt` created
- [ ] File contains "Internet Protocol" (case insensitive)
- [ ] File mentions RFC 791
- [ ] Answer is non-empty

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import re

    scores = {
        "file_created": 0.0,
        "title_correct": 0.0,
        "rfc_mentioned": 0.0,
        "non_empty": 0.0,
    }

    answer_file = Path(workspace_path) / "answer.txt"
    if not answer_file.exists():
        return scores

    content = answer_file.read_text(encoding="utf-8", errors="ignore")
    lowered = content.lower()
    scores["file_created"] = 1.0

    if "internet protocol" in lowered:
        scores["title_correct"] = 1.0

    if re.search(r"rfc\s*791", lowered):
        scores["rfc_mentioned"] = 1.0

    if len(content.strip()) >= 10:
        scores["non_empty"] = 1.0

    return scores
```
