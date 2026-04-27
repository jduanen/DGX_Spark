#!/usr/bin/env python3
"""
Train an audio signature classifier from scratch using NeMo.

Placeholder — fill in once training data is collected and
the fine-tuning baseline (finetune_audio_classifier.py) is validated.

Architecture plan:
  - Encoder: NVIDIA ECAPA-TDNN or custom CNN+LSTM
  - Decoder: linear classifier head
  - Loss: cross-entropy
  - Framework: NeMo EncDecClassificationModel with custom config

See NeMo docs for from-scratch training:
  https://docs.nvidia.com/nemo-framework/user-guide/latest/
"""

raise NotImplementedError(
    "From-scratch training not yet implemented. "
    "Run finetune_audio_classifier.py first to establish a baseline."
)
