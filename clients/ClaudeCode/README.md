* This directory contains tools for the Claude Code client-side containers
  - these containers are run locally and the models that they use are run on my DGX Spark

* docs: https://code.claude.com/docs/en/overview

* core Claude Code commands
  - `claude`
    * launches an interactive session
    * describe your task in natural language (e.g., "Refactor this Python module for async")
  - `claude "fix the bug in main.py"`
    * starts a session with an initial prompt
  - `claude -p "explain auth logic"`
    * start with a one-shot query, prints response and exits
    * good for running scripts
  - `claude -c`
    * resumes your last conversation in the current dir
  - `claude --model qwen3.5`
    * specifies model (proxied to your DGX Spark Ollama via env vars)

* working with Claude Code
  - scans the mounted codebase ('/workspace') on startup
    * suggests edits, runs bash commands (with confirmation), and commits changes
  - you can drag-and-drop files into the Claude Code window
  - interrupt with 'Ctl-C'
  - exit session with '/exit' or 'exit'

* The 'ollama' directory contains tools for building a Claude Code container that uses Ollama on my DGX Spark to run models
  - workflow
    * build a docker image that uses code that NVIDIA has optimized for the DGX Spark
      - `buildClaudeCodeOllama.sh`
        * uses 'dockerfile' to create a docker image for a local Claude Code instance that uses Ollama on the DGX Spark to run its models
          - it uses the optimized NVIDIA version of ubuntu24.04 for developers, with CUDA 13.0.1
        * a fresh version of Claude Code is installed each time this creates a container image
          - use Anthropic's install script
            * `curl -fsSL https://claude.ai/install.sh | bash`
    * start up a local instance of the container
      - `startClaudeCodeOllama.sh [<dir> [<model>]]`
        * if an argument is given, it is used as the workspace directory for the resulting container
          - if none is given, it defaults to '~/Code/'
        * check changes in docker-compose.yml file with: `docker compose config`
    * select a model and use Claude Code
      --> see ????
      - set up 'CLAUDE.md'
        * contains rules for this instance of Claude Code
        * first created by '/init' command in Claude Code, can be manually edited
      - ????


    * make local container with Claude Code
      - official Claude Code container for VS Code Dev
        * `cd ~/Code2`
        * `git clone https://github.com/anthropics/claude-code`
        * `cd claude-code/.devcontainer/`
        * `docker build -t claude-code-official .`

    * workflow
      - `buildClaudeClodeLocal.sh:
        * build 'claude-code-local' docker image
      - create a container instance called 'claude-code'
        * start working in a directory by starting the container there
        * `docker compose run --rm claude-code bash`
      - continue working on the same instance of 'claude-code'
        * `docker compose exec claude-code bash`




  - vllm: use vLLM to run models for Claude Code on my DGX Spark
    * CLAUDE.md
      - rules for this instance of Claude Code
      - created by '/init' command in Claude Code
      - ????
    * buildClaudeCodeVllm.sh
      - create a docker image for a local Claude Code instance that uses vLLM on the DGX Spark to run the models
      - uses 'dockerfile' to define the container that installs a fresh version of Claude Code on each build
      - mount the desired directory to work in with ????
    * ?

