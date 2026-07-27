---
id: task_env_config_loader
name: Env Config Loader
category: coding
grading_type: automated
timeout_seconds: 180
workspace_files:
  - path: "sample.env"
    content: |
      # Application configuration
      APP_NAME=PinchBench
      APP_PORT=8080

      # Database settings
      DB_HOST=localhost
      DB_USER=app
      # DB_PASSWORD=do-not-load-this-commented-line
      DB_PASSWORD=s3cret

      EMPTY_SKIP=

      QUOTED_VALUE="hello world"
---

# Env Config Loader

## Prompt

Write `load_env.py` that defines a function `load_env(path: str) -> dict`.

The function must:

1. Read a `.env`-style file at `path`
2. Parse lines of the form `KEY=VALUE`
3. Ignore blank lines and comment lines starting with `#`
4. Return a dictionary mapping keys to string values
5. Optionally strip surrounding quotes from values

A fixture file `sample.env` is provided in the workspace. You may include a small `__main__` block that loads it and prints the dict, but the required deliverable is the `load_env` function.

## Expected Behavior

The agent creates `load_env.py` with a `load_env` function that parses KEY=VALUE lines and skips `#` comments. For `sample.env`, keys like `APP_NAME`, `APP_PORT`, `DB_HOST`, `DB_USER`, and `DB_PASSWORD` should be present, and the commented `DB_PASSWORD=do-not-load-this-commented-line` line must not override the real password if comments are handled correctly.

## Grading Criteria

- [ ] File `load_env.py` exists
- [ ] File contains valid Python syntax
- [ ] Defines function `load_env`
- [ ] Function takes a path argument
- [ ] Handles `#` comments
- [ ] Parses KEY=VALUE pairs

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import ast
    import re

    scores = {
        "file_exists": 0.0,
        "valid_python": 0.0,
        "defines_load_env": 0.0,
        "path_param": 0.0,
        "handles_comments": 0.0,
        "parses_key_value": 0.0,
    }

    workspace = Path(workspace_path)
    script = workspace / "load_env.py"
    if not script.exists():
        return scores

    scores["file_exists"] = 1.0
    content = script.read_text(encoding="utf-8")

    try:
        tree = ast.parse(content)
        scores["valid_python"] = 1.0
    except SyntaxError:
        return scores

    load_env_fn = None
    for node in ast.walk(tree):
        if isinstance(node, ast.FunctionDef) and node.name == "load_env":
            load_env_fn = node
            break

    if load_env_fn is not None:
        scores["defines_load_env"] = 1.0
        if load_env_fn.args.args:
            scores["path_param"] = 1.0

    if re.search(r"""startswith\s*\(\s*['\"]#['\"]\)|line\s*\.strip\(\).*#|#\s*""", content) or re.search(
        r"""['\"]#['\"]""", content
    ):
        scores["handles_comments"] = 1.0

    if re.search(r"split\s*\(\s*['\"]=['\"]|partition\s*\(\s*['\"]=['\"]|\.split\(['\"]=", content):
        scores["parses_key_value"] = 1.0

    return scores
```

## Additional Notes

- Fixture includes inline comments and a fully commented KEY=VALUE line to test comment handling.
- Empty values and quoted values are optional edge cases.
