#!/usr/bin/env python3
"""
Build NeMo JSON manifests from a directory of labeled audio files.

Expected input layout:
    /workspace/data/audio/
        <class_label>/
            <file>.wav
            ...

Output manifests written to /workspace/data/manifests/:
    train.json, val.json, test.json

Each manifest line:
    {"audio_filepath": "...", "duration": <seconds>, "label": "<class>"}
"""

import argparse
import json
import os
import random
import soundfile as sf
from pathlib import Path


def scan_audio(audio_root: Path) -> list[dict]:
    records = []
    for label_dir in sorted(audio_root.iterdir()):
        if not label_dir.is_dir():
            continue
        label = label_dir.name
        for wav in sorted(label_dir.glob("**/*.wav")):
            try:
                info = sf.info(str(wav))
                records.append({
                    "audio_filepath": str(wav),
                    "duration": info.duration,
                    "label": label,
                })
            except Exception as e:
                print(f"Skipping {wav}: {e}")
    return records


def write_manifest(records: list[dict], path: Path) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with open(path, "w") as f:
        for r in records:
            f.write(json.dumps(r) + "\n")
    print(f"Wrote {len(records)} records → {path}")


def split(records, train=0.8, val=0.1):
    random.shuffle(records)
    n = len(records)
    t = int(n * train)
    v = int(n * val)
    return records[:t], records[t:t+v], records[t+v:]


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--audio-dir", default="/workspace/data/audio")
    parser.add_argument("--manifest-dir", default="/workspace/data/manifests")
    parser.add_argument("--seed", type=int, default=42)
    args = parser.parse_args()

    random.seed(args.seed)
    records = scan_audio(Path(args.audio_dir))
    print(f"Found {len(records)} audio files across {len(set(r['label'] for r in records))} classes")

    train, val, test = split(records)
    manifest_dir = Path(args.manifest_dir)
    write_manifest(train, manifest_dir / "train.json")
    write_manifest(val,   manifest_dir / "val.json")
    write_manifest(test,  manifest_dir / "test.json")


if __name__ == "__main__":
    main()
