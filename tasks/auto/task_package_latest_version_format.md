---
id: task_package_latest_version_format
name: httpx Latest Version Format
category: research
grading_type: automated
timeout_seconds: 150
workspace_files: []
---

## Prompt

Look up the current version of the PyPI package `httpx` and save it to `version.txt`. The file should contain a version string (semver-like).

## Expected Behavior

The agent should:

1. Query PyPI (or another package index) for the latest `httpx` release
2. Create `version.txt` in the workspace
3. Write a version resembling `X.Y` or `X.Y.Z` (exact live version is not verified)

## Grading Criteria

- [ ] File `version.txt` created
- [ ] File contains a semver-like pattern (`\d+\.\d+`)
- [ ] File mentions httpx (optional)
- [ ] File is concise (under 200 characters)

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import re

    scores = {
        "file_created": 0.0,
        "semver_like": 0.0,
        "mentions_httpx": 0.0,
        "concise": 0.0,
    }

    version_file = Path(workspace_path) / "version.txt"
    if not version_file.exists():
        return scores

    content = version_file.read_text(encoding="utf-8", errors="ignore")
    scores["file_created"] = 1.0

    if re.search(r"\d+\.\d+", content):
        scores["semver_like"] = 1.0

    if re.search(r"httpx", content, re.IGNORECASE):
        scores["mentions_httpx"] = 1.0

    if 1 <= len(content.strip()) < 200:
        scores["concise"] = 1.0

    return scores
```
