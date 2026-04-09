Ollama (local) Model Server: a container that runs Ollama and encapsulates the downloaded models.

* Scripts
  - ollamaModels.sh: script to list the models currently loaded in the Ollama container
  - ollamaPrompt.sh: script that issues a prompt to an LLM model running on a DGX spark
  - ollamaTunnel.sh: WIP
  - ollamaUpdate.sh: script to update the Ollama container
  - ollamaVersion.sh: script to print the version of the currently running Ollama instance
* all of these scripts except 'ollamaUpdate.sh' can be run remotely
