---
id: task_integration_oauth_token_expiry
name: OAuth Token Expiry Check
category: integrations
grading_type: automated
timeout_seconds: 180
workspace_files:
  - path: "tokens.json"
    content: |
      {
        "tokens": [
          {"client_id": "client_alpha", "expires_at": "2026-07-26T23:59:59Z"},
          {"client_id": "client_beta", "expires_at": "2026-07-27T18:00:00Z"},
          {"client_id": "client_gamma", "expires_at": "2026-07-20T12:00:00Z"},
          {"client_id": "client_delta", "expires_at": "2026-08-01T00:00:00Z"},
          {"client_id": "client_epsilon", "expires_at": "2026-07-27T11:59:59Z"}
        ]
      }
---

## Prompt

Read `tokens.json`. Using reference time **2026-07-27T12:00:00Z**, find every token whose `expires_at` is strictly before that time (already expired).

Write `expired.json` as a JSON array of expired `client_id` values. Order does not matter.

Example shape:

```json
["client_alpha", "client_gamma", "client_epsilon"]
```

## Expected Behavior

At 2026-07-27T12:00:00Z:
- expired: client_alpha, client_gamma, client_epsilon
- still valid: client_beta (18:00 same day), client_delta (August)

## Grading Criteria

- [ ] expired.json exists
- [ ] Valid JSON array
- [ ] Exact expired client_id set

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import json

    scores = {
        "file_created": 0.0,
        "valid_json": 0.0,
        "exact_set": 0.0,
    }
    workspace = Path(workspace_path)
    path = workspace / "expired.json"
    if not path.exists():
        return scores

    scores["file_created"] = 1.0
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except Exception:
        return scores

    if isinstance(data, dict):
        data = data.get("expired") or data.get("client_ids") or data.get("expired_clients")

    if not isinstance(data, list):
        return scores

    scores["valid_json"] = 1.0
    got = {str(x) for x in data}
    expected = {"client_alpha", "client_gamma", "client_epsilon"}
    if got == expected:
        scores["exact_set"] = 1.0

    return scores
```

## Additional Notes

- Fixture-only OAuth tokens; no live IdP.
- Reference now is fixed: 2026-07-27T12:00:00Z.
