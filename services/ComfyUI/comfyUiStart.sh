#!/bin/bash
#
# Script to start up ComfyUI on DGX Spark

source ${HOME}/Code/DGX_Spark/services/ComfyUI/cuiEnv/bin/activate

python ${HOME}/Code2/ComfyUI/main.py --listen 0.0.0.0
