#!/bin/bash
#
# Script to update the Ollama container
# N.B. Must run this on the DGX Spark machine


VERSION=${1:-latest}

COMPOSE_FILE="${HOME}/Code/DGX_Spark/services/Ollama_OpenWebUI/docker-compose.yml"

docker compose -f "${COMPOSE_FILE}" stop ollama

docker rm ollama

docker pull ollama/ollama:${VERSION}

docker compose -f "${COMPOSE_FILE}" up -d ollama
