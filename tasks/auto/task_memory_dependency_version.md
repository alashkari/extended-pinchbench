---
id: task_memory_dependency_version
name: Dependency Version Lookup
category: memory
grading_type: automated
timeout_seconds: 120
workspace_files:
  - path: "stack.md"
    content: |
      # Frontend Stack

      Runtime dependencies pinned for the dashboard app:

      - node@20.11.1
      - react@18.2.0
      - react-dom@18.2.0
      - typescript@5.3.3
      - vite@5.0.12

      Dev-only:

      - eslint@8.56.0
      - prettier@3.2.4
---

## Prompt

Read `stack.md`. What React version is listed? Save your answer to `answer.txt`.

## Expected Behavior

The agent reads `stack.md`, finds `react@18.2.0`, and writes `18.2.0` (or equivalent containing that version) to `answer.txt`.

## Grading Criteria

- [ ] answer.txt created
- [ ] Answer contains 18.2.0
- [ ] Agent read stack.md

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path

    scores = {
        "file_created": 0.0,
        "correct_version": 0.0,
        "read_stack": 0.0,
    }
    workspace = Path(workspace_path)
    answer_file = workspace / "answer.txt"

    if answer_file.exists():
        scores["file_created"] = 1.0
        content = answer_file.read_text(encoding="utf-8")
        if "18.2.0" in content:
            scores["correct_version"] = 1.0

    for event in transcript:
        if event.get("type") != "message":
            continue
        msg = event.get("message", {})
        if msg.get("role") != "assistant":
            continue
        for item in msg.get("content", []):
            if item.get("type") != "toolCall":
                continue
            tool_name = item.get("name", "")
            if tool_name not in ["read", "read_file", "readFile"]:
                continue
            args = item.get("arguments", item.get("params", {}))
            files = args.get("files", [])
            path_candidates = [
                args.get("path", ""),
                args.get("file_path", ""),
                args.get("file", ""),
            ]
            if any("stack.md" in str(f) for f in files) or any(
                "stack.md" in str(p) for p in path_candidates if p
            ):
                scores["read_stack"] = 1.0

    return scores
```
