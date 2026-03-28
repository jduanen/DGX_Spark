#!/bin/bash
#
# This script issues a query to the desired LLM model running on the DGX spark
#
# Usage: ./sparkOllamaQuery.sh <query> {<model> {"stream"}}

#### TODO think about output to a file as an option
#### TODO parse the response JSON from CURL (with jq) and assemble the full response message

DEF_MODEL="gpt-oss:20b"
SERVER="spark-8d0d.lan"

USAGE="Usage: $0  {<model> {\"stream\"}} <query>"

MODEL=${DEF_MODEL}
STREAM=false

if [ $# -eq 0 ] || [ $# -gt 2 ]; then
  echo ${USAGE}
  exit 1
elif [ $# -eq 1 ]; then
  CONTENT="$1"
elif [ $# -eq 2 ]; then
  MODEL="$1"
  CONTENT="$2"
elif [ $# -eq 3 ]; then
  MODEL="$1"
  if [ $2 == "stream" ]; then
    STREAM="true"
  else
    echo ${USAGE}
    exit 1
  fi
  CONTENT="$3"
fi

curl -s "http://${SERVER}:11434/api/chat" -d "{\"model\": \"${MODEL}\", \"messages\": [{\"role\": \"user\", \"content\": \"$CONTENT\"}],
  \"stream\": ${STREAM}}" | jq -r .

