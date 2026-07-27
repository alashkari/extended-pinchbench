---
id: task_log_hdfs_warn_count
name: HDFS DataXceiver Receiving Block Count
category: log_analysis
grading_type: automated
timeout_seconds: 180
workspace_files:
  - source: logs/hdfs_datanode.log
    dest: hdfs_datanode.log
---

## Prompt

Count lines in `hdfs_datanode.log` containing `Receiving block`.

Write `hdfs_receiving.json` with `receiving_block_count`.

(This dataset is INFO-heavy; use Receiving block as the signal rather than WARN.)

## Expected Behavior

Count the Receiving block occurrences from the log (agent should compute from file).

## Grading Criteria

- [ ] File created
- [ ] receiving_block_count matches ground truth from the log

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import json
    import re
    scores = {"file_created": 0.0, "count": 0.0}
    # compute expected from workspace copy or fall back
    log = Path(workspace_path) / "hdfs_datanode.log"
    expected = None
    if log.exists():
        expected = len(re.findall(r"Receiving block", log.read_text(errors="ignore")))
    path = Path(workspace_path) / "hdfs_receiving.json"
    alts = list(Path(workspace_path).glob("*hdfs*.json")) + list(Path(workspace_path).glob("*warn*.json"))
    if not path.exists() and alts:
        path = alts[0]
    if not path.exists():
        return scores
    scores["file_created"] = 1.0
    try:
        data = json.loads(path.read_text())
        c = int(data.get("receiving_block_count") or data.get("count") or data.get("warn_count") or -1)
        if expected is None:
            expected = 382  # approximate fallback; prefer live
        scores["count"] = 1.0 if c == expected else (0.5 if expected and abs(c-expected)<=5 else 0.0)
    except Exception:
        pass
    return scores

```
