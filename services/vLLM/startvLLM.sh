#!/bin/bash
#
# Script to run an NVIDIA-DGX-Spark-optimized vLLM container

LATEST_VLLM_VERSION=${1:-26.03-py3}

docker run \
  --rm --gpus all \
  -p 8000:8000 \
  nvcr.io/nvidia/vllm:${LATEST_VLLM_VERSION} \
  python3 -m vllm.entrypoints.openai.api_server \
  --model nvidia/Llama-3.1-8B-Instruct-FP8 \
  --trust-remote-code --tensor-parallel-size 1 --max-model-len 1024 --gpu-memory-utilization 0.85

#  --model Qwen/Qwen2.5-7B-Instruct
