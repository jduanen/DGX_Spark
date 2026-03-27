#!/bin/bash
#
# Script to update and restart Ollama

docker stop ollama
docker rm ollama
docker pull ollama/ollama:latest

#### FIXME
./ollamaStart.sh
