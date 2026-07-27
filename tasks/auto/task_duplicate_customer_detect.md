---
id: task_duplicate_customer_detect
name: Duplicate Customer Detection
category: analysis
grading_type: automated
timeout_seconds: 180
workspace_files:
  - path: "customers.json"
    content: |
      {
        "customers": [
          {"id": "C1", "name": "Alice Nguyen", "email": "alice@example.com", "phone": "555-0100"},
          {"id": "C2", "name": "Bob Smith", "email": "bob@example.com", "phone": "555-0200"},
          {"id": "C3", "name": "A. Nguyen", "email": "alice@example.com", "phone": "555-0199"},
          {"id": "C4", "name": "Carol Lee", "email": "carol@example.com", "phone": "555-0300"},
          {"id": "C5", "name": "Robert Smith", "email": "r.smith@example.com", "phone": "555-0200"},
          {"id": "C6", "name": "Dan Park", "email": "dan@example.com", "phone": "555-0400"}
        ]
      }
---

## Prompt

Find duplicate customers in `customers.json`. Treat two records as duplicates if they share the same `email` **or** the same `phone` (case-insensitive email match).

Write `duplicates.json` listing duplicate groups. Each group should include the customer ids that share an email or phone:

```json
{
  "groups": [
    {"match_on": "email", "value": "alice@example.com", "customer_ids": ["C1", "C3"]},
    {"match_on": "phone", "value": "555-0200", "customer_ids": ["C2", "C5"]}
  ]
}
```

Structure may vary, but the known duplicate emails and phones must be detectable from the output.

## Expected Behavior

- Email `alice@example.com` shared by C1 and C3
- Phone `555-0200` shared by C2 and C5
- C4 and C6 are unique

## Grading Criteria

- [ ] `duplicates.json` created
- [ ] Valid JSON
- [ ] alice@example.com duplicate group flagged (C1 and C3)
- [ ] 555-0200 phone duplicate flagged (C2 and C5)
- [ ] Unique customers C4/C6 not falsely grouped together

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import json
    import re

    scores = {
        "file_created": 0.0,
        "valid_json": 0.0,
        "email_alice_flagged": 0.0,
        "phone_5550200_flagged": 0.0,
        "uniques_not_grouped": 0.0,
    }
    workspace = Path(workspace_path)
    path = workspace / "duplicates.json"
    if not path.exists():
        return scores

    scores["file_created"] = 1.0
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except Exception:
        return scores

    scores["valid_json"] = 1.0
    text = json.dumps(data).lower()

    # Email duplicate: alice@example.com with both C1 and C3 nearby in output
    has_alice_email = "alice@example.com" in text
    has_c1 = bool(re.search(r"\bc1\b", text))
    has_c3 = bool(re.search(r"\bc3\b", text))
    scores["email_alice_flagged"] = 1.0 if (has_alice_email and has_c1 and has_c3) else 0.0

    # Phone duplicate
    has_phone = "555-0200" in text or "5550200" in text.replace("-", "")
    has_c2 = bool(re.search(r"\bc2\b", text))
    has_c5 = bool(re.search(r"\bc5\b", text))
    scores["phone_5550200_flagged"] = 1.0 if (has_phone and has_c2 and has_c5) else 0.0

    # C4 and C6 should not appear together in a group of size 2 with only those two.
    # Soft check: if output lists groups, ensure no group is exactly {C4, C6}.
    groups = []
    if isinstance(data, dict):
        groups = data.get("groups", data.get("duplicates", []))
    elif isinstance(data, list):
        groups = data

    false_pair = False
    if isinstance(groups, list):
        for g in groups:
            ids = []
            if isinstance(g, dict):
                raw = g.get("customer_ids", g.get("ids", g.get("members", [])))
                if isinstance(raw, list):
                    ids = [str(x).upper() for x in raw]
            elif isinstance(g, list):
                ids = [str(x).upper() for x in g]
            if set(ids) == {"C4", "C6"}:
                false_pair = True
    scores["uniques_not_grouped"] = 0.0 if false_pair else 1.0
    return scores
```
