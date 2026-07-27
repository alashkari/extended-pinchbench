---
id: task_hybrid_cli_design_doc
name: CLI Tool Implementation And Design Doc
category: coding
grading_type: hybrid
timeout_seconds: 260
grading_weights:
  automated: 0.7
  llm_judge: 0.3
workspace_files:
  - path: "requirements.txt"
    content: |
      # stdlib only
---

## Prompt

Create `csv_cut.py` (stdlib only) that:
- argv1 = CSV path
- `--cols a,b` required
- optional `--where col=value` keeps rows where col equals value (string match)
- prints selected columns as CSV to stdout, **including a header row**
- output columns must appear in the exact order given to `--cols` (not the file's column order)
- exit codes: 2 missing file, 3 missing column, 4 invalid `--where`, 1 other error; messages on stderr

An invalid `--where` means the argument has no `=` separator (e.g. `--where region`). A `--where` naming a
column that does not exist is a **missing column** error (exit 3), not an invalid `--where`. A `--where` that
matches zero rows is **not** an error: print only the header and exit 0.

Also create `sample.csv`:
```
name,region,revenue
Ada,EMEA,10
Bea,NA,15
Cara,EMEA,7
```

And `design.md` (140–240 words) with an **Exit codes** section listing 2/3/4.

## Expected Behavior

Working CLI with where filter + exit codes documented.

## Grading Criteria

- [ ] csv_cut.py exists
- [ ] argparse/sys.argv and --cols
- [ ] --where supported
- [ ] csv module
- [ ] stderr + exit codes 2/3/4 mentioned in code
- [ ] sample.csv present
- [ ] design.md has exit codes
- [ ] functional where filter works

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import re, subprocess, sys
    scores = {k:0.0 for k in ["script","cols","where","csvmod","exits","sample","design","works",
                              "header","col_order","exit2","exit3","exit4","empty_ok"]}
    try:
        ws = Path(workspace_path)
        script = ws / "csv_cut.py"
        if not script.exists():
            return scores
        scores["script"] = 1.0
        src = script.read_text(errors="replace")
        if re.search(r"--cols|cols", src): scores["cols"] = 1.0
        if re.search(r"--where|where", src): scores["where"] = 1.0
        if re.search(r"import\s+csv|from\s+csv", src): scores["csvmod"] = 1.0
        if re.search(r"\b2\b", src) and re.search(r"\b3\b", src) and re.search(r"stderr|sys\.stderr", src):
            scores["exits"] = 1.0

        sample = ws / "sample.csv"
        if not (sample.exists() and "revenue" in sample.read_text(errors="replace")):
            return scores
        scores["sample"] = 1.0

        def run(*args, timeout=8):
            return subprocess.run([sys.executable, str(script)] + [str(a) for a in args],
                                  capture_output=True, text=True, timeout=timeout, cwd=str(ws))

        try:
            proc = run(sample, "--cols", "name,revenue", "--where", "region=EMEA")
            out = proc.stdout.lower()
            if proc.returncode == 0 and "ada" in out and "cara" in out and "bea" not in out:
                scores["works"] = 1.0
                scores["where"] = 1.0
            lines = [l for l in proc.stdout.splitlines() if l.strip()]
            if lines and re.search(r"\bname\b", lines[0], re.I) and re.search(r"\brevenue\b", lines[0], re.I):
                scores["header"] = 1.0
        except Exception:
            pass

        # --cols order must be honoured, not the file's column order.
        try:
            proc = run(sample, "--cols", "revenue,name")
            lines = [l for l in proc.stdout.splitlines() if l.strip()]
            if proc.returncode == 0 and len(lines) >= 2:
                hdr = [c.strip().lower() for c in lines[0].split(",")]
                row = [c.strip().lower() for c in lines[1].split(",")]
                if hdr[:2] == ["revenue", "name"] and row[:2] == ["10", "ada"]:
                    scores["col_order"] = 1.0
        except Exception:
            pass

        try:
            if run(ws / "no_such_file.csv", "--cols", "name").returncode == 2:
                scores["exit2"] = 1.0
        except Exception:
            pass
        try:
            if run(sample, "--cols", "name,nope").returncode == 3:
                scores["exit3"] = 1.0
        except Exception:
            pass
        try:
            if run(sample, "--cols", "name", "--where", "region").returncode == 4:
                scores["exit4"] = 1.0
        except Exception:
            pass
        # Zero matching rows is success with a header-only body, not an error.
        try:
            proc = run(sample, "--cols", "name", "--where", "region=ZZZ")
            body = [l for l in proc.stdout.splitlines() if l.strip()]
            if proc.returncode == 0 and len(body) == 1:
                scores["empty_ok"] = 1.0
        except Exception:
            pass

        design = ws / "design.md"
        if design.exists():
            text = design.read_text(errors="replace")
            if (re.search(r"exit\s*codes", text, re.I) and re.search(r"\b2\b", text)
                    and re.search(r"\b3\b", text) and re.search(r"\b4\b", text)
                    and re.search(r"pip|stdout|stderr", text, re.I)):
                scores["design"] = 1.0
    except Exception:
        pass
    return scores
```


## LLM Judge Rubric

**SCORING RULE (mandatory):** Default each criterion to **0.25**. Award **0.5** only if the deliverable cites ≥2 exact fixture-specific values (IDs, counts, dates, percentages, paths, or fingerprints from the workspace). Award **0.75** only with those citations plus explicit discussion of a non-obvious constraint, exception, tradeoff, or tie-break. Reserve **1.0** for unusually strong fixture-grounded judgment — never for fluent summaries of structurally correct JSON. Generic or padded prose stays at **0.25** even when automated checks pass.


### Criterion 1: Design Judgment (Weight: 40%)

**Score 1.0**: Unix CLI UX with clear exit-code rationale and piping.
**Score 0.75**: Solid.
**Score 0.5**: Generic.
**Score 0.25**: Weak.
**Score 0.0**: Missing.

### Criterion 2: Clarity (Weight: 35%)

**Score 1.0**: Precise for another engineer.
**Score 0.75**: Clear.
**Score 0.5**: Muddy.
**Score 0.25**: Unclear.
**Score 0.0**: Unusable.

### Criterion 3: Practicality (Weight: 25%)

**Score 1.0**: Matches implemented tool including --where.
**Score 0.75**: Mostly.
**Score 0.5**: Partial.
**Score 0.25**: Impractical.
**Score 0.0**: None.

## Additional Notes

Hardened hybrid task: 70% automated traps, 30% strict LLM quality.
