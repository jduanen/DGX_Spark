#!/bin/bash
#
# Script to start up openWebUI from NVIDIA

docker run -d -p 12000:8080 --gpus=all \
  -v open-webui:/app/backend/data \
  -v open-webui-ollama:/root/.ollama \
  -e AUTH_MODE=none \
  -e STATIC_USERNAME=admin \
  -e STATIC_PASSWORD=xyzzy \
  -e DISABLE_TELEMETRY=1 \
  --name open-webui --restart always \
  ghcr.io/open-webui/open-webui:ollama
