---
id: task_memory_fresh_session_recall
name: Fresh Session Memory Recall
category: memory
grading_type: automated
timeout_seconds: 240
multi_session: true
sessions:
  - id: save_favorite
    prompt: |
      Please remember my favorite color: indigo.
      Save it to a file called `memory.md` in the workspace so a future session can recall it.
      Confirm once it is saved.
  - id: fresh_recall
    new_session: true
    prompt: |
      In a previous session I saved my favorite color somewhere in this workspace.
      What is my favorite color? Read any memory file you find and write the answer to `answer.txt`.
workspace_files: []
---

## Prompt

This is a multi-session task. See the `sessions` field in the frontmatter for the sequence of prompts.

## Expected Behavior

1. Session 1: Agent writes `memory.md` containing the favorite color indigo.
2. Session 2: Fresh session with no conversation history; agent reads `memory.md` and writes `answer.txt` containing indigo.

## Grading Criteria

- [ ] memory.md exists and contains indigo
- [ ] answer.txt exists and contains indigo

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path

    scores = {
        "memory_has_indigo": 0.0,
        "answer_has_indigo": 0.0,
    }
    workspace = Path(workspace_path)

    memory_candidates = [
        workspace / "memory.md",
        workspace / "MEMORY.md",
        workspace / "memory" / "memory.md",
        workspace / "memory" / "MEMORY.md",
    ]
    for path in memory_candidates:
        if path.exists():
            if "indigo" in path.read_text(encoding="utf-8").lower():
                scores["memory_has_indigo"] = 1.0
                break

    answer_file = workspace / "answer.txt"
    if answer_file.exists():
        if "indigo" in answer_file.read_text(encoding="utf-8").lower():
            scores["answer_has_indigo"] = 1.0

    return scores
```
