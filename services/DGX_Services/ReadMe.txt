DGX Services

* Start/stop/query containers with docker compose, e.g.,
  - start all containers and run in the background as daemons
    * `docker compose up -d`
  - stop the ollama container, but leave all the other containers running
    * `docker compose down ollama`
* Containers that provide the always-on services on my DGX Spark
  - Ollama: locally serves all the models that have been downloaded to it
  - OpenWebUI: web-browser-accessible GUI front-end for the models served by the Ollama container
