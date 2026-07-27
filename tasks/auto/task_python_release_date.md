---
id: task_python_release_date
name: Python 3.12.0 Release Date
category: research
grading_type: automated
timeout_seconds: 120
workspace_files: []
---

## Prompt

When was Python 3.12.0 released? Research the official release date and save the answer to `answer.txt`.

## Expected Behavior

The agent should:

1. Look up the Python 3.12.0 release date from python.org, the PEP, or another reliable source
2. Create `answer.txt` in the workspace
3. Include the date as 2023-10-02, October 2, 2023, or an equivalent readable form

## Grading Criteria

- [ ] File `answer.txt` created
- [ ] File contains the correct release date (2023-10-02 or equivalent)
- [ ] File mentions Python 3.12
- [ ] Answer is non-empty

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import re

    scores = {
        "file_created": 0.0,
        "correct_date": 0.0,
        "mentions_python_312": 0.0,
        "non_empty": 0.0,
    }

    answer_file = Path(workspace_path) / "answer.txt"
    if not answer_file.exists():
        return scores

    content = answer_file.read_text(encoding="utf-8", errors="ignore")
    lowered = content.lower()
    scores["file_created"] = 1.0

    date_ok = bool(
        re.search(r"2023-10-02", content)
        or re.search(r"october\s+2(nd)?(?:,)?\s+2023", lowered)
        or re.search(r"2\s+october\s+2023", lowered)
        or re.search(r"10/2/2023", content)
        or re.search(r"02/10/2023", content)
        or re.search(r"oct\.?\s+2(nd)?(?:,)?\s+2023", lowered)
    )
    if date_ok:
        scores["correct_date"] = 1.0

    if re.search(r"python\s*3\.12", lowered):
        scores["mentions_python_312"] = 1.0

    if len(content.strip()) >= 5:
        scores["non_empty"] = 1.0

    return scores
```
