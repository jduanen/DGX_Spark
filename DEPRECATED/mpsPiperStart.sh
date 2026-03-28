#!/bin/bash
#
# Script to run Piper under MPS on DGX Spark

#### FIXME test if MPS is already started and don't do this
if [ 1 ]; then
    export CUDA_MPS_PIPE_DIRECTORY=/tmp/nvidia-mps
    export CUDA_MPS_LOG_DIRECTORY=/var/log/nvidia-mps
    #### FIXME test and don't do if already there
    if [ 1 ]; then
	sudo mkdir -p $CUDA_MPS_PIPE_DIRECTORY $CUDA_MPS_LOG_DIRECTORY
    fi
    sudo -E nvidia-cuda-mps-control -d
    sleep 2  # wait for daemon to be ready
fi

# launch 16 piper instances (all sharing MPS)
for i in {0..15}; do
  CUDA_VISIBLE_DEVICES=0 \
  numactl --cpunodebind=0 --membind=0 \
    piper \
      --tensorrt-engine /models/ryan_high_b200_fp8.plan \
      --cuda-graph \
      --port $((8000+i)) &
done

wait
