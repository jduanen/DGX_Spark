#!/bin/bash
#
# Script to update and restart OpenWebUI from NVIDIA

docker stop open-webui
docker rm open-webui
docker pull ghcr.io/open-webui/open-webui:ollama

./owuStart.sh
