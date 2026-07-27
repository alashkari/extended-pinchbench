---
id: task_markdown_toc_generator
name: Markdown TOC Generator
category: coding
grading_type: automated
timeout_seconds: 180
workspace_files:
  - path: "article.md"
    content: |
      # Building Reliable Agents

      An introduction to evaluation and tooling.

      ## Motivation

      Why benchmarks matter for agent systems.

      ### Real-world tasks

      Agents face messy, multi-step goals.

      ### Measurable outcomes

      Success should be graded, not guessed.

      ## Design Principles

      Keep prompts clear and graders objective.

      ### Automated checks

      Prefer file and AST checks when possible.

      ### Human judgment

      Use LLM judges for nuance.

      ## Conclusion

      Combine both grading styles for coverage.
---

# Markdown TOC Generator

## Prompt

The workspace contains `article.md` with `#`, `##`, and `###` headings.

Write `toc.py` that:

1. Reads `article.md`
2. Generates a table of contents for `##` and `###` headings (you may include `#` as well)
3. Writes the result to `toc.md` using Markdown links of the form `[Heading Text](#anchor)`

Anchor style should follow common GitHub-like rules (lowercase, spaces to hyphens) or an equivalent consistent scheme.

## Expected Behavior

The agent creates `toc.py` that reads `article.md`, finds heading lines matching `##` / `###` patterns, and writes `toc.md` with linked TOC entries.

## Grading Criteria

- [ ] File `toc.py` exists
- [ ] File contains valid Python syntax
- [ ] Reads `article.md`
- [ ] Writes `toc.md`
- [ ] Matches heading patterns (`##` / `###`)
- [ ] Produces Markdown link anchors

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import ast
    import re

    scores = {
        "file_exists": 0.0,
        "valid_python": 0.0,
        "reads_article": 0.0,
        "writes_toc": 0.0,
        "heading_patterns": 0.0,
        "markdown_links": 0.0,
    }

    workspace = Path(workspace_path)
    script = workspace / "toc.py"
    if not script.exists():
        return scores

    scores["file_exists"] = 1.0
    content = script.read_text(encoding="utf-8")

    try:
        ast.parse(content)
        scores["valid_python"] = 1.0
    except SyntaxError:
        return scores

    if re.search(r"article\.md", content):
        scores["reads_article"] = 1.0

    if re.search(r"toc\.md", content):
        scores["writes_toc"] = 1.0

    if re.search(r"##+|startswith\s*\(\s*['\"]#|re\.(search|match|findall).*#", content):
        scores["heading_patterns"] = 1.0

    if re.search(r"\[.*\]\(#|f?['\"].*\]\(#|href|#\{", content) or re.search(
        r"\]\(#", content
    ):
        scores["markdown_links"] = 1.0
    else:
        toc_out = workspace / "toc.md"
        if toc_out.exists() and re.search(r"\[.+\]\(#.+\)", toc_out.read_text(encoding="utf-8")):
            scores["markdown_links"] = 1.0

    return scores
```

## Additional Notes

- Article includes nested `##` and `###` headings under a single H1.
- TOC nesting (indentation) is nice-to-have but not required for full credit.
