---
id: task_integration_github_pr_summary
name: GitHub PR Summary From Fixture
category: integrations
grading_type: automated
timeout_seconds: 180
workspace_files:
  - path: "pr.json"
    content: |
      {
        "number": 847,
        "title": "Fix flaky webhook retry backoff",
        "user": {"login": "devon-lee"},
        "state": "open",
        "files": [
          {"filename": "src/webhooks/retry.py", "status": "modified"},
          {"filename": "tests/test_retry.py", "status": "modified"},
          {"filename": "docs/webhooks.md", "status": "modified"}
        ],
        "additions": 42,
        "deletions": 11
      }
---

## Prompt

Read the GitHub pull request fixture at `pr.json`. Write `summary.md` that clearly states:

- PR number
- title
- author (the user login)
- files_changed count (number of entries in `files`)
- state

Use those labels or equivalent clear wording so each fact is easy to find.

## Expected Behavior

The agent extracts number `847`, title `Fix flaky webhook retry backoff`, author `devon-lee`, files_changed `3`, and state `open` into `summary.md`.

## Grading Criteria

- [ ] summary.md exists
- [ ] Number 847 present
- [ ] Title present
- [ ] Author devon-lee present
- [ ] files_changed count 3 present
- [ ] State open present

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import re

    scores = {
        "file_created": 0.0,
        "number": 0.0,
        "title": 0.0,
        "author": 0.0,
        "files_changed": 0.0,
        "state": 0.0,
    }
    workspace = Path(workspace_path)
    path = workspace / "summary.md"
    if not path.exists():
        return scores

    scores["file_created"] = 1.0
    text = path.read_text(encoding="utf-8", errors="replace")
    lowered = text.lower()

    if re.search(r"\b847\b", text):
        scores["number"] = 1.0

    if "fix flaky webhook retry backoff" in lowered:
        scores["title"] = 1.0

    if "devon-lee" in lowered:
        scores["author"] = 1.0

    if re.search(r"files[_\s-]*changed[^\n\d]*\b3\b|\b3\b[^\n]*(files|changed)", lowered) or re.search(
        r"\b3\s+files?\b", lowered
    ):
        scores["files_changed"] = 1.0
    elif re.search(r"\b3\b", text) and ("file" in lowered or "changed" in lowered):
        scores["files_changed"] = 1.0

    if re.search(r"\bopen\b", lowered):
        scores["state"] = 1.0

    return scores
```

## Additional Notes

- Fixture-only PR JSON; no live GitHub or `gh` CLI required.
