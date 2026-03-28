#!/bin/bash
#
# Script to list the models currently loaded in the Ollama container

HOSTNAME=${1:-spark-8d0d.lan}
PORTNUM=${2:-11434}

if ! nc -z -w2 "$HOSTNAME" "$PORTNUM" &>/dev/null; then
    echo "ERROR: host '$HOSTNAME:$PORTNUM' is not reachable or invalid"
    exit 1
fi

curl -s http://${HOSTNAME}:${PORTNUM}/api/tags | jq -r '.models[].name'
