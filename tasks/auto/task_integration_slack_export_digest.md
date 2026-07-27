---
id: task_integration_slack_export_digest
name: Slack Export Digest
category: integrations
grading_type: automated
timeout_seconds: 180
workspace_files:
  - path: "slack_export.json"
    content: |
      {
        "channel": "eng-platform",
        "messages": [
          {"user": "alice", "text": "Deploy window opens at 2pm", "ts": "1722000001.000100"},
          {"user": "bob", "text": "Ack, I'll watch the canary", "ts": "1722000060.000200"},
          {"user": "alice", "text": "Canary looks green", "ts": "1722000120.000300"},
          {"user": "carol", "text": "Any rollback plan?", "ts": "1722000180.000400"},
          {"user": "alice", "text": "Rollback is tag v1.8.2", "ts": "1722000240.000500"},
          {"user": "bob", "text": "Promoting to prod", "ts": "1722000300.000600"},
          {"user": "alice", "text": "Done. Closing the channel thread.", "ts": "1722000360.000700"}
        ]
      }
---

## Prompt

Read the Slack channel export at `slack_export.json`. Write a short digest to `digest.md` that includes:

1. The channel name
2. The total message count
3. The top poster (user with the most messages; if tied, any tied user is fine — this fixture has a clear winner)

State the facts clearly in the markdown (channel name, count, and top poster username must appear in the file).

## Expected Behavior

The agent parses the export, counts 7 messages in channel `eng-platform`, identifies `alice` as top poster (4 messages), and writes those facts into `digest.md`.

## Grading Criteria

- [ ] digest.md exists
- [ ] Channel name eng-platform present
- [ ] Message count 7 present
- [ ] Top poster alice present

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import re

    scores = {
        "file_created": 0.0,
        "channel_name": 0.0,
        "message_count": 0.0,
        "top_poster": 0.0,
    }
    workspace = Path(workspace_path)
    path = workspace / "digest.md"
    if not path.exists():
        return scores

    scores["file_created"] = 1.0
    text = path.read_text(encoding="utf-8", errors="replace")
    lowered = text.lower()

    if "eng-platform" in lowered:
        scores["channel_name"] = 1.0

    if re.search(r"\b7\b", text) or re.search(r"seven", lowered):
        scores["message_count"] = 1.0

    if re.search(r"\balice\b", lowered):
        scores["top_poster"] = 1.0

    return scores
```

## Additional Notes

- Fixture-only Slack export; no live Slack API.
