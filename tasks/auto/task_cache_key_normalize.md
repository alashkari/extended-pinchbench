---
id: task_cache_key_normalize
name: Cache Key Normalize
category: skills
grading_type: automated
timeout_seconds: 120
workspace_files:
  - path: "keys.txt"
    content: |
      User Profile!
      Session-Token#42
      cache key.v2
      API/Endpoint?
      Hello World
---

## Prompt

Normalize each line in `keys.txt` using these rules:

1. Lowercase
2. Replace spaces with `_`
3. Strip punctuation except underscore `_` (remove characters that are not letters, digits, or `_`)

Write `normalized_keys.json` as a JSON array of the normalized keys in the same order as the input file.

Expected outputs for the sample keys:

- `User Profile!` → `user_profile`
- `Session-Token#42` → `sessiontoken42`
- `cache key.v2` → `cache_keyv2`
- `API/Endpoint?` → `apiendpoint`
- `Hello World` → `hello_world`

## Expected Behavior

The agent applies the normalization rules line-by-line and writes the exact JSON array.

## Grading Criteria

- [ ] normalized_keys.json created
- [ ] Exact array for all sample keys

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import json

    expected = [
        "user_profile",
        "sessiontoken42",
        "cache_keyv2",
        "apiendpoint",
        "hello_world",
    ]
    scores = {
        "file_created": 0.0,
        "user_profile": 0.0,
        "sessiontoken42": 0.0,
        "cache_keyv2": 0.0,
        "apiendpoint": 0.0,
        "hello_world": 0.0,
        "exact_array": 0.0,
    }
    workspace = Path(workspace_path)
    path = workspace / "normalized_keys.json"
    if not path.exists():
        return scores

    scores["file_created"] = 1.0
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except Exception:
        return scores

    if isinstance(data, dict):
        data = data.get("keys", data.get("normalized_keys", data.get("normalized", [])))

    if not isinstance(data, list):
        return scores

    for key in expected:
        if key in [str(x) for x in data]:
            scores[key] = 1.0

    if [str(x) for x in data] == expected:
        scores["exact_array"] = 1.0

    return scores
```
