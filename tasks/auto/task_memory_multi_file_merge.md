---
id: task_memory_multi_file_merge
name: Multi-File Memory Merge
category: memory
grading_type: automated
timeout_seconds: 180
workspace_files:
  - path: "team.md"
    content: |
      # Team

      Project lead: Alex Rivera
      Backend: Mina Cho
      Frontend: Chris Patel
  - path: "timeline.md"
    content: |
      # Timeline

      Kickoff: 2026-04-15
      Feature freeze: 2026-08-01
      Launch: 2026-09-01
  - path: "risks.md"
    content: |
      # Risks

      Top risk: vendor lock-in
      Secondary: staffing gaps in Q3
      Mitigations under review.
---

## Prompt

Read `team.md`, `timeline.md`, and `risks.md`. Write a synthesis file `synthesis.json` with these exact keys:

```json
{
  "lead": "...",
  "launch": "...",
  "top_risk": "..."
}
```

Use the values found in the notes (lead name, launch date, top risk).

## Expected Behavior

The agent reads all three files and writes `synthesis.json` with lead Alex (or Alex Rivera), launch `2026-09-01`, and top_risk mentioning vendor lock-in.

## Grading Criteria

- [ ] synthesis.json created
- [ ] lead is correct
- [ ] launch is 2026-09-01
- [ ] top_risk mentions vendor lock-in

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import json

    scores = {
        "file_created": 0.0,
        "lead_correct": 0.0,
        "launch_correct": 0.0,
        "top_risk_correct": 0.0,
    }
    workspace = Path(workspace_path)
    path = workspace / "synthesis.json"
    if not path.exists():
        return scores

    scores["file_created"] = 1.0
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except Exception:
        return scores

    lead = str(data.get("lead", "")).lower()
    if "alex" in lead:
        scores["lead_correct"] = 1.0

    launch = str(data.get("launch", ""))
    if "2026-09-01" in launch:
        scores["launch_correct"] = 1.0

    top_risk = str(data.get("top_risk", "")).lower()
    if "vendor" in top_risk and "lock" in top_risk:
        scores["top_risk_correct"] = 1.0

    return scores
```
