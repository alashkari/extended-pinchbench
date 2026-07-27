---
id: task_json_to_user_story
name: JSON to User Story
category: writing
grading_type: automated
timeout_seconds: 120
workspace_files:
  - path: "requirement.json"
    content: |
      {
        "role": "project manager",
        "goal": "filter tasks by assignee and due date",
        "benefit": "I can quickly find overdue work for each teammate",
        "acceptance_criteria": [
          "User can select one or more assignees from a dropdown",
          "User can set a due-date range filter",
          "Filtered results update without a full page reload",
          "Clear Filters resets assignee and due-date selections"
        ]
      }
---

# JSON to User Story

## Prompt

Read `requirement.json` and write a user story to `user_story.md`.

The story must include these phrases (case-insensitive is fine for grading, but prefer the standard form):

- `As a`
- `I want`
- `So that`

Also include an **Acceptance Criteria** section with a markdown checklist (lines using `- [ ]` or `- [x]`) covering the criteria from the JSON.

## Expected Behavior

The agent should transform the JSON fields into a classic user story:

- As a project manager
- I want to filter tasks by assignee and due date
- So that I can quickly find overdue work for each teammate

Plus an Acceptance Criteria checklist with the four criteria from the input.

## Grading Criteria

- [ ] File `user_story.md` is created
- [ ] Contains "As a"
- [ ] Contains "I want"
- [ ] Contains "So that"
- [ ] Contains Acceptance Criteria heading
- [ ] Contains checklist items (`- [ ]` or `- [x]`)

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import re

    scores = {
        "file_created": 0.0,
        "has_as_a": 0.0,
        "has_i_want": 0.0,
        "has_so_that": 0.0,
        "has_acceptance_criteria": 0.0,
        "has_checklist": 0.0,
    }

    workspace = Path(workspace_path)
    path = workspace / "user_story.md"
    if not path.exists():
        return scores

    scores["file_created"] = 1.0
    content = path.read_text(encoding="utf-8", errors="replace")
    lower = content.lower()

    if re.search(r"\bas a\b", lower):
        scores["has_as_a"] = 1.0
    if re.search(r"\bi want\b", lower):
        scores["has_i_want"] = 1.0
    if re.search(r"\bso that\b", lower):
        scores["has_so_that"] = 1.0
    if re.search(r"acceptance\s+criteria", lower):
        scores["has_acceptance_criteria"] = 1.0
    if re.search(r"(?m)^\s*-\s*\[(?: |x|X)\]\s+\S", content):
        scores["has_checklist"] = 1.0

    return scores
```

## Additional Notes

- Phrase presence and checklist syntax are graded; prose quality is not.
