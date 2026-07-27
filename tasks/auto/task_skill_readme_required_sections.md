---
id: task_skill_readme_required_sections
name: README Required Sections Validation
category: skills
grading_type: automated
timeout_seconds: 120
workspace_files:
  - path: "README.md"
    content: |
      # invoice-parser

      ## Overview

      Parse PDF invoices into structured JSON.

      ## Usage

      ```bash
      invoice-parser input.pdf
      ```

      ## Configuration

      Set `INVOICE_PARSER_API_KEY` before running.

      ## License

      MIT
---

## Prompt

Validate `README.md` against these required section headings (exact `##` titles): Overview, Installation, Usage, Configuration, License.

Write `validation.json`:

```json
{
  "missing": ["Installation"],
  "present": ["Overview", "Usage", "Configuration", "License"]
}
```

Order within each list does not matter.

## Expected Behavior

The agent scans `##` headings, reports Installation as missing, and lists the present required sections.

## Grading Criteria

- [ ] validation.json created
- [ ] missing includes Installation
- [ ] present includes Overview
- [ ] present includes Usage

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import json

    scores = {
        "file_created": 0.0,
        "missing_installation": 0.0,
        "present_overview": 0.0,
        "present_usage": 0.0,
    }
    workspace = Path(workspace_path)
    path = workspace / "validation.json"
    if not path.exists():
        return scores

    scores["file_created"] = 1.0
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except Exception:
        return scores

    missing = [str(x) for x in data.get("missing", [])]
    present = [str(x) for x in data.get("present", [])]

    if any(m.lower() == "installation" for m in missing):
        scores["missing_installation"] = 1.0
    if any(p.lower() == "overview" for p in present):
        scores["present_overview"] = 1.0
    if any(p.lower() == "usage" for p in present):
        scores["present_usage"] = 1.0

    return scores
```
