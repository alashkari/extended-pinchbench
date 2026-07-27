---
id: task_skill_dependency_graph
name: Skill Dependency Graph Edges
category: skills
grading_type: automated
timeout_seconds: 180
workspace_files:
  - path: "skills_index.json"
    content: |
      {
        "skills": [
          {"name": "core-utils", "depends_on": []},
          {"name": "file-ops", "depends_on": ["core-utils"]},
          {"name": "web-fetch", "depends_on": ["core-utils"]},
          {"name": "report-builder", "depends_on": ["file-ops", "web-fetch"]},
          {"name": "dashboard", "depends_on": ["report-builder"]}
        ]
      }
---

## Prompt

Read `skills_index.json`. Write `edges.json` as a list of dependency edges `[from, to]` meaning `from` depends on `to`:

```json
{
  "edges": [
    ["file-ops", "core-utils"],
    ["web-fetch", "core-utils"]
  ]
}
```

Include every dependency edge. Order of edges does not matter.

## Expected Behavior

The agent expands `depends_on` into edges and writes all five edges:
- file-ops → core-utils
- web-fetch → core-utils
- report-builder → file-ops
- report-builder → web-fetch
- dashboard → report-builder

## Grading Criteria

- [ ] edges.json created
- [ ] Valid edges list
- [ ] All expected edges present
- [ ] No unexpected edges

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import json

    expected = {
        ("file-ops", "core-utils"),
        ("web-fetch", "core-utils"),
        ("report-builder", "file-ops"),
        ("report-builder", "web-fetch"),
        ("dashboard", "report-builder"),
    }
    scores = {
        "file_created": 0.0,
        "valid_edges": 0.0,
        "all_expected": 0.0,
        "no_extras": 0.0,
    }
    workspace = Path(workspace_path)
    path = workspace / "edges.json"
    if not path.exists():
        return scores

    scores["file_created"] = 1.0
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except Exception:
        return scores

    edges = data.get("edges") if isinstance(data, dict) else data
    if not isinstance(edges, list):
        return scores

    scores["valid_edges"] = 1.0
    got = set()
    for e in edges:
        if isinstance(e, (list, tuple)) and len(e) == 2:
            got.add((str(e[0]), str(e[1])))

    if expected.issubset(got):
        scores["all_expected"] = 1.0
    if got and got.issubset(expected):
        scores["no_extras"] = 1.0
    elif got == expected:
        scores["no_extras"] = 1.0

    return scores
```
