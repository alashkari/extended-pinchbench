---
id: task_memory_project_owner
name: Project Owner Lookup
category: memory
grading_type: automated
timeout_seconds: 120
workspace_files:
  - path: "notes.md"
    content: |
      # Project Notes

      ## Active Projects

      - Project Atlas — owner: Jordan Blake
      - Project Orion — owner: Priya Nair
      - Project Nebula — owner: Sam Ortiz

      Last updated: 2026-03-12
---

## Prompt

Read `notes.md` and answer: Who owns Project Orion? Save your answer to `answer.txt`.

## Expected Behavior

The agent should read `notes.md`, find that Project Orion is owned by Priya Nair, and write that answer to `answer.txt`.

## Grading Criteria

- [ ] answer.txt created
- [ ] Answer contains Priya Nair
- [ ] Agent read notes.md (visible in transcript)

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path

    scores = {
        "file_created": 0.0,
        "correct_owner": 0.0,
        "read_notes": 0.0,
    }
    workspace = Path(workspace_path)
    answer_file = workspace / "answer.txt"

    if answer_file.exists():
        scores["file_created"] = 1.0
        content = answer_file.read_text(encoding="utf-8")
        if "priya nair" in content.lower():
            scores["correct_owner"] = 1.0

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
            if any("notes.md" in str(f) for f in files) or any(
                "notes.md" in str(p) for p in path_candidates if p
            ):
                scores["read_notes"] = 1.0

    return scores
```
