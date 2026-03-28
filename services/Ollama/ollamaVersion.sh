#!/bin/bash
#
# Script to print the version of the currently running Ollama instance

HOSTNAME=${1:-spark-8d0d.lan}
PORTNUM=${2:-11434}

if ! nc -z -w2 "$HOSTNAME" "$PORTNUM" &>/dev/null; then
    echo "ERROR: host '$HOSTNAME:$PORTNUM' is not reachable or invalid"
    exit 1
fi

curl -s http://${HOSTNAME}:${PORTNUM}/api/version | jq '.'
