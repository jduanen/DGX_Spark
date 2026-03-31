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

## Ollama and Open-WebUI

My DGX Spark system also runs an Ollama model server and the Open-WebUI interface (without it's own Ollama instance).
I'm currently running these as two different services to provide performance, failure, and update independence. However, there is a risk that I could get upgrade to an inconsistent state, so I'll have to be careful about that.

I run Open-WebUI without any auth because it's on my private network, and I run it on port 12000 so that it can be run via the NVIDIA Sync app. Ollama listens on port 11434 so that both Open-WebUI and Home Assistant can access it.

I set 'WEBUI_AUTH = "false"' because my system is not shared.

The Ollama container stores its data (including downloaded models) in the volume 'ollama', and the Open-WebUI container stores its persistant data in the 'open-webui' volume.

From the Open-WebUI browser page, you can select models to download from the Ollama website.
I'm currently experimenting with various models. Below are the models I currently have loaded and their features and my use cases for them.

|--Model Name:Size--|--Source--|--Features--|--My Use Cases--|
| codellama:70b | Meta | generating and discussing code, built on Llama2 | coding assistant |
| deepseek-coder-v2:latest | Deepseek | MoE, code LLM, comparable to GPT4-Turbo | coding assistant |
| glm-4.7-flash:latest | ? | 30b-A3B MoE | OpenClaw default model |
| gpt-oss:20b | OpenAI | reasoning, agentic, developer | Home Assistant Voice Assistant |
| gpt-oss:120b | OpenAI | reasoning, agentic, developer | Home Assistant Voice Assistant, HA Chat |
| llama3.1:70b | Meta | large context | Home Assistant Voice Assistant, HA Chat |
| llama4:16x17b | Meta | multi-modal | coding assistant |
| nemotron-cascade-2:30b | NVIDIA | MoE, 3B activated, reasoning/agentic | undetermined |
| nemotron-3-nano:30b | NVIDIA | efficient, agentic | undetermined |
| nemotron-3-super:120b | NVIDIA | MoE, 12B activated | undetermined |
| qwen3:4b | Qwen | MoE | Home Assistant Voice Assistant |
| qwen3.5:35b | Qwen | multi-modal | undetermined |
| qwen3-vl:32b | Qwen | vision-language | streaming VLM |
| starcoder2:15b | BigCode | coding | coding assistant |

#### Running Both Services Together

I use a docker compose yaml file to start up both the Open-WebUI and Ollama containers.

Start by 'docker compose up -d' and stop by 'docker compose down'.

#### Ollama Scripts

* ${HOME}/bin/
  - ollamaList.sh: list models available for download from the Ollama website
  --> TODO move these to DGX_Spark
  - ollamaModels.sh: list the models currently loaded in the local Ollama container
  - ollamaPull.sh: pull a model from the Ollama website into the local Ollama container
* ${HOME}/Code/DGX_Spark/services/Ollama/
  - ollamaModels.sh: list the models currently loaded in the Ollama container on the DGX Spark
  - ollamaPrompt.sh: issues a prompt to the desired LLM model running on the DGX Spark
  - ollamaUpdate.sh: update the Ollama container on the DGX Spark
  - ollamaVersion.sh: print the version of the current Ollama instance running on the DGX Spark

#### Open-WebUI Scripts

* ${HOME}/Code/DGX_Spark/services/Open-WebUI/
  - openWebUiUpdate.sh: update the Open-WebUI container on the DGX Spark

## VLM WebUI

I followed the NVIDIA cookbook for this browser-based app that feeds video streams from webcams into LLMs and gets text output.

### Installation and Setup

First create a Python virtual environment for this app and then install the required Python packages.

```bash
python3 -m venv vlmEnv
source ${HOME}/Code/DGX_Spark/services/VLM_WebUI/vlmEnv/bin/activate
pip install -r requirements.txt
```
##### VlmuiStart.sh

Script to start up VLM WebUI on DGX Spark. Offers a brower interface on `https://<hostname>:8090/`.

### Live VLM WebUI

This web-app allows you to connect one of the available Vision-Language/Multi-modal models in the local Ollama server (with `http://<hostname>:<portnum>/v1`) with a video stream supplied by either a webcam attached to the machine on which the browser is currently running, or to network-attached webcams (by way of an RTSP connection, e.g., with `rtsp://<user>:<passwd>@<hostname>:<portnum>/<path>`).

In addition to selecting the video source and the VLM, you can select how frequently the VLM should sample the stream by selecting the Frame Processing Interval, in number of frames.
Furthermore, there are a set of pre-defined prompts that can be selected from the Quick Presets menu, or a custom prompt can be entered in the given prompt box.
The max number of tokens to use can also be given.

The app shows a preview of the connected video stream, as well as the key resource stats of the DGX spark system -- i.e., GPU utilization, VRAM usage, CPU utilization, and system RAM use.

### Comfy UI

ComfyUI is a popular tool for generative image and animation generation. It is a graph-oriented tool (similar to blender) that allows different modules to be connected into a "workflow" (i.e., a graph of modules) that can be used to generate different types of output.

For example, ????
**TBD**

### Installation and Setup

First, clone the repo into a local directory on the DGX Spark (e.g., `git clone https://github.com/comfyanonymous/ComfyUI.git`), then create a Python virtual environment for this app, and then install the required Python packages.

```bash
python3 -m venv cuiEnv
source ${HOME}/Code/DGX_Spark/services/ComfyUI/vlmEnv/bin/activate
pip install -r ${HOME}/Code2/ComfyUI/requirements.txt
```

##### comfyUiStart.sh

Script to start up ComfyUI on the DGX Spark. Offers a brower interface on `https://<hostname>:8090/`.

### Claude Code

**TBD**

### Open Code

**TBD**

## OpenClaw

From NVIDIA's documentation: "OpenClaw is a local-first AI agent that can remember conversations, adapt to your usage, uses context from your files and apps, and can be extended with community skills."

The OpenClaw Gateway runs as a daemon and is the main server process for the agent. It manages the agents, the application state, and sessions. It does token-based authentication for the WebUI and CLI.
All clients (e.g., CLI, TUI, WebUI, mobile apps, HA-side scripts, etc.) connect to the Gateway by way of WebSockets.
It takes user inputs (e.g., chat, commands, web requests, etc.) and calls from tools (e.g., shell, HTTP, HA, etc.) and returns the agent's replies and events to the caller.

### Installation and Setup

The installer installs all dependencies for OpenClaw, including Node.js and npm.

'''bash
curl -fsSL https://openclaw.ai/install.sh | bash
'''

This is an inherently insecure app, so they are up-front about needing to be careful with it.
They recommend this as a baseline:
│  - Pairing/allowlists + mention gating.                                                    │
│  - Multi-user/shared inbox: split trust boundaries (separate gateway/credentials, ideally  │
│    separate OS users/hosts).                                                               │
│  - Sandbox + least-privilege tools.                                                        │
│  - Shared inboxes: isolate DM sessions (`session.dmScope: per-channel-peer`) and keep      │
│    tool access minimal.                                                                    │
│  - Keep secrets out of the agent’s reachable filesystem.                                   │
│  - Use the strongest available model for any bot with tools or untrusted inboxes.          │
│                                              
They also recommend running these commands regularly:
│  openclaw security audit --deep                                                            │
│  openclaw security audit --fix                                                             │
And read: https://docs.openclaw.ai/gateway/security

I connect it to my Ollama instance running on the DGX Spark, in local-only mode.
I skipped channels and will add channel selections later. Options that I'm interested in include: Google Chat, Signal, Telegram, and WhatsApp.
I also skipped search provider for now. I can configure it later with `openclaw configure --section web`.
I installed the missing skill dependencies that I think I'll need at first.

Skills are commonly shipped using Homebrew, so I have to install it on the DGX Spark.
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
Also have to install uv.
```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

Can add the optional Android app for camera/canvas features.

The Gateway Token provides shared auth for the Gateway and Control UI.
  * Token stored in: `~/.openclaw/openclaw.json` (gateway.auth.token) or OPENCLAW_GATEWAY_TOKEN.
  * view Token: `openclaw config get gateway.auth.token`
  * generate token: `openclaw doctor --generate-gateway-token`
The Web UI keeps dashboard URL tokens in memory for the current tab and strips them from the URL after load.
You can open the dashboard anytime with: `openclaw dashboard --no-open`
  * if prompted, paste the token into Control UI settings (or use the tokenized dashboard URL).

The setup script writes config info into `~/.openclaw/openclaw.json`.

Startup Optimizations suggested for low-power hosts:
```bash
export NODE_COMPILE_CACHE=/var/tmp/openclaw-compile-cache
mkdir -p /var/tmp/openclaw-compile-cache
export OPENCLAW_NO_RESPAWN=1
```

Consider running OpenClaw as a service:
```bash
sudo systemctl enable --now openclaw.service
```


### Operation and Use Examples

* Control UI
  - Web UI: http://127.0.0.1:18789/
  - Web UI (with token): http://127.0.0.1:18789/#token=<token>
  - Gateway WS: ws://127.0.0.1:18789
  - Docs: https://docs.openclaw.ai/web/control-ui
* Start TUI to "Hatch your bot"
  - defining action that personalizes the agent
  - 

* Selected CLI Commands
  - Docs: https://docs.openclaw.ai/cli
  - `openclaw --version`
  - `openclaw status`
  - `openclaw logs`
  - `openclaw doctor`: ?
  - `openclaw update`: ?
  - `openclaw security audit --deep`: ?
  - `openclaw ?`: ?
  - Examples:
    * `openclaw models --help`: show detailed help for the models command
    * `openclaw channels login --verbose`: link personal WhatsApp Web and show QR + connection logs
    * `openclaw message send --target +15555550123 --message "Hi" --json`: send via your web session and print JSON result
    * `openclaw gateway --port 18789`: run the WebSocket Gateway locally
    * `openclaw --dev gateway`: run a dev Gateway (isolated state/config) on ws://127.0.0.1:19001
    * `openclaw gateway --force`: kill anything bound to the default gateway port, then start it
    * `openclaw gateway ...`: gateway control via WebSocket
    * `openclaw agent --to +15555550123 --message "Run summary" --deliver`: talk directly to the agent using the Gateway (optionally send the WhatsApp reply)
    * `openclaw message send --channel telegram --target @mychat --message "Hi"`: send via your Telegram bot


## NemoClaw

A wrapper for OpenClaw that provides improved security.

**TBD**
