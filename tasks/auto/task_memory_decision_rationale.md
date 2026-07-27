---
id: task_memory_decision_rationale
name: Decision Rationale Recall
category: memory
grading_type: automated
timeout_seconds: 120
workspace_files:
  - path: "decisions.md"
    content: |
      # Architecture Decisions

      ## ADR-001: Primary datastore

      We evaluated MongoDB, MySQL, and Postgres.

      Decision: chose Postgres because JSONB support and ops familiarity.
      Rejected MongoDB due to weaker transactional guarantees for our billing flows.
      Rejected MySQL because JSON querying was less mature for our use cases.

      ## ADR-002: Cache layer

      Decision: Redis for session cache.
---

## Prompt

Read `decisions.md`. Why did we choose Postgres? Save your answer to `answer.txt`.

## Expected Behavior

The agent extracts the rationale: JSONB support and ops familiarity (or equivalent wording), and writes it to `answer.txt`.

## Grading Criteria

- [ ] answer.txt created
- [ ] Answer mentions JSONB
- [ ] Answer mentions familiarity or ops
- [ ] Agent read decisions.md

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path

    scores = {
        "file_created": 0.0,
        "mentions_jsonb": 0.0,
        "mentions_familiarity": 0.0,
        "read_decisions": 0.0,
    }
    workspace = Path(workspace_path)
    answer_file = workspace / "answer.txt"

    if answer_file.exists():
        scores["file_created"] = 1.0
        content = answer_file.read_text(encoding="utf-8").lower()
        if "jsonb" in content:
            scores["mentions_jsonb"] = 1.0
        if "familiar" in content or "ops" in content:
            scores["mentions_familiarity"] = 1.0

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
            if any("decisions.md" in str(f) for f in files) or any(
                "decisions.md" in str(p) for p in path_candidates if p
            ):
                scores["read_decisions"] = 1.0

    return scores
```
