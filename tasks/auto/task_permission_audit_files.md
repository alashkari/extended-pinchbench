---
id: task_permission_audit_files
name: World-Writable Permission Audit
category: skills
grading_type: automated
timeout_seconds: 120
workspace_files:
  - path: "perms.json"
    content: |
      {
        "entries": [
          {"path": "bin/run.sh", "mode": "0755"},
          {"path": "tmp/cache", "mode": "0777"},
          {"path": "data/secret.env", "mode": "0666"},
          {"path": "README.md", "mode": "0644"},
          {"path": "scripts/deploy.sh", "mode": "0755"},
          {"path": "var/spool", "mode": "0773"}
        ]
      }
---

## Prompt

Read `perms.json`. Flag paths that are world-writable, i.e. where `mode & 0o002` is non-zero. Write `audit.json`:

```json
{
  "world_writable": ["tmp/cache", "data/secret.env", "var/spool"]
}
```

Order does not matter. Modes may be strings like `"0777"` or integers.

## Expected Behavior

The agent parses octal modes, applies the world-write bit check (`mode & 0o002`), and lists only world-writable paths.

## Grading Criteria

- [ ] audit.json created
- [ ] Includes tmp/cache
- [ ] Includes data/secret.env
- [ ] Includes var/spool
- [ ] Does not include non-writable paths like README.md

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import json

    expected = {"tmp/cache", "data/secret.env", "var/spool"}
    safe = {"bin/run.sh", "README.md", "scripts/deploy.sh"}
    scores = {
        "file_created": 0.0,
        "has_tmp_cache": 0.0,
        "has_secret_env": 0.0,
        "has_var_spool": 0.0,
        "no_false_positives": 0.0,
    }
    workspace = Path(workspace_path)
    path = workspace / "audit.json"
    if not path.exists():
        return scores

    scores["file_created"] = 1.0
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except Exception:
        return scores

    flagged = data.get("world_writable", data.get("flagged", data if isinstance(data, list) else []))
    if not isinstance(flagged, list):
        return scores

    flagged_set = {str(x) for x in flagged}
    if "tmp/cache" in flagged_set:
        scores["has_tmp_cache"] = 1.0
    if "data/secret.env" in flagged_set:
        scores["has_secret_env"] = 1.0
    if "var/spool" in flagged_set:
        scores["has_var_spool"] = 1.0
    if flagged_set.isdisjoint(safe) and expected.issubset(flagged_set):
        scores["no_false_positives"] = 1.0
    elif flagged_set == expected:
        scores["no_false_positives"] = 1.0

    return scores
```
