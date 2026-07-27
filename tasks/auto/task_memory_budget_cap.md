---
id: task_memory_budget_cap
name: Budget Cap Extraction
category: memory
grading_type: automated
timeout_seconds: 120
workspace_files:
  - path: "budget.md"
    content: |
      # FY2026 Budget Caps

      ## Q2
      - Engineering headcount: $890,000
      - Marketing spend cap: $98,000

      ## Q3
      - Engineering headcount: $910,000
      - Marketing spend cap: $125,000
      - Facilities: $42,500

      ## Q4
      - Engineering headcount: $940,000
      - Marketing spend cap: $140,000
---

## Prompt

Read `budget.md` and extract the Q3 marketing spend cap. Save the amount to `answer.txt`.

## Expected Behavior

The agent reads `budget.md`, locates the Q3 marketing spend cap of $125,000, and writes it to `answer.txt`.

## Grading Criteria

- [ ] answer.txt created
- [ ] Answer contains 125000, 125,000, or $125
- [ ] Agent read budget.md

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import re

    scores = {
        "file_created": 0.0,
        "correct_amount": 0.0,
        "read_budget": 0.0,
    }
    workspace = Path(workspace_path)
    answer_file = workspace / "answer.txt"

    if answer_file.exists():
        scores["file_created"] = 1.0
        content = answer_file.read_text(encoding="utf-8")
        if re.search(r"125[,\s]?000|\$125", content):
            scores["correct_amount"] = 1.0

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
            if any("budget.md" in str(f) for f in files) or any(
                "budget.md" in str(p) for p in path_candidates if p
            ):
                scores["read_budget"] = 1.0

    return scores
```
