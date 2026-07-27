---
id: task_memory_timeline_order
name: Timeline Event Ordering
category: memory
grading_type: automated
timeout_seconds: 180
workspace_files:
  - path: "events.md"
    content: |
      # Unordered Project Events

      - Kickoff workshop — 2026-02-10
      - Public launch — 2026-09-01
      - Design review — 2026-03-22
      - Beta freeze — 2026-07-15
      - Alpha release — 2026-05-01
---

## Prompt

Read `events.md`. The events are not in chronological order. Write `timeline.json` as an ordered array of event names (earliest first):

```json
{
  "events": ["Kickoff workshop", "Design review", "..."]
}
```

Use the event names exactly as written before the em dash.

## Expected Behavior

The agent parses dates, sorts ascending, and writes the ordered event names: Kickoff workshop, Design review, Alpha release, Beta freeze, Public launch.

## Grading Criteria

- [ ] timeline.json created
- [ ] Valid events array
- [ ] First event is Kickoff workshop
- [ ] Full chronological order correct

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import json

    expected = [
        "Kickoff workshop",
        "Design review",
        "Alpha release",
        "Beta freeze",
        "Public launch",
    ]
    scores = {
        "file_created": 0.0,
        "valid_array": 0.0,
        "first_correct": 0.0,
        "order_correct": 0.0,
    }
    workspace = Path(workspace_path)
    path = workspace / "timeline.json"
    if not path.exists():
        return scores

    scores["file_created"] = 1.0
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except Exception:
        return scores

    events = data.get("events") if isinstance(data, dict) else data
    if not isinstance(events, list) or not events:
        return scores

    scores["valid_array"] = 1.0
    normalized = [str(e).strip() for e in events]
    if normalized and normalized[0].lower() == expected[0].lower():
        scores["first_correct"] = 1.0
    if [e.lower() for e in normalized] == [e.lower() for e in expected]:
        scores["order_correct"] = 1.0

    return scores
```
