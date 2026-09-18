#!/usr/bin/env bash

set -euo pipefail

export LLM_MODEL="local-qwen-gguf/Qwen3.6-27B-Q6_K"        # model identifier passed to the runner
export BASE_URL="http://127.0.0.1:36201/v1"                # OpenAI-compatible endpoint of your LLM server
export API_KEY="EMPTY"                                     # API key ("EMPTY" is fine for a local server)

# Automated tasks (10 per category).
AUTO_PRODUCTIVITY_TASKS="task_recurring_event_ics,task_timezone_meeting_ics,task_conflict_detect_calendar,task_priority_inbox_sort,task_standup_notes_format,task_deadline_countdown,task_meeting_room_booking,task_expense_receipt_log,task_habit_streak_tracker,task_weekly_agenda_builder"
AUTO_RESEARCH_TASKS="task_ticker_compare_msft_googl,task_company_hq_lookup,task_python_release_date,task_timezone_offset_lookup,task_currency_pair_snapshot,task_open_source_license_lookup,task_rfc_title_lookup,task_package_latest_version_format,task_country_capital_batch,task_conference_cfp_deadline_format"
AUTO_WRITING_TASKS="task_apology_email_draft,task_changelog_from_commits,task_json_to_user_story,task_meeting_invite_email,task_error_message_rewrite,task_api_endpoint_docs,task_tweet_thread_split,task_press_release_boilerplate,task_sop_checklist_writer,task_release_notes_semver"
AUTO_CODING_TASKS="task_json_schema_validator_script,task_csv_to_sqlite_loader,task_retry_decorator_impl,task_url_shortener_map,task_log_parser_regex,task_env_config_loader,task_markdown_toc_generator,task_token_rate_limiter,task_diff_two_json,task_makefile_phony_targets"
AUTO_ANALYSIS_TASKS="task_invoice_total_reconcile,task_survey_likert_summary,task_funnel_conversion_calc,task_sla_breach_report,task_budget_vs_actual,task_duplicate_customer_detect,task_word_frequency_topn,task_http_status_breakdown,task_unit_conversion_batch,task_ab_test_lift"
AUTO_CSV_ANALYSIS_TASKS="task_csv_apple_max_drawdown,task_csv_apple_best_month,task_csv_iris_feature_means,task_csv_iris_sepals_ratio,task_csv_temp_hottest_year,task_csv_gdp_top5_africa,task_csv_cities_midwest_count,task_csv_stations_coldest,task_csv_pension_median,task_csv_life_exp_delta_china"
AUTO_LOG_ANALYSIS_TASKS="task_log_apache_unique_clients,task_log_nginx_top_paths,task_log_nginx_4xx_rate,task_log_ssh_root_attempts,task_log_ssh_geo_like_ip_groups,task_log_syslog_oom_events,task_log_hdfs_warn_count,task_log_mapreduce_killed_tasks,task_log_apache_mod_security_hits,task_log_nginx_peak_minute"
AUTO_MEETING_ANALYSIS_TASKS="task_meeting_tampa_motion_count,task_meeting_tampa_mayor_mentions,task_meeting_gitlab_owner_names,task_meeting_gitlab_launch_date,task_meeting_ntia_agenda_items,task_meeting_ntia_attendee_orgs,task_meeting_nasa_panelists,task_meeting_nasa_key_claim,task_meeting_cross_doc_date_index,task_meeting_action_owner_table"
AUTO_MEMORY_TASKS="task_memory_project_owner,task_memory_budget_cap,task_memory_dependency_version,task_memory_multi_file_merge,task_memory_contradiction_flag,task_memory_timeline_order,task_memory_contact_lookup,task_memory_decision_rationale,task_memory_fresh_session_recall,task_memory_update_then_query"
AUTO_SKILLS_TASKS="task_skill_manifest_parse,task_skill_dependency_graph,task_workspace_tree_report,task_symlink_safe_copy,task_frontmatter_batch_extract,task_config_merge_overlay,task_permission_audit_files,task_skill_readme_required_sections,task_tool_allowlist_filter,task_cache_key_normalize"
AUTO_INTEGRATIONS_TASKS="task_integration_webhook_replay,task_integration_slack_export_digest,task_integration_github_pr_summary,task_integration_jira_status_board,task_integration_pagerduty_oncall,task_integration_stripe_refunds_report,task_integration_s3_inventory_filter,task_integration_oauth_token_expiry,task_integration_prometheus_alert_triage,task_integration_calendar_gcal_ics_sync"

# Hybrid tasks (2 per category).
HYBRID_PRODUCTIVITY_TASKS="task_hybrid_sprint_planning,task_hybrid_oncall_handoff"
HYBRID_RESEARCH_TASKS="task_hybrid_vendor_rfp_brief,task_hybrid_competitor_matrix"
HYBRID_WRITING_TASKS="task_hybrid_incident_customer_email,task_hybrid_rfc_summary_memo"
HYBRID_CODING_TASKS="task_hybrid_bugfix_rationale,task_hybrid_cli_design_doc"
HYBRID_ANALYSIS_TASKS="task_hybrid_cohort_retention_memo,task_hybrid_fraud_rule_proposal"
HYBRID_CSV_ANALYSIS_TASKS="task_hybrid_stock_volatility_brief,task_hybrid_gdp_region_brief"
HYBRID_LOG_ANALYSIS_TASKS="task_hybrid_nginx_slo_report,task_hybrid_ssh_threat_brief"
HYBRID_MEETING_ANALYSIS_TASKS="task_hybrid_gitlab_decision_memo,task_hybrid_tampa_council_brief"
HYBRID_MEMORY_TASKS="task_hybrid_stakeholder_map,task_hybrid_preference_conflict"
HYBRID_SKILLS_TASKS="task_hybrid_skill_pack_guide,task_hybrid_config_migration_runbook"
HYBRID_INTEGRATIONS_TASKS="task_hybrid_webhook_failure_postmortem,task_hybrid_oncall_escalation_plan"

EASY_TASK_SUITE="task_memory_fresh_session_recall,task_meeting_cross_doc_date_index,task_csv_apple_max_drawdown,task_csv_pension_median,task_integration_calendar_gcal_ics_sync"
AUTO_TASK_SUITE="${AUTO_PRODUCTIVITY_TASKS},${AUTO_RESEARCH_TASKS},${AUTO_WRITING_TASKS},${AUTO_CODING_TASKS},${AUTO_ANALYSIS_TASKS},${AUTO_CSV_ANALYSIS_TASKS},${AUTO_LOG_ANALYSIS_TASKS},${AUTO_MEETING_ANALYSIS_TASKS},${AUTO_MEMORY_TASKS},${AUTO_SKILLS_TASKS},${AUTO_INTEGRATIONS_TASKS}"
HYBRID_TASK_SUITE="${HYBRID_SKILLS_TASKS},${HYBRID_INTEGRATIONS_TASKS},${HYBRID_PRODUCTIVITY_TASKS},${HYBRID_RESEARCH_TASKS},${HYBRID_WRITING_TASKS},${HYBRID_CODING_TASKS},${HYBRID_ANALYSIS_TASKS},${HYBRID_CSV_ANALYSIS_TASKS},${HYBRID_LOG_ANALYSIS_TASKS},${HYBRID_MEETING_ANALYSIS_TASKS},${HYBRID_MEMORY_TASKS}"
NEW_TASK_SUITE="${AUTO_TASK_SUITE},${HYBRID_TASK_SUITE}"

parse_run_type() {
  local run_type="${1:-}"

  usage() {
    echo "Usage: $0 <auto|hybrid|new|full|synthetic-train|test>"
    echo
    echo "  auto             automated-only suite"
    echo "  hybrid           22 hybrid tasks (0.7 auto / 0.3 LLM)"
    echo "  new              all 132 new tasks (110 automated + 22 hybrid)"
    echo "  full             full suite (all)"
    echo "  synthetic-train  1000 sampled synthetic router corpus tasks"
    echo "  test             smoke test (task_sanity suite)"
  }

  if [[ -z "${run_type}" ]]; then
    echo "Error: missing run type argument." >&2
    usage >&2
    exit 1
  fi

  case "${run_type}" in
    test|auto|full|easy|hybrid|new|synthetic-train)
      RUN_TYPE="${run_type}"
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Error: invalid run type '${run_type}'." >&2
      usage >&2
      exit 1
      ;;
  esac
}

ensure_skill_repo() {
  local script_dir="$1"
  local skill_dir="$2"
  local pinchbench_skill_repo="https://github.com/pinchbench/skill"

  if [[ ! -d "${skill_dir}" ]]; then
    echo "skill/ not found; cloning ${pinchbench_skill_repo} ..."
    git clone "${pinchbench_skill_repo}" "${skill_dir}"
  fi
}

setup_extended_tasks() {
  local skill_dir="$1"
  local new_tasks_dir="$2"
  local auto_tasks_dir="${new_tasks_dir}/auto"
  local hybrid_tasks_dir="${new_tasks_dir}/hybrid"
  local -a new_task_files

  if [[ ! -d "${auto_tasks_dir}" ]]; then
    echo "Error: auto tasks directory not found: ${auto_tasks_dir}" >&2
    exit 1
  fi
  if [[ ! -d "${hybrid_tasks_dir}" ]]; then
    echo "Error: hybrid tasks directory not found: ${hybrid_tasks_dir}" >&2
    exit 1
  fi

  echo "Copying tasks from tasks/{auto,hybrid}/ into skill/tasks/ ..."
  shopt -s nullglob
  new_task_files=("${auto_tasks_dir}"/task_*.md "${hybrid_tasks_dir}"/task_*.md)
  if ((${#new_task_files[@]} == 0)); then
    echo "Error: no task_*.md files found in ${auto_tasks_dir} or ${hybrid_tasks_dir}" >&2
    exit 1
  fi
  cp -f "${new_task_files[@]}" "${skill_dir}/tasks/"
  cp -f "${new_tasks_dir}/manifest.yaml" "${skill_dir}/tasks/manifest.yaml"
  echo "Copied ${#new_task_files[@]} task files and manifest.yaml."
}

setup_synthetic_train_tasks() {
  local skill_dir="$1"
  local new_tasks_dir="$2"
  local synth_dir="${new_tasks_dir}/synthetic-train-tasks"
  local synth_assets_dir="${synth_dir}/assets"
  local -a synth_task_files

  if [[ ! -d "${synth_dir}" ]]; then
    echo "Error: synthetic-train tasks directory not found: ${synth_dir}" >&2
    exit 1
  fi
  if [[ ! -f "${synth_dir}/manifest.yaml" ]]; then
    echo "Error: synthetic-train manifest not found: ${synth_dir}/manifest.yaml" >&2
    exit 1
  fi
  if [[ ! -d "${synth_assets_dir}" ]]; then
    echo "Error: synthetic-train assets directory not found: ${synth_assets_dir}" >&2
    exit 1
  fi

  echo "Copying synthetic-train tasks into skill/tasks/ ..."
  shopt -s nullglob
  synth_task_files=("${synth_dir}"/task_syn_*.md)
  if ((${#synth_task_files[@]} == 0)); then
    echo "Error: no task_syn_*.md files found in ${synth_dir}" >&2
    exit 1
  fi
  cp -f "${synth_task_files[@]}" "${skill_dir}/tasks/"
  cp -f "${synth_dir}/manifest.yaml" "${skill_dir}/tasks/manifest.yaml"
  echo "Copied ${#synth_task_files[@]} synthetic task files and manifest.yaml."

  echo "Copying synthetic-train assets into skill/assets/ ..."
  mkdir -p "${skill_dir}/assets"
  cp -a "${synth_assets_dir}/." "${skill_dir}/assets/"
  echo "Copied synthetic-train assets."
}

setup_skill() {
  local script_dir skill_dir new_tasks_dir

  script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  skill_dir="${script_dir}/skill"
  new_tasks_dir="${script_dir}/tasks"

  ensure_skill_repo "${script_dir}" "${skill_dir}"

  if [[ "${RUN_TYPE}" == "synthetic-train" ]]; then
    setup_synthetic_train_tasks "${skill_dir}" "${new_tasks_dir}"
  else
    setup_extended_tasks "${skill_dir}" "${new_tasks_dir}"
  fi

  SKILL_DIR="${skill_dir}"
}

# Args: <label> <suite|"" for --core> <use_judge 0|1> <verbose 0|1>
run_benchmark() {
  local label="$1"
  local suite="${2:-}"
  local use_judge="${3:-0}"
  local verbose="${4:-0}"
  local out_dir
  local -a cmd

  if [[ "${label}" == "smoke" ]]; then
    out_dir="results/qwen3.6-27b-q6k-smoke"
  else
    out_dir="results/qwen3.6-27b-q6k-${label}-$(date +%Y%m%d-%H%M%S)"
  fi
  mkdir -p "${out_dir}"

  cmd=(
    ./scripts/run.sh
    --model "${LLM_MODEL}"
    --base-url "${BASE_URL}"
    --api-key "${API_KEY}"
    --runs 1
    --timeout-multiplier 10
    --output-dir "${out_dir}"
    --no-upload
  )

  if [[ -n "${suite}" ]]; then
    cmd+=(--suite "${suite}")
  else
    cmd+=(--core)
  fi

  if [[ "${use_judge}" == "1" ]]; then
    cmd+=(--judge openrouter/deepseek/deepseek-v4-flash)
  fi

  if [[ "${verbose}" == "1" ]]; then
    cmd+=(--verbose)
  fi

  "${cmd[@]}"
}

main() {
  parse_run_type "${1:-}"
  setup_skill
  cd "${SKILL_DIR}"

  case "${RUN_TYPE}" in
    auto)             run_benchmark automated "${AUTO_TASK_SUITE}" 0 1 ;;
    easy)             run_benchmark easy "${EASY_TASK_SUITE}" 1 0 ;;
    hybrid)           run_benchmark hybrid "${HYBRID_TASK_SUITE}" 1 0 ;;
    new)              run_benchmark new "${NEW_TASK_SUITE}" 1 0 ;;
    full)             run_benchmark full all 1 0 ;;
    # Mix of automated / hybrid / llm_judge tasks; judge required for non-automated.
    synthetic-train)  run_benchmark synthetic-train synthetic_train 1 0 ;;
    test)             run_benchmark smoke task_sanity 0 1 ;;
  esac
}

main "$@"
