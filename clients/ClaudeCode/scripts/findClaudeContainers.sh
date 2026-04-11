#!/bin/bash
#
# Script to find all running Claude Code containers on the local machine

echo "=== Searching for running Claude Code containers ==="
echo ""

# Search for containers with common Claude Code container names
echo "Running containers:"
docker ps --format "{{.Names}}" | grep -iE "claude|code|ollama" 2>/dev/null || echo "No running containers found"

echo ""
echo "All containers (including stopped):"
docker ps -a --format "{{.Names}}" | grep -iE "claude|code|ollama" 2>/dev/null || echo "No containers found"

echo ""
echo "=== Detailed container information ==="

# Get detailed info for any found containers
for container in $(docker ps --format "{{.Names}}" 2>/dev/null | grep -iE "claude|code|ollama"); do
    echo ""
    echo "Container: $container"
    docker inspect "$container" 2>/dev/null | grep -E '"Name":|"Status":|"Image":|"Ports":|"State":' | head -6
done

echo ""
echo "=== To stop all found containers (optional) ==="
echo "To stop containers, run: docker stop $(docker ps -q --filter "name=^claude$|^claude-code$|^ollama$")"
echo "or manually: docker stop <container-name>"
