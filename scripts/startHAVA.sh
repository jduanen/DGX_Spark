#!/bin/bash
# Script to start up the local STT and TTS containers for the HA Voice Assistant
#
# Usage: HAVA.sh {<STTmodelName> <TTSvoiceName>}
#
# ${STT_MODEL_NAME}
#  * tiny-int8 (43 MB): smallest, fastest, low accuracy
#  * tiny (152 MB):
#  * base-int8 (80 MB):
#  * base (291 MB): 
#  * small-int8 (255 MB):
#  * small (968 MB):
#  * medium-int8 (786 MB):
#  * medium (3.1 GB): larger, slower, more accurate
#  * large (not always supported or practical on smaller devices)
#
# ${VOICE_NAME}
#  * en_US-lessac-medium: English, medium-sized, female voice
#  * en_US-lessac-small: English, small-sized, ????
#  * de_DE-jonas: German, male voice
#  * ????

WHISPER_HOST_PORT=10300
PIPER_HOST_PORT=10200

#### FIXME accelerate with CUDA

# set up Whisper (STT) container
STT_MODEL_NAME=${1:-"medium-int8"}
docker run -d \
  --restart unless-stopped \
  --name wyoming-whisper \
  -p ${WHISPER_HOST_PORT}:10300 \
  -v /home/jdn/Data2/WhisperData:/data \
  rhasspy/wyoming-whisper \
  --model ${STT_MODEL_NAME} \
  --language en
##  --device cuda
if [ $? -ne 0 ]; then
  echo "ERROR: Failed to start Whisper"
  exit 1
fi

# set up Piper (TTS) container
VOICE_NAME=${2:-"en_US-lessac-medium"}
docker run -d \
  --restart unless-stopped \
  --name wyoming-piper \
  -p ${PIPER_HOST_PORT}:10200 \
  -v /home/jdn/Data2/PiperData:/data \
  rhasspy/wyoming-piper \
  --voice ${VOICE_NAME}
if [ $? -ne 0 ]; then
  echo "ERROR: Failed to start Piper"
  exit 1
fi
