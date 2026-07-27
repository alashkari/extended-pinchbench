---
id: task_hybrid_bugfix_rationale
name: Bugfix With Design Rationale
category: coding
grading_type: hybrid
timeout_seconds: 260
grading_weights:
  automated: 0.7
  llm_judge: 0.3
workspace_files:
  - path: "rate_limiter.py"
    content: |
      """Token-bucket rate limiter with known bugs."""
      import time

      class RateLimiter:
          def __init__(self, rate_per_sec: float, capacity: int):
              self.rate = rate_per_sec
              self.capacity = capacity
              self.tokens = capacity
              self.updated_at = time.monotonic()

          def allow(self, cost: int = 1) -> bool:
              # BUG1: no refill
              # BUG2: does not reject cost > capacity
              if self.tokens >= cost:
                  self.tokens -= cost
                  return True
              return False

          def remaining(self) -> int:
              # BUG3: does not refill before reporting
              return int(self.tokens)
  - path: "test_rate_limiter.py"
    content: |
      import time
      from rate_limiter import RateLimiter

      def test_initial_burst():
          rl = RateLimiter(10, 5)
          assert [rl.allow() for _ in range(5)] == [True]*5
          assert rl.allow() is False

      def test_refill():
          rl = RateLimiter(10, 5)
          for _ in range(5):
              assert rl.allow()
          time.sleep(0.3)
          assert rl.allow() is True

      def test_cost_greater_than_capacity():
          rl = RateLimiter(10, 5)
          assert rl.allow(cost=6) is False
          assert rl.remaining() == 5

      def test_remaining_refills():
          rl = RateLimiter(10, 5)
          for _ in range(5):
              rl.allow()
          time.sleep(0.25)
          assert rl.remaining() >= 2
---

## Prompt

Fix `rate_limiter.py` so `test_rate_limiter.py` passes in full:
1. Refill via elapsed monotonic time: tokens = min(capacity, tokens + elapsed*rate)
2. `allow(cost)` returns False immediately if cost > capacity without consuming tokens
3. `remaining()` refills before returning int tokens

Also fix a fourth latent defect: `allow(cost)` must raise `ValueError` when `cost <= 0`
(silently accepting a zero or negative cost lets a caller mint tokens). Refill must never
push `tokens` above `capacity`, no matter how long the limiter has been idle.

Keep class/method names. Write `fix_rationale.md` (140–240 words) naming **all four bugs**
(refill, cost>capacity, remaining, non-positive cost).

Also write `bugs_fixed.json`:
```json
{"bugs":["no_refill","cost_gt_capacity","remaining_no_refill"],"bugs_csv":"no_refill,cost_gt_capacity,remaining_no_refill","n_bugs":3,"answer_fingerprint":"deadbeefcafe"}
```
Use the id `nonpositive_cost` for the fourth bug. `bugs` must contain all four ids.
`bugs_csv` must be the four ids sorted ascending, comma-separated (the example above shows
only three and is unsorted — do not copy it). `n_bugs` must be 4.
`answer_fingerprint` = sha256(bugs_csv + "|pinch")[:12] hex.

## Expected Behavior

Three-bug fix + rationale.

## Grading Criteria

- [ ] file exists
- [ ] RateLimiter class
- [ ] elapsed refill + min clamp
- [ ] monotonic used
- [ ] cost > capacity rejected
- [ ] remaining refills
- [ ] rationale file
- [ ] rationale names three bugs

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import json, re, subprocess, sys
    scores = {k:0.0 for k in ["file","class_","refill","monotonic","cost_cap","remaining","rationale","three_bugs","bugs_json","bugs_csv","n_bugs","fingerprint",
                              "suite","nonpositive","no_overfill"]}
    try:
        ws = Path(workspace_path)
        path = ws / "rate_limiter.py"
        if not path.exists():
            return scores
        scores["file"] = 1.0
        src = path.read_text(errors="replace")
        if re.search(r"class\s+RateLimiter\b", src):
            scores["class_"] = 1.0
        if re.search(r"elapsed|delta|dt", src) and re.search(r"min\s*\(.*capacity", src, re.I):
            scores["refill"] = 1.0
        if "monotonic" in src:
            scores["monotonic"] = 1.0
        if re.search(r"cost\s*>\s*self\.capacity|cost\s*>\s*capacity", src):
            scores["cost_cap"] = 1.0
        rem = re.search(r"def\s+remaining\s*\(.*?(?=\ndef\s+|\Z)", src, re.S)
        if rem and re.search(r"token|refill|elapsed|monotonic|updated_at", rem.group(0), re.I):
            scores["remaining"] = 1.0

        def pyrun(code, timeout=15):
            return subprocess.run([sys.executable, "-c", code], cwd=str(ws),
                                  capture_output=True, text=True, timeout=timeout)

        try:
            proc = pyrun(
                "import time; from rate_limiter import RateLimiter as R\n"
                "r=R(10,5)\n"
                "assert r.allow(6) is False\n"
                "assert r.remaining()==5\n"
                "for _ in range(5): assert r.allow()\n"
                "time.sleep(0.25)\n"
                "assert r.remaining()>=2\n"
                "print('ok')")
            if proc.returncode == 0 and "ok" in proc.stdout:
                scores["cost_cap"] = 1.0
                scores["remaining"] = 1.0
                scores["refill"] = 1.0
        except Exception:
            pass

        # The shipped test suite must actually pass.
        try:
            proc = subprocess.run([sys.executable, "-m", "pytest", "-q", "test_rate_limiter.py"],
                                  cwd=str(ws), capture_output=True, text=True, timeout=90)
            if proc.returncode == 0:
                scores["suite"] = 1.0
        except Exception:
            pass

        # Non-positive cost must raise ValueError rather than mint tokens.
        try:
            proc = pyrun(
                "from rate_limiter import RateLimiter as R\n"
                "r=R(10,5)\n"
                "for bad in (0,-1):\n"
                "    try:\n"
                "        r.allow(bad)\n"
                "    except ValueError:\n"
                "        continue\n"
                "    raise SystemExit('no raise')\n"
                "print('ok')")
            if proc.returncode == 0 and "ok" in proc.stdout:
                scores["nonpositive"] = 1.0
        except Exception:
            pass

        # Idle refill must clamp at capacity.
        try:
            proc = pyrun(
                "import time; from rate_limiter import RateLimiter as R\n"
                "r=R(100,5)\n"
                "assert r.allow(5)\n"
                "time.sleep(0.4)\n"
                "assert r.remaining()==5, r.remaining()\n"
                "assert r.allow(5) is True\n"
                "assert r.allow(1) is False\n"
                "print('ok')")
            if proc.returncode == 0 and "ok" in proc.stdout:
                scores["no_overfill"] = 1.0
        except Exception:
            pass

        rat = ws / "fix_rationale.md"
        if rat.exists():
            scores["rationale"] = 1.0
            t = rat.read_text(errors="replace").lower()
            hits = sum(1 for k in ["refill", "capacity", "remaining", "cost"] if k in t)
            negative = re.search(r"non-?positive|zero or negative|<=\s*0|negative cost", t)
            if hits >= 4 and negative and len(t.split()) >= 100:
                scores["three_bugs"] = 1.0

        bj = ws / "bugs_fixed.json"
        if bj.exists():
            try:
                data = json.loads(bj.read_text())
                scores["bugs_json"] = 1.0
                expected = {"no_refill", "cost_gt_capacity", "remaining_no_refill", "nonpositive_cost"}
                if str(data.get("bugs_csv") or "") == ",".join(sorted(expected)):
                    scores["bugs_csv"] = 1.0
                if int(data.get("n_bugs") or 0) == 4 and set(data.get("bugs") or []) == expected:
                    scores["n_bugs"] = 1.0
                if str(data.get("answer_fingerprint") or "") == "2b111ccf6d45":
                    scores["fingerprint"] = 1.0
            except Exception:
                pass
    except Exception:
        pass
    return scores
```


## LLM Judge Rubric

**SCORING RULE (mandatory):** Default each criterion to **0.25**. Award **0.5** only if the deliverable cites ≥2 exact fixture-specific values (IDs, counts, dates, percentages, paths, or fingerprints from the workspace). Award **0.75** only with those citations plus explicit discussion of a non-obvious constraint, exception, tradeoff, or tie-break. Reserve **1.0** for unusually strong fixture-grounded judgment — never for fluent summaries of structurally correct JSON. Generic or padded prose stays at **0.25** even when automated checks pass.


### Criterion 1: Technical Accuracy (Weight: 40%)

**Score 1.0**: Explains all three bugs and elapsed refill correctly.
**Score 0.75**: Two bugs clear.
**Score 0.5**: Partial.
**Score 0.25**: Wrong.
**Score 0.0**: Missing.

### Criterion 2: Engineering Communication (Weight: 35%)

**Score 1.0**: PR-ready rationale.
**Score 0.75**: Clear.
**Score 0.5**: Messy.
**Score 0.25**: Hard to follow.
**Score 0.0**: Unusable.

### Criterion 3: Completeness (Weight: 25%)

**Score 1.0**: Covers bugs+fix+design without fluff.
**Score 0.75**: Mostly.
**Score 0.5**: Gaps.
**Score 0.25**: Incomplete.
**Score 0.0**: Empty.

## Additional Notes

Hardened hybrid task: 70% automated traps, 30% strict LLM quality.
