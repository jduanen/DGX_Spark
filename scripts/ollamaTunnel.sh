#!/bin/bash
#
# Script to open tunnel to ollama container on DGX Spark
#
# This runs in the background; kill it when done.

#### FIXME improve how it gets passwd or use keys
#### TODO make tool for shutting down

USR="jdn"
DGX="spark-8d0d.lan"
LOCAL_PORT="11434"
REMOTE="localhost:11434"

OPTS="-f"  # fork to background


ssh ${OPTS} -N -L ${LOCAL_PORT}:${REMOTE} ${USR}@${DGX}
