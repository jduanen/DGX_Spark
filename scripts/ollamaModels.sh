#!/bin/bash
#
# Script to list the models currently loaded in the ollama container

curl http://localhost:11434/api/tags | jq -r .
