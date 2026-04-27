#!/usr/bin/env python3
"""
Fine-tune a NeMo audio encoder for audio signature classification.

Strategy: load a pre-trained EncDecClassificationModel (e.g., TitaNet-Large),
replace the classifier head with one sized for your label set, then train
only the new head first, then unfreeze the encoder for full fine-tuning.

Usage (inside the NeMo container):
    python /workspace/scripts/finetune_audio_classifier.py \
        --train-manifest /workspace/data/manifests/train.json \
        --val-manifest   /workspace/data/manifests/val.json \
        --num-classes    <N> \
        --epochs         10

Checkpoints saved to /workspace/checkpoints/.
"""

import argparse
from omegaconf import OmegaConf, DictConfig
import pytorch_lightning as pl
from nemo.collections.asr.models import EncDecClassificationModel


PRETRAINED_MODEL = "nvidia/speakerverification_en_titanet_large"


def build_config(args) -> DictConfig:
    cfg = OmegaConf.structured(EncDecClassificationModel.from_pretrained(PRETRAINED_MODEL).cfg)

    # Replace classifier head for our label count
    cfg.decoder.num_classes = args.num_classes

    # Training manifests
    cfg.train_ds.manifest_filepath = args.train_manifest
    cfg.train_ds.batch_size = args.batch_size
    cfg.train_ds.shuffle = True
    cfg.train_ds.num_workers = 4

    cfg.validation_ds.manifest_filepath = args.val_manifest
    cfg.validation_ds.batch_size = args.batch_size
    cfg.validation_ds.shuffle = False
    cfg.validation_ds.num_workers = 4

    return cfg


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--train-manifest", required=True)
    parser.add_argument("--val-manifest", required=True)
    parser.add_argument("--num-classes", type=int, required=True)
    parser.add_argument("--batch-size", type=int, default=32)
    parser.add_argument("--epochs", type=int, default=10)
    parser.add_argument("--checkpoint-dir", default="/workspace/checkpoints")
    args = parser.parse_args()

    # Load pre-trained model
    model = EncDecClassificationModel.from_pretrained(PRETRAINED_MODEL)

    # Swap decoder head
    model.change_labels(new_labels=[str(i) for i in range(args.num_classes)])

    # Phase 1: freeze encoder, train head only
    model.encoder.freeze()
    model.setup_training_data(OmegaConf.create({
        "manifest_filepath": args.train_manifest,
        "batch_size": args.batch_size,
        "shuffle": True,
        "num_workers": 4,
    }))
    model.setup_validation_data(OmegaConf.create({
        "manifest_filepath": args.val_manifest,
        "batch_size": args.batch_size,
        "shuffle": False,
        "num_workers": 4,
    }))

    trainer = pl.Trainer(
        max_epochs=args.epochs // 2,
        accelerator="gpu",
        devices=-1,
        default_root_dir=args.checkpoint_dir,
        log_every_n_steps=10,
    )
    trainer.fit(model)

    # Phase 2: unfreeze encoder for full fine-tuning
    model.encoder.unfreeze()
    trainer2 = pl.Trainer(
        max_epochs=args.epochs - args.epochs // 2,
        accelerator="gpu",
        devices=-1,
        default_root_dir=args.checkpoint_dir,
        log_every_n_steps=10,
    )
    trainer2.fit(model)

    out = f"{args.checkpoint_dir}/audio_classifier_finetuned.nemo"
    model.save_to(out)
    print(f"Model saved to {out}")


if __name__ == "__main__":
    main()
