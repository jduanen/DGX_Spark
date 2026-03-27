#!/bin/bash
#
# Script to print currently installed models in running Ollama container

curl -s http://spark-8d0d.lan:11434/api/tags | jq '.models[].name'
