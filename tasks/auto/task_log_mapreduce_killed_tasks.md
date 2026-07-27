---
id: task_log_mapreduce_killed_tasks
name: MapReduce Killed Task Mentions
category: log_analysis
grading_type: automated
timeout_seconds: 180
workspace_files:
  - source: logs/hadoop_mapreduce.log
    dest: hadoop_mapreduce.log
---

## Prompt

Count case-insensitive occurrences of the word `killed` in `hadoop_mapreduce.log`.

Write `killed_tasks.json` with `killed_count`.

## Expected Behavior

Expected killed_count is 26.

## Grading Criteria

- [ ] File created
- [ ] killed_count is 26

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import json
    scores = {"file_created": 0.0, "count": 0.0}
    path = Path(workspace_path) / "killed_tasks.json"
    if not path.exists():
        return scores
    scores["file_created"] = 1.0
    try:
        data = json.loads(path.read_text())
        c = int(data.get("killed_count") or data.get("count") or -1)
        scores["count"] = 1.0 if c == 26 else (0.5 if abs(c-26)<=2 else 0.0)
    except Exception:
        pass
    return scores

```
