# DGX_Spark
Code and documents for the NVIDIA DGX Spark

## Home Assistant Voice Assistant STT and TTS Services

I'm running the Piper and Whisper containers on my DGX Spark to provide STT and TTS services to my Home Assistant's Voice Assistant feature.

#### Startup Both Services

```bash
# Use default values (medium-int8 + en_US-lessac-medium)
docker compose up -d

# Or override on the command line:
STT_MODEL_NAME=tiny-int8 \
VOICE_NAME=de_DE-jonas \
docker compose up -d
```

#### Stop Both Services

```bash
docker compose down
```

### TODO

* Figure out best way to accelerate these containers -- e.g., use nvidia-mps
* Figure out how to reduce the latency for more responsive voice interactions on HA

## Ollama and Open-WebUI:ollama

My DGX Spark system also runs an Ollama model server and the Open-WebUI interface with it's own Ollama.
I'm currently running these as two different services as I try to figure out how to best optimize the execution of each of them.
I've made them share a common mount point so that they can share (presumably, read-only) models.
More investigation is needed.

#### Startup Both Services

#### Stop Both Services
