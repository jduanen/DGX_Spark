#!/bin/bash
#
# Script to run and start using a local Claude Code container
# This uses the directory from which it is started up as the workspace
#
# Usage: ${0} [<dir> [<model>]]
set -euo pipefail

WORKSPACE_DIR="${1:-${HOME}/Code/}"
export WORKSPACE_DIR
CLAUDE_MODEL="${2:-llama3.3:70b}"
export CLAUDE_MODEL

COMPOSE_FILE="${HOME}/Code/DGX_Spark/clients/ClaudeCode/ollama/docker-compose.yml"

docker compose -f ${COMPOSE_FILE} run --rm claude-code
