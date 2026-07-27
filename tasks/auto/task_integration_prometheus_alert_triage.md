---
id: task_integration_prometheus_alert_triage
name: Prometheus Alert Triage
category: integrations
grading_type: automated
timeout_seconds: 180
workspace_files:
  - path: "alerts.json"
    content: |
      {
        "alerts": [
          {"alertname": "HighErrorRate", "severity": "critical", "state": "firing", "instance": "api-1"},
          {"alertname": "DiskAlmostFull", "severity": "warning", "state": "firing", "instance": "db-1"},
          {"alertname": "PodCrashLoop", "severity": "critical", "state": "resolved", "instance": "worker-3"},
          {"alertname": "LatencyP99", "severity": "critical", "state": "firing", "instance": "api-2"},
          {"alertname": "CertExpiring", "severity": "info", "state": "firing", "instance": "edge-1"},
          {"alertname": "OOMKilled", "severity": "critical", "state": "firing", "instance": "cache-1"},
          {"alertname": "ReplicationLag", "severity": "warning", "state": "pending", "instance": "db-2"}
        ]
      }
---

## Prompt

Read `alerts.json`. Select only alerts where `severity` is `critical` **and** `state` is `firing`.

Write `p0_alerts.json` as a JSON array of those alert objects (or at minimum objects that include `alertname`). Order does not matter.

## Expected Behavior

P0 alerts are HighErrorRate, LatencyP99, and OOMKilled. PodCrashLoop is critical but resolved, so it must be excluded. Warning/info alerts are excluded.

## Grading Criteria

- [ ] p0_alerts.json exists
- [ ] Valid JSON array
- [ ] Contains HighErrorRate
- [ ] Contains LatencyP99
- [ ] Contains OOMKilled
- [ ] Exact set of three critical firing alerts (no extras)

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import json

    scores = {
        "file_created": 0.0,
        "valid_json": 0.0,
        "has_high_error_rate": 0.0,
        "has_latency_p99": 0.0,
        "has_oom_killed": 0.0,
        "exact_names": 0.0,
    }
    workspace = Path(workspace_path)
    path = workspace / "p0_alerts.json"
    if not path.exists():
        return scores

    scores["file_created"] = 1.0
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except Exception:
        return scores

    if isinstance(data, dict):
        data = data.get("alerts") or data.get("p0_alerts") or data.get("items")

    if not isinstance(data, list):
        return scores

    scores["valid_json"] = 1.0

    names = set()
    for item in data:
        if isinstance(item, str):
            names.add(item)
        elif isinstance(item, dict):
            name = item.get("alertname") or item.get("name") or item.get("alert")
            if name:
                names.add(str(name))

    if "HighErrorRate" in names:
        scores["has_high_error_rate"] = 1.0
    if "LatencyP99" in names:
        scores["has_latency_p99"] = 1.0
    if "OOMKilled" in names:
        scores["has_oom_killed"] = 1.0

    expected = {"HighErrorRate", "LatencyP99", "OOMKilled"}
    if names == expected:
        scores["exact_names"] = 1.0

    return scores
```

## Additional Notes

- Fixture-only Prometheus-style alerts; no live Alertmanager.
