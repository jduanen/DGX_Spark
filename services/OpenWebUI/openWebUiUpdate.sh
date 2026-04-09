#!/bin/bash
#
# Script to update the Open-WebUI container
# N.B. Must run this on the DGX Spark machine


VERSION=${1:-latest}

COMPOSE_FILE="${HOME}/Code/DGX_Spark/services/DGX_Services/docker-compose.yml"

docker compose -f "${COMPOSE_FILE}" stop open-webui

docker rm open-webui

docker pull ghcr.io/open-webui/open-webui:${VERSION}

docker compose -f "${COMPOSE_FILE}" up -d open-webui
