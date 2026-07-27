---
id: task_timezone_offset_lookup
name: Tokyo UTC Offset Lookup
category: research
grading_type: automated
timeout_seconds: 120
workspace_files: []
---

## Prompt

What is the standard-time UTC offset for Tokyo (IANA timezone `Asia/Tokyo`)? Save the answer to `answer.txt`.

## Expected Behavior

The agent should:

1. Look up the UTC offset for Asia/Tokyo (Japan Standard Time)
2. Create `answer.txt` in the workspace
3. Report +9 hours (e.g. `+9`, `UTC+9`, or `+09:00`)

Japan does not observe daylight saving time, so the offset is fixed.

## Grading Criteria

- [ ] File `answer.txt` created
- [ ] File contains +9, UTC+9, or +09:00
- [ ] File mentions Tokyo or Asia/Tokyo or Japan
- [ ] Answer is non-empty

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import re

    scores = {
        "file_created": 0.0,
        "offset_correct": 0.0,
        "location_mentioned": 0.0,
        "non_empty": 0.0,
    }

    answer_file = Path(workspace_path) / "answer.txt"
    if not answer_file.exists():
        return scores

    content = answer_file.read_text(encoding="utf-8", errors="ignore")
    lowered = content.lower()
    scores["file_created"] = 1.0

    if re.search(r"(utc\s*\+?\s*9|\+09:00|\+9(:00)?|\+09)\b", content, re.IGNORECASE):
        scores["offset_correct"] = 1.0

    if (
        "tokyo" in lowered
        or "asia/tokyo" in lowered
        or "japan" in lowered
        or "jst" in lowered
    ):
        scores["location_mentioned"] = 1.0

    if len(content.strip()) >= 3:
        scores["non_empty"] = 1.0

    return scores
```
