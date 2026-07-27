---
id: task_skill_manifest_parse
name: Skill Manifest Parse
category: skills
grading_type: automated
timeout_seconds: 120
workspace_files:
  - path: "skill.yaml"
    content: |
      name: invoice-parser
      version: 1.4.2
      description: Extract structured line items from PDF invoices
      author: pinchbench
      tags:
        - finance
        - pdf
---

## Prompt

Read `skill.yaml` and extract `name`, `version`, and `description` into `fields.json` with exactly those keys.

## Expected Behavior

The agent parses the YAML and writes:

```json
{
  "name": "invoice-parser",
  "version": "1.4.2",
  "description": "Extract structured line items from PDF invoices"
}
```

## Grading Criteria

- [ ] fields.json created
- [ ] name exact
- [ ] version exact
- [ ] description exact

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import json

    scores = {
        "file_created": 0.0,
        "name_exact": 0.0,
        "version_exact": 0.0,
        "description_exact": 0.0,
    }
    workspace = Path(workspace_path)
    path = workspace / "fields.json"
    if not path.exists():
        return scores

    scores["file_created"] = 1.0
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except Exception:
        return scores

    if data.get("name") == "invoice-parser":
        scores["name_exact"] = 1.0
    if data.get("version") == "1.4.2":
        scores["version_exact"] = 1.0
    if data.get("description") == "Extract structured line items from PDF invoices":
        scores["description_exact"] = 1.0

    return scores
```
