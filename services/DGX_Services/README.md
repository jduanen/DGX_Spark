DGX Services

* Start/stop/query containers with docker compose, e.g.,
  - start all containers and run in the background as daemons
    * `docker compose up -d`
  - stop the ollama container, but leave all the other containers running
    * `docker compose down ollama`
* Containers that provide the always-on services on my DGX Spark
  - vLLM
    * high-performance LLM server for HuggingFace/FP8 models
    * provides an OpenAI-compatible API
    * uses NVIDIA's optimized container and provides higher throughput than Ollama
    * set the active model and configuration in 'services/DGX_Services/.env'
      - edit this file and restart the vLLM container to change models
    * port: 8000
  - Ollama
    * secondary LLM server for GGUF-format models not supported by vLLM
    * locally serves all the models that have been downloaded to it
    * port: 11434
  - OpenWebUI
    * web-browser-accessible GUI front-end for the models served by both the vLLM and Ollama containers
    * port: 12000
