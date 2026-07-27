---
id: task_press_release_boilerplate
name: Press Release Boilerplate
category: writing
grading_type: automated
timeout_seconds: 120
workspace_files:
  - path: "facts.json"
    content: |
      {
        "company": "Nimbus Analytics",
        "product": "SignalBoard Pro",
        "date": "2026-09-15",
        "quote": "SignalBoard Pro finally gives mid-market teams enterprise-grade alerting without the enterprise tax.",
        "spokesperson": "Maya Chen, CEO",
        "contact": "press@nimbusanalytics.example"
      }
---

# Press Release Boilerplate

## Prompt

Read `facts.json` and write a press release to `press_release.md`.

Required elements:

1. The header phrase `FOR IMMEDIATE RELEASE`
2. The company name from the facts file
3. The product name
4. The provided quote (or a clearly attributed version of it)
5. The press contact email

## Expected Behavior

The agent should assemble a short press-release-style document that opens with FOR IMMEDIATE RELEASE and includes company, product, quote, and contact from `facts.json`.

## Grading Criteria

- [ ] File `press_release.md` is created
- [ ] Contains FOR IMMEDIATE RELEASE
- [ ] Mentions company name
- [ ] Mentions product name
- [ ] Includes the quote text
- [ ] Includes contact email

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path

    scores = {
        "file_created": 0.0,
        "has_immediate_release": 0.0,
        "has_company": 0.0,
        "has_product": 0.0,
        "has_quote": 0.0,
        "has_contact": 0.0,
    }

    workspace = Path(workspace_path)
    path = workspace / "press_release.md"
    if not path.exists():
        return scores

    scores["file_created"] = 1.0
    content = path.read_text(encoding="utf-8", errors="replace")
    lower = content.lower()

    if "for immediate release" in lower:
        scores["has_immediate_release"] = 1.0
    if "nimbus analytics" in lower:
        scores["has_company"] = 1.0
    if "signalboard pro" in lower:
        scores["has_product"] = 1.0
    if "enterprise-grade alerting" in lower or "without the enterprise tax" in lower:
        scores["has_quote"] = 1.0
    if "press@nimbusanalytics.example" in lower:
        scores["has_contact"] = 1.0

    return scores
```

## Additional Notes

- Required-string presence only; journalism quality is not graded.
