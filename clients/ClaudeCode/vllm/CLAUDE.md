# CLAUDE.md

This file provides guidance to Claude Code when working with code in this repository.

## Architecture Overview

This is the vLLM-backed variant of the Claude Code container. It connects to the vLLM server
running on the DGX Spark (port 8000) instead of Ollama (port 11434). vLLM provides higher
throughput and lower latency via PagedAttention and continuous batching.

## Key Files

- `docker-compose.yml` - Container definition pointing at vLLM endpoint
- `startClaudeCodeVllm.sh` - Startup wrapper (takes workspace dir + model alias as args)

## Usage

```bash
# Default workspace and model
./startClaudeCodeVllm.sh

# Custom workspace and model alias
./startClaudeCodeVllm.sh ~/Code/MyProject llama-3.1-8b
```

The model name must match the `VLLM_SERVED_NAME` value set in
`services/DGX_Services/.env` (the `--served-model-name` alias, not the full HF model ID).

## vLLM Setup

Environment variables configured:

- `ANTHROPIC_AUTH_TOKEN=vllm`
- `ANTHROPIC_API_KEY=""` (empty for local)
- `ANTHROPIC_BASE_URL=http://192.168.166.7:8000`

The vLLM server must be running (`docker compose up -d vllm` from `services/DGX_Services/`).
Check available models: `curl http://192.168.166.7:8000/v1/models`
