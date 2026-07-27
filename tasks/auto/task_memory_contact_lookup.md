---
id: task_memory_contact_lookup
name: Contact Lookup
category: memory
grading_type: automated
timeout_seconds: 120
workspace_files:
  - path: "contacts.md"
    content: |
      # Team Contacts

      ## Alex Rivera
      - email: alex.rivera@example.com
      - phone: +1-555-0199

      ## Dana Lee
      - email: dana.lee@example.com
      - phone: +1-555-0102

      ## Mina Cho
      - email: mina.cho@example.com
      - phone: +1-555-0144
---

## Prompt

Look up Dana Lee in `contacts.md`. Save her email and phone number to `answer.txt`.

## Expected Behavior

The agent reads `contacts.md`, finds Dana Lee, and writes both `dana.lee@example.com` and `+1-555-0102` into `answer.txt`.

## Grading Criteria

- [ ] answer.txt created
- [ ] Email dana.lee@example.com present
- [ ] Phone +1-555-0102 present
- [ ] Agent read contacts.md

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path

    scores = {
        "file_created": 0.0,
        "email_correct": 0.0,
        "phone_correct": 0.0,
        "read_contacts": 0.0,
    }
    workspace = Path(workspace_path)
    answer_file = workspace / "answer.txt"

    if answer_file.exists():
        scores["file_created"] = 1.0
        content = answer_file.read_text(encoding="utf-8").lower()
        if "dana.lee@example.com" in content:
            scores["email_correct"] = 1.0
        if "555-0102" in content or "+1-555-0102" in content:
            scores["phone_correct"] = 1.0

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
            if any("contacts.md" in str(f) for f in files) or any(
                "contacts.md" in str(p) for p in path_candidates if p
            ):
                scores["read_contacts"] = 1.0

    return scores
```
