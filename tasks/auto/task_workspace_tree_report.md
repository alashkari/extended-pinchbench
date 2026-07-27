---
id: task_workspace_tree_report
name: Workspace Tree Report
category: skills
grading_type: automated
timeout_seconds: 120
workspace_files:
  - path: "a/b/c.txt"
    content: |
      nested leaf c
  - path: "a/b/d.txt"
    content: |
      nested leaf d
  - path: "a/readme.md"
    content: |
      # Folder A
  - path: "docs/guide.md"
    content: |
      Getting started
  - path: "root.txt"
    content: |
      top-level file
---

## Prompt

Inspect the workspace file tree. Write `tree.txt` listing every file path relative to the workspace root, one path per line (forward slashes). Include nested paths such as `a/b/c.txt`.

## Expected Behavior

The agent discovers the nested fixture files and writes a path listing that includes the key paths.

## Grading Criteria

- [ ] tree.txt created
- [ ] Contains a/b/c.txt
- [ ] Contains a/b/d.txt
- [ ] Contains docs/guide.md
- [ ] Contains root.txt

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path

    scores = {
        "file_created": 0.0,
        "has_a_b_c": 0.0,
        "has_a_b_d": 0.0,
        "has_docs_guide": 0.0,
        "has_root": 0.0,
    }
    workspace = Path(workspace_path)
    path = workspace / "tree.txt"
    if not path.exists():
        return scores

    scores["file_created"] = 1.0
    content = path.read_text(encoding="utf-8").replace("\\", "/")
    if "a/b/c.txt" in content:
        scores["has_a_b_c"] = 1.0
    if "a/b/d.txt" in content:
        scores["has_a_b_d"] = 1.0
    if "docs/guide.md" in content:
        scores["has_docs_guide"] = 1.0
    if "root.txt" in content:
        scores["has_root"] = 1.0

    return scores
```
