#!/bin/bash
#
# Run a local Claude Code container backed by vLLM.
# Model name must match the --served-model-name set in DGX_Services/.env.
#
# Usage: ${0} [<workspace-dir> [<model-alias>]]
set -euo pipefail

WORKSPACE_DIR="${1:-${HOME}/Code/}"
export WORKSPACE_DIR
CLAUDE_MODEL="${2:-llama-3.1-8b}"   # must match VLLM_SERVED_NAME in DGX_Services/.env
export CLAUDE_MODEL

COMPOSE_FILE="${HOME}/Code/DGX_Spark/clients/ClaudeCode/vllm/docker-compose.yml"

docker compose -f "${COMPOSE_FILE}" run --rm claude-code
