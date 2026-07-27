---
id: task_memory_contradiction_flag
name: Contradiction Flag Between Notes
category: memory
grading_type: automated
timeout_seconds: 180
workspace_files:
  - path: "note_a.md"
    content: |
      # API Client Notes (Service A)

      Default retry count: 3
      API timeout: 30s
      Base URL: https://api.example.com/v1
  - path: "note_b.md"
    content: |
      # API Client Notes (Service B draft)

      Default retry count: 3
      API timeout: 60s
      Base URL: https://api.example.com/v1
---

## Prompt

Read `note_a.md` and `note_b.md`. They may disagree. Write `contradictions.json` listing conflicting fields. Use this shape:

```json
{
  "conflicts": [
    {
      "field": "timeout_seconds",
      "values": [30, 60]
    }
  ]
}
```

Include every field where the notes disagree. Order of values does not matter.

## Expected Behavior

The agent detects that timeout differs (30s vs 60s), writes `contradictions.json` with field `timeout_seconds` and both values, and does not invent unrelated conflicts.

## Grading Criteria

- [ ] contradictions.json created
- [ ] conflict field is timeout_seconds
- [ ] values include both 30 and 60

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import json

    scores = {
        "file_created": 0.0,
        "field_detected": 0.0,
        "values_correct": 0.0,
    }
    workspace = Path(workspace_path)
    path = workspace / "contradictions.json"
    if not path.exists():
        return scores

    scores["file_created"] = 1.0
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except Exception:
        return scores

    conflicts = data.get("conflicts", data if isinstance(data, list) else [])
    if not isinstance(conflicts, list):
        return scores

    found_field = False
    found_values = False
    for item in conflicts:
        if not isinstance(item, dict):
            continue
        field = str(item.get("field", "")).lower()
        if "timeout" in field:
            found_field = True
            values = item.get("values", [])
            normalized = set()
            for v in values:
                try:
                    normalized.add(int(str(v).replace("s", "").strip()))
                except Exception:
                    pass
            if 30 in normalized and 60 in normalized:
                found_values = True

    scores["field_detected"] = 1.0 if found_field else 0.0
    scores["values_correct"] = 1.0 if found_values else 0.0
    return scores
```
