# 🦀 Extended PinchBench

Extended PinchBench expands the [PinchBench](https://github.com/pinchbench/skill) agent benchmark with **132 tasks across 11 categories**: **110 automated tasks** (`grading_type: automated`, deterministic checks) in `tasks/auto/`, and **22 hybrid tasks** (`grading_type: hybrid`, 0.7 automated / 0.3 LLM judge) in `tasks/hybrid/` — 10 automated and 2 hybrid per category. Tasks run against a local vLLM-served model via a clone-and-overlay runner that copies them into the PinchBench skill (see `skill/tasks/manifest.yaml`).

Before running, set the model/server variables at the top of `run.sh` (lines 5-7) to match your environment:

```bash
export LLM_MODEL="<provider/model-name>"        # model identifier passed to the runner
export BASE_URL="http://<host>:<port>/v1"       # OpenAI-compatible endpoint of your LLM server
export API_KEY="<your-api-key>"                 # API key ("EMPTY" is fine for a local server)
```

Run them via:

```bash
./run.sh auto    # automated-only suite
./run.sh hybrid  # 22 hybrid tasks (0.7 auto / 0.3 LLM)
./run.sh new     # all 132 new tasks (110 automated + 22 hybrid)
./run.sh full    # full suite (132 new + 147 existing tasks)
./run.sh test    # smoke test (task_sanity suite)
```

When a run type needs an LLM judge, OpenRouter's DeepSeek V4 Flash is used.

---

## Benchmark Score Summary

Scores for [`Qwen3.6-27B-Q6_K`](https://huggingface.co/unsloth/Qwen3.6-27B-GGUF/blob/main/Qwen3.6-27B-Q6_K.gguf), each averaged over **3 independent runs**. Mean and std are computed across runs (per-category values are each run's category average; std is the sample standard deviation).

Columns: **Auto** (110 automated tasks, `./run.sh auto`), **Hybrid** (22 hybrid tasks, `./run.sh hybrid`, 0.7 automated / 0.3 LLM judge), and **All** (all 132 new tasks combined).

| Category | Auto | Hybrid | All |
| -------- | ---- | ------ | --- |
| Productivity | 94.0% ± 5.2 | 77.4% ± 1.6 | 91.3% ± 4.5 |
| Research | 90.0% ± 0.0 | 74.4% ± 16.2 | 87.4% ± 2.7 |
| Writing | 98.7% ± 1.2 | 90.3% ± 1.5 | 97.3% ± 0.7 |
| Coding | 99.7% ± 0.3 | 77.4% ± 6.2 | 95.9% ± 1.2 |
| Analysis | 100.0% ± 0.0 | 90.4% ± 4.7 | 98.4% ± 0.8 |
| CSV Analysis | 100.0% ± 0.0 | 87.2% ± 2.2 | 97.9% ± 0.4 |
| Log Analysis | 100.0% ± 0.0 | 86.7% ± 3.8 | 97.8% ± 0.6 |
| Meeting Analysis | 98.0% ± 0.0 | 90.2% ± 2.2 | 96.7% ± 0.4 |
| Memory | 100.0% ± 0.0 | 91.1% ± 0.7 | 98.5% ± 0.1 |
| Skills | 100.0% ± 0.0 | 92.4% ± 3.6 | 98.7% ± 0.6 |
| Integrations | 100.0% ± 0.0 | 91.2% ± 1.9 | 98.5% ± 0.3 |
| **Overall** | **98.2% ± 0.6** | **86.3% ± 0.7** | **96.2% ± 0.4** |

---

## Task Categories

Each category has **10 automated tasks** (`tasks/auto/`) and **2 hybrid tasks** (`tasks/hybrid/`). Summaries below; see `skill/tasks/manifest.yaml` for the full ID list.

| Category | Automated (10) | Hybrid (2) |
|----------|----------------|------------|
| **Productivity** | Scheduling and office workflows — ICS/JSON/Markdown from small fixtures. | Sprint planning selection; on-call handoff brief. |
| **Research** | Lookups and short research reports with pinned facts / format checks. | Vendor RFP brief; competitor matrix reconciliation. |
| **Writing** | Structure-, keyword-, and length-graded drafting. | Incident customer email; RFC summary memo. |
| **Coding** | Create or fix small programs; AST/regex/file checks. | Bugfix rationale; CLI design doc. |
| **Analysis** | Deterministic calc/extraction over inline fixtures. | Cohort retention memo; fraud rule proposal. |
| **CSV Analysis** | Questions on shared CSVs in `assets/csvs/`. | Stock volatility brief; GDP region brief. |
| **Log Analysis** | Extraction over logs in `assets/logs/`. | Nginx dual-SLO report; SSH threat brief. |
| **Meeting Analysis** | Factual extraction from shared meeting transcripts. | GitLab decision memo; Tampa council brief. |
| **Memory** | Note retrieval, multi-file merge, contradiction detection, recall. | Stakeholder map; preference conflict resolution. |
| **Skills** | Filesystem / config / skill-manifest tasks (no live ClawHub). | Skill pack README; config migration runbook. |
| **Integrations** | Fixture-only integration simulations (no live GWS). | Webhook failure postmortem; PagerDuty escalation plan. |

Automated tasks are graded deterministically (`grading_type: automated`). Hybrid tasks combine automated checks with an LLM judge (`grading_type: hybrid`, 0.7 automated / 0.3 LLM).

---

## License

This project is licensed under the MIT License - see [LICENSE](LICENSE).

Built on [PinchBench](https://github.com/pinchbench/skill) (MIT).

## Citation

If you use Extended PinchBench, please cite:

```bibtex
@software{extended_pinchbench_2026,
  title  = {Extended PinchBench},
  author = {Lashkari, Amir},
  organization = {Huawei Technologies Canada},
  year   = {2026},
  url    = {https://github.com/alashkari/Extended-PinchBench}
}
```
