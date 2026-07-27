---
id: task_hybrid_ssh_threat_brief
name: SSH Threat Intelligence Brief
category: log_analysis
grading_type: hybrid
timeout_seconds: 260
grading_weights:
  automated: 0.7
  llm_judge: 0.3
workspace_files:
  - source: logs/openssh_auth.log
    dest: openssh_auth.log
---

## Prompt

Analyze `openssh_auth.log`.

Count:
- failed_password_attempts from lines matching `Failed password`
- invalid_user_attempts from `Invalid user`
- root_failed_password_attempts where failed password target user is root
- top_source_ips: top 5 IPs by failed-password count
- top_targeted_usernames: top 3 usernames by failed-password count (include `root`)

Write `ssh_threat.json` with those fields plus `distinct_source_ips_failed`, plus:
- `top_users_csv`: top 3 usernames comma-separated in rank order
- `top_ip`: the #1 failed-password source IP as a string
- `controls_count`: integer count of numbered controls in the brief (must be >=3)

Write `ssh_threat_brief.md` (160–260 words) with controls prioritized as a numbered list 1..N (at least 3), starting with disable root password SSH / key-only.

## Expected Behavior

Approx failed 365, invalid 99, root 231, top IP 183.62.140.253.

## Grading Criteria

- [ ] json created
- [ ] failed ~365
- [ ] invalid ~99
- [ ] root ~231
- [ ] top ip correct
- [ ] top user root first
- [ ] distinct ips > 0
- [ ] brief numbered controls starting with root/key

## Automated Checks

```python
def grade(transcript: list, workspace_path: str) -> dict:
    from pathlib import Path
    import json, re
    from collections import Counter
    scores = {k:0.0 for k in ["json_file","failed","invalid","root","topip","topuser","distinct","users_csv","top_ip_str","controls_n","brief"]}
    try:
        ws = Path(workspace_path)
        p = ws / "ssh_threat.json"
        log = ws / "openssh_auth.log"
        if not p.exists():
            return scores
        scores["json_file"]=1.0
        data=json.loads(p.read_text())
        text = log.read_text(errors="replace") if log.exists() else ""
        failed=list(re.finditer(r"Failed password for (?:invalid user )?(\S+) from (\d+\.\d+\.\d+\.\d+)", text))
        invalid=list(re.finditer(r"Invalid user (\S+) from (\d+\.\d+\.\d+\.\d+)", text))
        cip=Counter(m.group(2) for m in failed); cuser=Counter(m.group(1) for m in failed)
        root=sum(1 for m in failed if m.group(1)=="root")
        try:
            if int(data.get("failed_password_attempts"))==len(failed): scores["failed"]=1.0
        except Exception: pass
        try:
            if int(data.get("invalid_user_attempts"))==len(invalid): scores["invalid"]=1.0
        except Exception: pass
        try:
            if int(data.get("root_failed_password_attempts"))==root: scores["root"]=1.0
        except Exception: pass
        tops=data.get("top_source_ips") or []
        if tops and cip and str(tops[0].get("ip",""))==cip.most_common(1)[0][0]:
            scores["topip"]=1.0
        users=data.get("top_targeted_usernames") or []
        if users:
            u0=users[0].get("user") if isinstance(users[0],dict) else users[0]
            if str(u0)=="root": scores["topuser"]=1.0
        try:
            if int(data.get("distinct_source_ips_failed"))==len(cip): scores["distinct"]=1.0
        except Exception: pass
        true_users=[u for u,_ in cuser.most_common(3)]
        if true_users and str(data.get("top_users_csv") or "") == ",".join(true_users):
            scores["users_csv"]=1.0
        if cip and str(data.get("top_ip") or "") == cip.most_common(1)[0][0]:
            scores["top_ip_str"]=1.0
        brief=ws/"ssh_threat_brief.md"
        if brief.exists():
            bt=brief.read_text(errors="replace")
            nums=re.findall(r"(?m)^\s*\d+[\).]\s+\S+", bt)
            try:
                if int(data.get("controls_count") or 0)==len(nums) and len(nums)>=3:
                    scores["controls_n"]=1.0
            except Exception: pass
            if re.search(r"(?m)^\s*1[\).].*(root|key)", bt, re.I) and len(bt.split())>=120:
                scores["brief"]=1.0
    except Exception:
        pass
    return scores
```


## LLM Judge Rubric

**SCORING RULE (mandatory):** Default each criterion to **0.25**. Award **0.5** only if the deliverable cites ≥2 exact fixture-specific values (IDs, counts, dates, percentages, paths, or fingerprints from the workspace). Award **0.75** only with those citations plus explicit discussion of a non-obvious constraint, exception, tradeoff, or tie-break. Reserve **1.0** for unusually strong fixture-grounded judgment — never for fluent summaries of structurally correct JSON. Generic or padded prose stays at **0.25** even when automated checks pass.


### Criterion 1: Security Prioritization (Weight: 40%)

**Score 1.0**: Numbered controls; root/key-first is correct.
**Score 0.75**: Good priority.
**Score 0.5**: Laundry list.
**Score 0.25**: Misguided.
**Score 0.0**: Missing.

### Criterion 2: Threat Narrative (Weight: 35%)

**Score 1.0**: Grounded in counts/IPs/usernames.
**Score 0.75**: Mostly clear.
**Score 0.5**: Generic.
**Score 0.25**: Confused.
**Score 0.0**: None.

### Criterion 3: Brief Quality (Weight: 25%)

**Score 1.0**: Exec/security-ops ready.
**Score 0.75**: Good.
**Score 0.5**: Uneven.
**Score 0.25**: Poor.
**Score 0.0**: Unusable.

## Additional Notes

Hardened hybrid task: 70% automated traps, 30% strict LLM quality.
