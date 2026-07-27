---
id: task_memory_update_then_query
name: Update Preference Then Query
category: memory
grading_type: automated
timeout_seconds: 240
multi_session: true
sessions:
  - id: set_theme
    prompt: |
      Create or update `preferences.json` so it includes `"theme": "dark"`.
      Keep any other fields if the file already exists; if creating new, a single theme field is fine.
  - id: query_theme
    prompt: |
      What is my current theme preference? Read `preferences.json` and write the theme value to `answer.txt`.
workspace_files: []
---

## Prompt

This is a multi-session task (same conversation context). See the `sessions` field in the frontmatter.

## Expected Behavior

1. First turn: Agent creates/updates `preferences.json` with `theme` set to `dark`.
2. Second turn (same session): Agent reads the file and writes `dark` to `answer.txt`.

## Grading Criteria

- [ ] preferences.json has theme dark
- [ ] answer.txt contains dark

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import json

    scores = {
        "preferences_theme_dark": 0.0,
        "answer_has_dark": 0.0,
    }
    workspace = Path(workspace_path)

    prefs = workspace / "preferences.json"
    if prefs.exists():
        try:
            data = json.loads(prefs.read_text(encoding="utf-8"))
            theme = str(data.get("theme", "")).lower()
            if theme == "dark":
                scores["preferences_theme_dark"] = 1.0
        except Exception:
            content = prefs.read_text(encoding="utf-8").lower()
            if '"theme"' in content and "dark" in content:
                scores["preferences_theme_dark"] = 1.0

    answer = workspace / "answer.txt"
    if answer.exists() and "dark" in answer.read_text(encoding="utf-8").lower():
        scores["answer_has_dark"] = 1.0

    return scores
```
