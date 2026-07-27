---
id: task_json_schema_validator_script
name: JSON Schema Validator Script
category: coding
grading_type: automated
timeout_seconds: 180
workspace_files:
  - path: "schema.json"
    content: |
      {
        "type": "object",
        "required": ["name", "age", "email"],
        "properties": {
          "name": {"type": "string", "minLength": 1},
          "age": {"type": "integer", "minimum": 0, "maximum": 150},
          "email": {"type": "string"}
        },
        "additionalProperties": false
      }
  - path: "data.json"
    content: |
      {
        "name": "Ada Lovelace",
        "age": 36,
        "email": "ada@example.com"
      }
---

# JSON Schema Validator Script

## Prompt

Write a Python script named `validator.py` that loads `schema.json` and `data.json` from the current directory and validates the data against the schema.

The script must print exactly one line to stdout: either `VALID` or `INVALID`.

You may implement a minimal validator yourself (checking required keys, types, and constraints from the schema) or use a library if available. The workspace already contains `schema.json` and `data.json`.

## Expected Behavior

The agent should:

1. Create `validator.py` in the workspace
2. Load both `schema.json` and `data.json`
3. Validate that required properties exist, types match, and constraints (e.g. minLength, minimum/maximum) hold
4. Print `VALID` when data conforms, otherwise print `INVALID`
5. Handle the provided fixtures (current data is valid)

## Grading Criteria

- [ ] File `validator.py` exists
- [ ] File contains valid Python syntax
- [ ] Script references `schema.json`
- [ ] Script references `data.json`
- [ ] Script prints VALID or INVALID

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import ast
    import re

    scores = {
        "file_exists": 0.0,
        "valid_python": 0.0,
        "references_schema": 0.0,
        "references_data": 0.0,
        "prints_valid_or_invalid": 0.0,
    }

    workspace = Path(workspace_path)
    script = workspace / "validator.py"
    if not script.exists():
        return scores

    scores["file_exists"] = 1.0
    content = script.read_text(encoding="utf-8")

    try:
        ast.parse(content)
        scores["valid_python"] = 1.0
    except SyntaxError:
        return scores

    if re.search(r"schema\.json", content):
        scores["references_schema"] = 1.0

    if re.search(r"data\.json", content):
        scores["references_data"] = 1.0

    if re.search(r"""print\s*\(\s*['\"]VALID['\"]\s*\)""", content) and re.search(
        r"""print\s*\(\s*['\"]INVALID['\"]\s*\)""", content
    ):
        scores["prints_valid_or_invalid"] = 1.0
    elif re.search(r"""['\"]VALID['\"]""", content) and re.search(
        r"""['\"]INVALID['\"]""", content
    ):
        scores["prints_valid_or_invalid"] = 0.75
    elif re.search(r"VALID|INVALID", content):
        scores["prints_valid_or_invalid"] = 0.5

    return scores
```

## Additional Notes

- Workspace fixtures: `schema.json` (person object schema) and `data.json` (valid Ada Lovelace record).
- Grading is static (ast/re/file checks); the script is not executed by the grader.
