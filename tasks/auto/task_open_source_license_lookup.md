---
id: task_open_source_license_lookup
name: Requests SPDX License Lookup
category: research
grading_type: automated
timeout_seconds: 150
workspace_files: []
---

## Prompt

What is the SPDX license identifier for the GitHub repository https://github.com/psf/requests ? Research it and save the answer to `license.txt`.

## Expected Behavior

The agent should:

1. Look up the license for `psf/requests` (GitHub API, repo page, or PyPI metadata)
2. Create `license.txt` in the workspace
3. Report Apache-2.0 (or "Apache 2.0")

## Grading Criteria

- [ ] File `license.txt` created
- [ ] File contains Apache-2.0 or Apache 2.0
- [ ] File mentions requests or psf (optional context)
- [ ] Answer is non-empty

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import re

    scores = {
        "file_created": 0.0,
        "license_correct": 0.0,
        "context_present": 0.0,
        "non_empty": 0.0,
    }

    license_file = Path(workspace_path) / "license.txt"
    if not license_file.exists():
        return scores

    content = license_file.read_text(encoding="utf-8", errors="ignore")
    lowered = content.lower()
    scores["file_created"] = 1.0

    if re.search(r"apache-2\.0|apache\s*2\.0", lowered):
        scores["license_correct"] = 1.0

    if "requests" in lowered or "psf" in lowered:
        scores["context_present"] = 1.0

    if len(content.strip()) >= 5:
        scores["non_empty"] = 1.0

    return scores
```
