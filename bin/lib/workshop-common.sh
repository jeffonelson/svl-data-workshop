#!/usr/bin/env bash
# Shared helpers for the SVL workshop scripts. Source this file; do not execute
# it. Callers must set repo_root before sourcing.
#
# Nothing here may print, log, or persist an API-key value.

PROJECT_ID_PATTERN='^[a-z][a-z0-9-]{4,28}[a-z0-9]$'

workshop_load_config() {
  # shellcheck source=../../config/workshop.env
  source "$repo_root/config/workshop.env"
  export CLOUDSDK_METRICS_ENVIRONMENT="${CLOUDSDK_METRICS_ENVIRONMENT:+$CLOUDSDK_METRICS_ENVIRONMENT }datacloud.codex"
}

workshop_state_dir() {
  printf '%s' "$repo_root/.workshop-state"
}

workshop_project_state_file() {
  printf '%s' "$repo_root/.workshop-state/project.env"
}

# Echoes the saved project ID, or nothing when no selection is recorded.
workshop_saved_project() {
  local state_file
  state_file="$(workshop_project_state_file)"
  [[ -f "$state_file" ]] || return 0
  sed -n 's/^GCP_PROJECT_ID=//p' "$state_file"
}

workshop_project_id_is_valid() {
  [[ "${1:-}" =~ $PROJECT_ID_PATTERN ]]
}

# Scopes Google Cloud project selection to this process only. It never changes
# the user's global gcloud configuration.
workshop_export_project_env() {
  local project_id="$1"
  export CLOUDSDK_CORE_PROJECT="$project_id"
  export GOOGLE_CLOUD_PROJECT="$project_id"
  export GOOGLE_CLOUD_QUOTA_PROJECT="$project_id"
}

# Optional local-development override. Normal workshop launches retrieve every
# missing credential from Secret Manager instead.
workshop_source_env_local() {
  [[ -f "$repo_root/.env.local" ]] || return 0
  set -a
  # shellcheck disable=SC1091
  source "$repo_root/.env.local"
  set +a
}

# Loads one API key into the named variable when it is not already set.
# The value is never echoed, logged, or written to disk.
workshop_load_secret_if_unset() {
  local variable_name="$1"
  local secret_id="$2"
  local project_id="$3"
  local secret_value

  if [[ -n "${!variable_name:-}" ]]; then
    return 0
  fi

  if ! command -v gcloud >/dev/null 2>&1; then
    echo "Cannot load $variable_name: gcloud is not installed." >&2
    return 1
  fi

  if ! secret_value="$(
    gcloud secrets versions access "$SECRET_VERSION" \
      --secret="$secret_id" \
      --project="$project_id"
  )"; then
    echo "Cannot load $variable_name from Secret Manager secret: $secret_id" >&2
    echo "Run ./bin/doctor for authentication and IAM diagnostics." >&2
    return 1
  fi

  if [[ -z "$secret_value" ]]; then
    echo "Secret Manager returned an empty value for: $secret_id" >&2
    return 1
  fi

  printf -v "$variable_name" '%s' "$secret_value"
  export "$variable_name"
  unset secret_value
}

# Common launcher preamble: resolve the saved project, scope the environment,
# and load both workshop API keys. Sets WORKSHOP_PROJECT_ID on success.
#
# Call this directly, never inside a command substitution: the exported
# credentials would be confined to the subshell and lost.
workshop_prepare_launch() {
  local project_id
  project_id="$(workshop_saved_project)"

  if [[ -z "$project_id" ]]; then
    echo "No workshop project is configured." >&2
    echo "Run: ./bin/setup PROJECT_ID" >&2
    return 1
  fi

  if ! workshop_project_id_is_valid "$project_id"; then
    echo "The saved workshop project ID is invalid. Run: ./bin/setup PROJECT_ID" >&2
    return 1
  fi

  workshop_export_project_env "$project_id"
  workshop_source_env_local
  workshop_load_secret_if_unset WORKSHOP_DK_API_KEY "$DK_SECRET_ID" "$project_id" || return 1
  workshop_load_secret_if_unset WORKSHOP_MAPS_API_KEY "$MAPS_SECRET_ID" "$project_id" || return 1

  WORKSHOP_PROJECT_ID="$project_id"
}
