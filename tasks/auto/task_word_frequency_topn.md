---
id: task_word_frequency_topn
name: Top Word Frequency Analysis
category: analysis
grading_type: automated
timeout_seconds: 180
workspace_files:
  - path: "corpus.txt"
    content: |
      The river is deep and the river is wide.
      A boat is in the river and a bird is in the sky.
      The sky is blue and the river is blue.
      To sail in the river is to know the river.
---

## Prompt

Analyze word frequency in `corpus.txt`.

Rules:
1. Lowercase all words
2. Split on non-alphabetic characters (treat punctuation as separators)
3. Exclude these stopwords: `the`, `a`, `an`, `and`, `of`, `to`, `in`, `is`
4. Rank remaining words by descending frequency (ties may break alphabetically)

Write `top_words.json` with the top 5 words:

```json
{
  "top_words": [
    {"word": "river", "count": 6},
    {"word": "blue", "count": 2},
    {"word": "boat", "count": 1},
    {"word": "bird", "count": 1},
    {"word": "deep", "count": 1}
  ]
}
```

Exact ordering after `river` may vary for ties; the top word must be `river`.

## Expected Behavior

After lowercasing and stopword removal, `river` appears most often (6 times). The file should contain exactly 5 entries in the top list.

## Grading Criteria

- [ ] `top_words.json` created
- [ ] Valid JSON
- [ ] Top word is `river`
- [ ] Exactly 5 entries in the top list
- [ ] river count is 6

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import json

    scores = {
        "file_created": 0.0,
        "valid_json": 0.0,
        "top_word_river": 0.0,
        "five_entries": 0.0,
        "river_count_six": 0.0,
    }
    workspace = Path(workspace_path)
    path = workspace / "top_words.json"
    if not path.exists():
        return scores

    scores["file_created"] = 1.0
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except Exception:
        return scores

    scores["valid_json"] = 1.0

    entries = []
    if isinstance(data, dict):
        raw = data.get("top_words", data.get("words", data.get("top", [])))
        if isinstance(raw, list):
            entries = raw
        elif isinstance(raw, dict):
            # map word->count sorted
            entries = [{"word": k, "count": v} for k, v in raw.items()]
    elif isinstance(data, list):
        entries = data

    if len(entries) >= 5:
        scores["five_entries"] = 1.0
    elif len(entries) == 5:
        scores["five_entries"] = 1.0

    # Prefer exact length 5
    if len(entries) == 5:
        scores["five_entries"] = 1.0
    else:
        scores["five_entries"] = 0.0

    def word_of(item):
        if isinstance(item, str):
            return item.lower()
        if isinstance(item, dict):
            return str(item.get("word", item.get("token", ""))).lower()
        if isinstance(item, (list, tuple)) and item:
            return str(item[0]).lower()
        return ""

    def count_of(item):
        if isinstance(item, dict):
            try:
                return int(item.get("count", item.get("freq", -1)))
            except (TypeError, ValueError):
                return -1
        if isinstance(item, (list, tuple)) and len(item) >= 2:
            try:
                return int(item[1])
            except (TypeError, ValueError):
                return -1
        return -1

    if entries and word_of(entries[0]) == "river":
        scores["top_word_river"] = 1.0
    elif any(word_of(e) == "river" for e in entries[:1]):
        scores["top_word_river"] = 1.0

    for e in entries:
        if word_of(e) == "river" and count_of(e) == 6:
            scores["river_count_six"] = 1.0
            break

    return scores
```
