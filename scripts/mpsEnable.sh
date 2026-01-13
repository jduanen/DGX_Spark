#!/bin/bash
#
# Script to enable the auto-start of MPS on reboot

sudo systemctl daemon-reload
sudo systemctl enable nvidia-mps
sudo systemctl start nvidia-mps
sudo systemctl status nvidia-mps  # verify it's running
nvidia-smi  # should see nvidia-cuda-mps-server running
