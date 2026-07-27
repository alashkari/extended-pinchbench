---
id: task_config_merge_overlay
name: Config Deep Merge Overlay
category: skills
grading_type: automated
timeout_seconds: 180
workspace_files:
  - path: "base.json"
    content: |
      {
        "service": "api",
        "port": 8080,
        "features": {
          "auth": true,
          "cache": false,
          "limits": {
            "rps": 100,
            "burst": 20
          }
        },
        "logging": {
          "level": "info"
        }
      }
  - path: "overlay.json"
    content: |
      {
        "port": 9090,
        "features": {
          "cache": true,
          "limits": {
            "rps": 250
          }
        },
        "logging": {
          "level": "debug",
          "format": "json"
        }
      }
---

## Prompt

Deep-merge `overlay.json` onto `base.json` (overlay wins on conflicts; nested objects merge recursively). Write the result to `merged.json`.

Expected final values include: port 9090, features.cache true, features.limits.rps 250, features.limits.burst 20 (preserved from base), logging.level debug, logging.format json, features.auth true (preserved).

## Expected Behavior

The agent performs a recursive deep merge where overlay values override base values at each key, while preserving base keys not present in overlay.

## Grading Criteria

- [ ] merged.json created
- [ ] port is 9090
- [ ] features.cache is true
- [ ] features.limits.rps is 250
- [ ] features.limits.burst is 20
- [ ] logging.level is debug
- [ ] logging.format is json
- [ ] features.auth is true

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import json

    scores = {
        "file_created": 0.0,
        "port_9090": 0.0,
        "cache_true": 0.0,
        "rps_250": 0.0,
        "burst_20": 0.0,
        "level_debug": 0.0,
        "format_json": 0.0,
        "auth_true": 0.0,
    }
    workspace = Path(workspace_path)
    path = workspace / "merged.json"
    if not path.exists():
        return scores

    scores["file_created"] = 1.0
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except Exception:
        return scores

    if data.get("port") == 9090:
        scores["port_9090"] = 1.0

    features = data.get("features", {}) if isinstance(data.get("features"), dict) else {}
    if features.get("cache") is True:
        scores["cache_true"] = 1.0
    if features.get("auth") is True:
        scores["auth_true"] = 1.0

    limits = features.get("limits", {}) if isinstance(features.get("limits"), dict) else {}
    if limits.get("rps") == 250:
        scores["rps_250"] = 1.0
    if limits.get("burst") == 20:
        scores["burst_20"] = 1.0

    logging = data.get("logging", {}) if isinstance(data.get("logging"), dict) else {}
    if logging.get("level") == "debug":
        scores["level_debug"] = 1.0
    if logging.get("format") == "json":
        scores["format_json"] = 1.0

    return scores
```
