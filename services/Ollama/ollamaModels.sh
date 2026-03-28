#!/bin/bash
#
# Script to list the models currently loaded in the Ollama container


curl http://${HOSTNAME:-spark-8d0d.lan}:11434/api/tags | jq -r '.models[].name'
