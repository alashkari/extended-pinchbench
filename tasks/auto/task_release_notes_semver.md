---
id: task_release_notes_semver
name: Release Notes From Semver PRs
category: writing
grading_type: automated
timeout_seconds: 120
workspace_files:
  - path: "pr_titles.txt"
    content: |
      feat: add bulk invite for workspace members
      fix: prevent double-charge on failed card retries
      docs: clarify rate-limit headers in API guide
      feat: introduce saved filter presets on issues board
      fix: restore missing avatar on shared links
      docs: add migration notes for v3 webhooks
      chore: upgrade CI runners to Ubuntu 24.04
---

# Release Notes From Semver PRs

## Prompt

Read `pr_titles.txt` (conventional PR titles with `feat:`, `fix:`, and `docs:` prefixes). Write `release_notes.md` grouped under these exact section headers:

- `## Features`
- `## Bug Fixes`
- `## Documentation`

Place each relevant PR under the matching section. You may omit `chore:` entries.

## Expected Behavior

The agent should produce release notes with:

- Features: bulk invite; saved filter presets
- Bug Fixes: double-charge / card retries; missing avatar
- Documentation: rate-limit headers; migration notes for v3 webhooks

## Grading Criteria

- [ ] File `release_notes.md` is created
- [ ] Has `## Features` header
- [ ] Has `## Bug Fixes` header
- [ ] Has `## Documentation` header
- [ ] Feature items present under Features
- [ ] Bug fix items present under Bug Fixes
- [ ] Documentation items present under Documentation

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import re

    scores = {
        "file_created": 0.0,
        "has_features_header": 0.0,
        "has_bug_fixes_header": 0.0,
        "has_documentation_header": 0.0,
        "features_items": 0.0,
        "bug_fixes_items": 0.0,
        "documentation_items": 0.0,
    }

    workspace = Path(workspace_path)
    path = workspace / "release_notes.md"
    if not path.exists():
        return scores

    scores["file_created"] = 1.0
    content = path.read_text(encoding="utf-8", errors="replace")

    if re.search(r"(?m)^##\s+Features\b", content):
        scores["has_features_header"] = 1.0
    if re.search(r"(?m)^##\s+Bug Fixes\b", content):
        scores["has_bug_fixes_header"] = 1.0
    if re.search(r"(?m)^##\s+Documentation\b", content):
        scores["has_documentation_header"] = 1.0

    def section_body(header_pat: str) -> str:
        m = re.search(header_pat + r"(.*?)(?=^##\s|\Z)", content, re.S | re.M)
        return m.group(1).lower() if m else ""

    features = section_body(r"(?m)^##\s+Features\b")
    bugs = section_body(r"(?m)^##\s+Bug Fixes\b")
    docs = section_body(r"(?m)^##\s+Documentation\b")

    feat_hits = 0
    if "bulk invite" in features or "invite" in features:
        feat_hits += 1
    if "filter" in features or "preset" in features:
        feat_hits += 1
    scores["features_items"] = 1.0 if feat_hits == 2 else (0.5 if feat_hits == 1 else 0.0)

    bug_hits = 0
    if "double-charge" in bugs or "double charge" in bugs or "card" in bugs:
        bug_hits += 1
    if "avatar" in bugs:
        bug_hits += 1
    scores["bug_fixes_items"] = 1.0 if bug_hits == 2 else (0.5 if bug_hits == 1 else 0.0)

    doc_hits = 0
    if "rate-limit" in docs or "rate limit" in docs:
        doc_hits += 1
    if "migration" in docs or "webhook" in docs:
        doc_hits += 1
    scores["documentation_items"] = 1.0 if doc_hits == 2 else (0.5 if doc_hits == 1 else 0.0)

    return scores
```

## Additional Notes

- Section headers and item placement are graded; wording variations are allowed if keywords remain.
