---
id: task_sop_checklist_writer
name: SOP Checklist Writer
category: writing
grading_type: automated
timeout_seconds: 120
workspace_files:
  - path: "procedure_notes.txt"
    content: |
      Warehouse pallet restack — rough notes from floor lead:

      - Confirm work order ID on tablet before starting
      - Put on steel-toe boots and high-vis vest (safety — do not skip)
      - Clear a 2-meter staging zone beside bay C
      - Use pallet jack only; no forklift unless certified operator present
      - Restack damaged cartons onto new pallets, label with bay + date
      - Scan each finished pallet into WMS
      - Sweep aisle and return jack to charging dock
      - Close work order and note any damaged SKUs
---

# SOP Checklist Writer

## Prompt

Read `procedure_notes.txt` and write a standard operating procedure checklist to `sop.md`.

Requirements:

1. Use a **numbered** checklist with at least **5** steps in the form `1.`, `2.`, `3.`, etc.
2. Include a **safety** step (mention safety gear such as steel-toe boots, high-vis vest, or the word `safety`).
3. Cover the core workflow from the notes (staging, restack/scan, close-out).

## Expected Behavior

The agent should convert the rough notes into a clean numbered SOP with ≥5 steps, including an explicit safety step before physical work begins.

## Grading Criteria

- [ ] File `sop.md` is created
- [ ] Has numbered steps `1.` `2.` `3.` (at least five)
- [ ] Includes a safety-related step
- [ ] Mentions pallet / restack / WMS or scan workflow keywords

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import re

    scores = {
        "file_created": 0.0,
        "has_numbered_steps": 0.0,
        "has_five_steps": 0.0,
        "has_safety_step": 0.0,
        "has_workflow_keywords": 0.0,
    }

    workspace = Path(workspace_path)
    path = workspace / "sop.md"
    if not path.exists():
        return scores

    scores["file_created"] = 1.0
    content = path.read_text(encoding="utf-8", errors="replace")
    lower = content.lower()

    numbered = re.findall(r"(?m)^\s*\d+\.\s+\S+", content)
    if len(numbered) >= 3:
        scores["has_numbered_steps"] = 1.0
    if len(numbered) >= 5:
        scores["has_five_steps"] = 1.0
    elif len(numbered) >= 3:
        scores["has_five_steps"] = 0.5

    safety_patterns = [
        r"\bsafety\b",
        r"steel-?toe",
        r"high-?vis",
        r"\bvest\b",
        r"ppe\b",
    ]
    if any(re.search(p, lower) for p in safety_patterns):
        scores["has_safety_step"] = 1.0

    keyword_hits = 0
    for kw in ["pallet", "restack", "wms", "scan", "staging", "work order"]:
        if kw in lower:
            keyword_hits += 1
    if keyword_hits >= 3:
        scores["has_workflow_keywords"] = 1.0
    elif keyword_hits >= 1:
        scores["has_workflow_keywords"] = 0.5

    return scores
```

## Additional Notes

- Numbering and keyword presence are graded; prose polish is not.
