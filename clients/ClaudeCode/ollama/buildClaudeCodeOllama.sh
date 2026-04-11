#!/bin/bash
#
# Script to create a docker image for a local Claude Code instance that uses
#  Ollama on the DGX Spark to run the models it uses

docker build -t claude-code-ollama .
