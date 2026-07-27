---
id: task_tool_allowlist_filter
name: Tool Allowlist Filter
category: skills
grading_type: automated
timeout_seconds: 120
workspace_files:
  - path: "tools.json"
    content: |
      {
        "tools": [
          "read",
          "write",
          "bash",
          "web_search",
          "browser",
          "edit",
          "apply_patch",
          "memory_search"
        ]
      }
  - path: "allowlist.txt"
    content: |
      read
      write
      edit
      apply_patch
---

## Prompt

Filter `tools.json` using `allowlist.txt`. Write `allowed_tools.json` as a JSON array of tool names that appear in both sources, preserving the order from `tools.json`:

```json
["read", "write", "edit", "apply_patch"]
```

## Expected Behavior

The agent intersects the tools list with the allowlist and writes the exact ordered array of allowed names.

## Grading Criteria

- [ ] allowed_tools.json created
- [ ] Exact ordered list of names

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import json

    expected = ["read", "write", "edit", "apply_patch"]
    scores = {
        "file_created": 0.0,
        "exact_names": 0.0,
    }
    workspace = Path(workspace_path)
    path = workspace / "allowed_tools.json"
    if not path.exists():
        return scores

    scores["file_created"] = 1.0
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except Exception:
        return scores

    if isinstance(data, dict):
        data = data.get("allowed_tools", data.get("tools", data.get("allowed", [])))

    if data == expected:
        scores["exact_names"] = 1.0
    elif isinstance(data, list) and set(data) == set(expected) and all(
        isinstance(x, str) for x in data
    ):
        # partial credit if unordered but same set
        scores["exact_names"] = 0.5

    return scores
```
