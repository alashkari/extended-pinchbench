---
id: task_country_capital_batch
name: Country Capitals Batch Lookup
category: research
grading_type: automated
timeout_seconds: 120
workspace_files: []
---

## Prompt

Write a JSON file `capitals.json` that maps these countries to their capital cities:

- France
- Japan
- Brazil
- Egypt
- Canada

Use country names as keys and capital city names as string values.

## Expected Behavior

The agent should:

1. Confirm the capital of each listed country (may use knowledge or a quick lookup)
2. Create `capitals.json` as a valid JSON object
3. Use exact capitals: Paris, Tokyo, Brasília (or Brasilia), Cairo, Ottawa

## Grading Criteria

- [ ] File `capitals.json` created
- [ ] File is valid JSON
- [ ] France → Paris
- [ ] Japan → Tokyo
- [ ] Brazil → Brasília or Brasilia
- [ ] Egypt → Cairo
- [ ] Canada → Ottawa

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import json
    import unicodedata

    scores = {
        "file_created": 0.0,
        "valid_json": 0.0,
        "france_paris": 0.0,
        "japan_tokyo": 0.0,
        "brazil_brasilia": 0.0,
        "egypt_cairo": 0.0,
        "canada_ottawa": 0.0,
    }

    cap_file = Path(workspace_path) / "capitals.json"
    if not cap_file.exists():
        return scores

    scores["file_created"] = 1.0
    raw = cap_file.read_text(encoding="utf-8", errors="ignore")

    try:
        data = json.loads(raw)
    except Exception:
        return scores

    if not isinstance(data, dict):
        return scores

    scores["valid_json"] = 1.0

    def norm(s: str) -> str:
        s = unicodedata.normalize("NFKD", s)
        s = "".join(c for c in s if not unicodedata.combining(c))
        return s.strip().lower()

    lookup = {norm(str(k)): norm(str(v)) for k, v in data.items()}

    if lookup.get("france") == "paris":
        scores["france_paris"] = 1.0
    if lookup.get("japan") == "tokyo":
        scores["japan_tokyo"] = 1.0
    if lookup.get("brazil") in {"brasilia", "brasília"}:
        scores["brazil_brasilia"] = 1.0
    if lookup.get("egypt") == "cairo":
        scores["egypt_cairo"] = 1.0
    if lookup.get("canada") == "ottawa":
        scores["canada_ottawa"] = 1.0

    return scores
```
