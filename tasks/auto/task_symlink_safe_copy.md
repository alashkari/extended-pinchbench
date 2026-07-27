---
id: task_symlink_safe_copy
name: Symlink-Safe Copy Plan
category: skills
grading_type: automated
timeout_seconds: 120
workspace_files:
  - path: "inventory.json"
    content: |
      {
        "entries": [
          {"path": "src/main.py", "type": "file"},
          {"path": "src/lib.py", "type": "file"},
          {"path": "vendor/legacy", "type": "symlink"},
          {"path": "README.md", "type": "file"},
          {"path": "cache/tmp", "type": "symlink"},
          {"path": "data/input.csv", "type": "file"}
        ]
      }
---

## Prompt

Read `inventory.json`. Build a symlink-safe copy plan in `copy_plan.json`:

```json
{
  "include": ["src/main.py", "..."],
  "skipped_symlinks": ["vendor/legacy", "..."]
}
```

Include only paths where `type` is `file`. List symlink paths under `skipped_symlinks`. Order does not matter.

## Expected Behavior

The agent filters inventory entries so regular files are copied and symlinks are skipped.

## Grading Criteria

- [ ] copy_plan.json created
- [ ] All file paths included
- [ ] Both symlinks skipped
- [ ] No symlink in include

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import json

    expected_include = {
        "src/main.py",
        "src/lib.py",
        "README.md",
        "data/input.csv",
    }
    expected_skip = {"vendor/legacy", "cache/tmp"}
    scores = {
        "file_created": 0.0,
        "include_complete": 0.0,
        "skip_complete": 0.0,
        "no_symlink_included": 0.0,
    }
    workspace = Path(workspace_path)
    path = workspace / "copy_plan.json"
    if not path.exists():
        return scores

    scores["file_created"] = 1.0
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except Exception:
        return scores

    include = {str(x) for x in data.get("include", [])}
    skipped = {str(x) for x in data.get("skipped_symlinks", data.get("skipped", []))}

    if expected_include.issubset(include):
        scores["include_complete"] = 1.0
    if expected_skip.issubset(skipped):
        scores["skip_complete"] = 1.0
    if include.isdisjoint(expected_skip):
        scores["no_symlink_included"] = 1.0

    return scores
```
