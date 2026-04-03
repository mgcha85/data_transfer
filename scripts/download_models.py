import os
import argparse
from huggingface_hub import snapshot_download as hf_download
from modelscope import snapshot_download as ms_download

def download_models(target_dir, source='huggingface'):
    os.makedirs(target_dir, exist_ok=True)
    
    models = [
        {"repo": "opendatalab/PDF-Extract-Kit-1.0", "mode": "pipeline"},
        # Add VLM models if needed, e.g. "opendatalab/MinerU2.5-2509-1.2B"
    ]
    
    download_func = hf_download if source == 'huggingface' else ms_download
    
    for model in models:
        repo = model["repo"]
        print(f"Downloading {repo} from {source} to {target_dir}...")
        
        # Download everything into target_dir
        # PDF-Extract-Kit structure: models/Layout/..., models/MFR/..., etc.
        path = download_func(
            repo,
            local_dir=target_dir,
            local_dir_use_symlinks=False
        )
        print(f"Finished downloading {repo} to {path}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Download MinerU models for offline use.")
    parser.add_argument("--dir", default="./models", help="Target directory for models")
    parser.add_argument("--source", default="huggingface", choices=["huggingface", "modelscope"], help="Model source")
    
    args = parser.parse_args()
    download_models(args.dir, args.source)
