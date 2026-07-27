---
id: task_changelog_from_commits
name: Changelog From Commits
category: writing
grading_type: automated
timeout_seconds: 120
workspace_files:
  - path: "commits.txt"
    content: |
      feat: add dark mode toggle to settings page
      fix: resolve null pointer in checkout flow
      chore: bump eslint to v9
      feat: support CSV export for reports
      fix: correct timezone offset on calendar events
      refactor: extract shared auth middleware
      docs: document webhook retry policy
---

# Changelog From Commits

## Prompt

Read `commits.txt`, which contains conventional commit messages (one per line). Write a `CHANGELOG.md` that groups the user-facing changes under these exact section headers:

- `## Added`
- `## Fixed`
- `## Changed`

Include the relevant commit subject text (without the type prefix) as entries under the correct section. You may skip chore/docs commits if they are not user-facing, but every `feat`, `fix`, and `refactor` commit must appear under Added, Fixed, or Changed respectively.

## Expected Behavior

The agent should produce `CHANGELOG.md` with:

- `## Added` containing dark mode toggle and CSV export entries
- `## Fixed` containing null pointer / checkout and timezone offset entries
- `## Changed` containing the auth middleware refactor entry

Chore and docs commits may be omitted.

## Grading Criteria

- [ ] File `CHANGELOG.md` is created
- [ ] Has `## Added` section
- [ ] Has `## Fixed` section
- [ ] Has `## Changed` section
- [ ] Dark mode / CSV export entries appear under Added
- [ ] Checkout / timezone fix entries appear under Fixed
- [ ] Auth middleware entry appears under Changed

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import re

    scores = {
        "file_created": 0.0,
        "has_added_header": 0.0,
        "has_fixed_header": 0.0,
        "has_changed_header": 0.0,
        "added_entries_correct": 0.0,
        "fixed_entries_correct": 0.0,
        "changed_entry_correct": 0.0,
    }

    workspace = Path(workspace_path)
    path = workspace / "CHANGELOG.md"
    if not path.exists():
        return scores

    scores["file_created"] = 1.0
    content = path.read_text(encoding="utf-8", errors="replace")
    lower = content.lower()

    if re.search(r"(?m)^##\s+Added\b", content):
        scores["has_added_header"] = 1.0
    if re.search(r"(?m)^##\s+Fixed\b", content):
        scores["has_fixed_header"] = 1.0
    if re.search(r"(?m)^##\s+Changed\b", content):
        scores["has_changed_header"] = 1.0

    def section_body(header_pat: str) -> str:
        m = re.search(header_pat + r"(.*?)(?=^##\s|\Z)", content, re.S | re.M)
        return m.group(1).lower() if m else ""

    added = section_body(r"(?m)^##\s+Added\b")
    fixed = section_body(r"(?m)^##\s+Fixed\b")
    changed = section_body(r"(?m)^##\s+Changed\b")

    added_hits = 0
    if "dark mode" in added:
        added_hits += 1
    if "csv export" in added or "csv" in added:
        added_hits += 1
    scores["added_entries_correct"] = 1.0 if added_hits == 2 else (0.5 if added_hits == 1 else 0.0)

    fixed_hits = 0
    if "null" in fixed or "checkout" in fixed:
        fixed_hits += 1
    if "timezone" in fixed or "calendar" in fixed:
        fixed_hits += 1
    scores["fixed_entries_correct"] = 1.0 if fixed_hits == 2 else (0.5 if fixed_hits == 1 else 0.0)

    if "auth" in changed and ("middleware" in changed or "extract" in changed):
        scores["changed_entry_correct"] = 1.0
    elif "middleware" in changed or "auth" in changed:
        scores["changed_entry_correct"] = 0.5

    return scores
```

## Additional Notes

- Keyword placement is checked within each markdown section body.
- Chore/docs commits are intentionally optional.
