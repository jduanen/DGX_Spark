#!/bin/bash
#
# Script to stop Piper running under MPS

echo quit | sudo nvidia-cuda-mps-control
