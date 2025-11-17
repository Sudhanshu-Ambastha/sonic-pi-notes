import os
import json
import re

AUDIO_ROOT = "root/sonic-pi-notes/audio"         
OUTPUT_JSON = "./audio/samples.json"

def numeric_key(s):
    nums = re.findall(r'\d+', s)
    return [int(n) for n in nums] if nums else [0]

def build_structure(root):
    structure = {}

    for dirpath, _, filenames in os.walk(root):
        audio_files = [
            os.path.join(dirpath, f).replace("\\", "/")
            for f in filenames
            if f.lower().endswith((".wav", ".mp3"))
        ]

        if not audio_files:
            continue

        audio_files.sort(key=numeric_key)

        rel_path = os.path.relpath(dirpath, root)
        if rel_path == ".":  
            continue

        keys = rel_path.split(os.sep)
        current = structure
        for key in keys:
            current = current.setdefault(key, {})

        current["files"] = audio_files

    return structure

if __name__ == "__main__":
    data = build_structure(AUDIO_ROOT)

    os.makedirs(os.path.dirname(OUTPUT_JSON), exist_ok=True)
    with open(OUTPUT_JSON, "w", encoding="utf-8") as f:
        json.dump(data, f, indent=2)
    
    print(f"✅ JSON mapping saved to {OUTPUT_JSON}")
