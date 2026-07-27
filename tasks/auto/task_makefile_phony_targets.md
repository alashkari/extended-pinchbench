---
id: task_makefile_phony_targets
name: Makefile Phony Targets
category: coding
grading_type: automated
timeout_seconds: 180
workspace_files: []
---

# Makefile Phony Targets

## Prompt

Create a `Makefile` in the workspace with:

1. A `.PHONY` declaration listing `test`, `lint`, and `build`
2. A `test` target with a recipe (e.g. run pytest or `python -m pytest`)
3. A `lint` target with a recipe (e.g. run ruff, flake8, or pylint)
4. A `build` target with a recipe (e.g. `python -m build`, compile, or package step)

Recipes may be simple placeholder commands as long as each target has at least one shell command line.

## Expected Behavior

The agent writes a `Makefile` containing `.PHONY: test lint build` (order may vary) and defines recipes for each of those three targets.

## Grading Criteria

- [ ] File `Makefile` exists
- [ ] Contains `.PHONY` declaration
- [ ] Lists `test` as a phony/target
- [ ] Lists `lint` as a phony/target
- [ ] Lists `build` as a phony/target
- [ ] Each of test/lint/build has a recipe line

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import re

    scores = {
        "file_exists": 0.0,
        "has_phony": 0.0,
        "phony_test": 0.0,
        "phony_lint": 0.0,
        "phony_build": 0.0,
        "has_recipes": 0.0,
    }

    workspace = Path(workspace_path)
    makefile = workspace / "Makefile"
    if not makefile.exists():
        alt = workspace / "makefile"
        if alt.exists():
            makefile = alt
        else:
            return scores

    scores["file_exists"] = 1.0
    content = makefile.read_text(encoding="utf-8")

    if re.search(r"^\.PHONY\s*:", content, re.MULTILINE):
        scores["has_phony"] = 1.0

    phony_line = ""
    m = re.search(r"^\.PHONY\s*:\s*(.+)$", content, re.MULTILINE)
    if m:
        phony_line = m.group(1)

    if re.search(r"\btest\b", phony_line) or re.search(r"^test\s*:", content, re.MULTILINE):
        scores["phony_test"] = 1.0
    if re.search(r"\blint\b", phony_line) or re.search(r"^lint\s*:", content, re.MULTILINE):
        scores["phony_lint"] = 1.0
    if re.search(r"\bbuild\b", phony_line) or re.search(r"^build\s*:", content, re.MULTILINE):
        scores["phony_build"] = 1.0

    def has_recipe(target: str) -> bool:
        pattern = rf"^{target}\s*:[^\n]*\n(?:\t.+\n)+"
        return bool(re.search(pattern, content, re.MULTILINE))

    recipe_count = sum(has_recipe(t) for t in ("test", "lint", "build"))
    if recipe_count == 3:
        scores["has_recipes"] = 1.0
    elif recipe_count > 0:
        scores["has_recipes"] = recipe_count / 3.0

    return scores
```

## Additional Notes

- Accepts `Makefile` or `makefile`.
- Recipe lines must be tab-indented per Make syntax for full `has_recipes` credit.
