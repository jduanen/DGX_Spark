#!/bin/bash
#
# Script to start up ollama container for use by Home Assistant

docker run -d --name ollama --restart unless-stopped --net host -v ollama:/root/.ollama -e OLLAMA_HOST="0.0.0.0" ollama/ollama:latest
