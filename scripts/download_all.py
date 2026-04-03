import os
import argparse
from huggingface_hub import snapshot_download

def download_models(target_dir):
    os.makedirs(target_dir, exist_ok=True)
    
    # Models to download
    models = [
        {"repo": "opendatalab/PDF-Extract-Kit-1.0", "name": "pipeline"},
        {"repo": "opendatalab/MinerU2.5-2509-1.2B", "name": "vlm"}
    ]
    
    for model in models:
        repo = model["repo"]
        print(f"Downloading {repo} to {target_dir}...")
        
        # Download everything into target_dir
        path = snapshot_download(
            repo,
            local_dir=target_dir,
            local_dir_use_symlinks=False,
            # We want to ensure all files are locally present
        )
        print(f"Finished downloading {repo} to {path}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Download all MinerU models for offline use.")
    parser.add_argument("--dir", default="./models", help="Target directory for models")
    
    args = parser.parse_args()
    download_models(args.dir)
