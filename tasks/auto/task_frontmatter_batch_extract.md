---
id: task_frontmatter_batch_extract
name: Frontmatter Batch Title Extract
category: skills
grading_type: automated
timeout_seconds: 180
workspace_files:
  - path: "posts/alpha.md"
    content: |
      ---
      title: Alpha Launch Notes
      author: team
      ---

      Body of alpha post.
  - path: "posts/beta.md"
    content: |
      ---
      title: Beta Checklist
      status: draft
      ---

      Body of beta post.
  - path: "posts/gamma.md"
    content: |
      ---
      title: Gamma Retro
      date: 2026-01-09
      ---

      Body of gamma post.
---

## Prompt

Each markdown file under `posts/` has YAML frontmatter with a `title`. Write `titles.json` mapping filename (basename only) to title:

```json
{
  "alpha.md": "Alpha Launch Notes",
  "beta.md": "Beta Checklist",
  "gamma.md": "Gamma Retro"
}
```

## Expected Behavior

The agent reads all three posts, extracts YAML `title` fields, and writes the exact mapping.

## Grading Criteria

- [ ] titles.json created
- [ ] alpha.md title exact
- [ ] beta.md title exact
- [ ] gamma.md title exact

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import json

    expected = {
        "alpha.md": "Alpha Launch Notes",
        "beta.md": "Beta Checklist",
        "gamma.md": "Gamma Retro",
    }
    scores = {
        "file_created": 0.0,
        "alpha_exact": 0.0,
        "beta_exact": 0.0,
        "gamma_exact": 0.0,
    }
    workspace = Path(workspace_path)
    path = workspace / "titles.json"
    if not path.exists():
        return scores

    scores["file_created"] = 1.0
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except Exception:
        return scores

    if data.get("alpha.md") == expected["alpha.md"]:
        scores["alpha_exact"] = 1.0
    if data.get("beta.md") == expected["beta.md"]:
        scores["beta_exact"] = 1.0
    if data.get("gamma.md") == expected["gamma.md"]:
        scores["gamma_exact"] = 1.0

    return scores
```
