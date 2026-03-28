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

I run Open-WebUI without any auth because it's on my private network, and I run it on port 12000 so that it can be run via the NVIDIA Sync app.

#### Startup Both Services

#### Stop Both Services

#### Ollama Scripts

##### ollamaModels.sh

Script to list the models currently loaded in the Ollama container.

#### Open-WebUI:ollama Scripts

## VLM WebUI

I followed the NVIDIA cookbook for this browser-based app that feeds video streams from webcams into LLMs and gets text output.

### Installation and Setup

First create a Python virtual environment for this app and then install the required Python packages.

```bash
python3 -m venv vlmEnv
source ./vlmEnv/bin/activate
pip install -r requirements
```
##### VlmuiStart.sh

Script to start up VLM WebUI on DGX Spark. Offers a brower interface on `https://<hostname>:8090/`.

### Live VLM WebUI

Connect to the local instance of Ollama with `http://<hostname>:11434/v1` and select one of the available Vision-Language/Multi-modal models.

This app can connect to a webcam attached to the machine on which the browser is currently running, or it can connect to webcams by way of an RTSP connection -- e.g., `rtsp://<user>:<passwd>@<hostname>:<portnum>/<path>`.
You select how frequently the VLM should sample the stream by selecting the Frame Processing Interval, in number of frames.
There are a set of pre-defined prompts that can be selected from the Quick Presets menu, or a custom prompt can be entered in the given prompt box.
The max number of tokens to use can also be given.

The app shows a preview of the connected video stream, as well as the key resource stats of the DGX spark system -- i.e., GPU utilization, VRAM usage, CPU utilization, and system RAM use.
