import os
import argparse
from loguru import logger

def split_file(file_path, chunk_size_mb=50):
    chunk_size = chunk_size_mb * 1024 * 1024  # Convert MB to Bytes
    file_size = os.path.getsize(file_path)
    
    if file_size <= 100 * 1024 * 1024:  # Only split files > 100MB
        return
    
    logger.info(f"Splitting {file_path} ({file_size / 1024 / 1024:.2f} MB) into {chunk_size_mb}MB chunks...")
    
    with open(file_path, 'rb') as f:
        chunk_idx = 1
        while True:
            chunk = f.read(chunk_size)
            if not chunk:
                break
            
            chunk_name = f"{file_path}.{chunk_idx:03d}"
            with open(chunk_name, 'wb') as cf:
                cf.write(chunk)
            
            chunk_idx += 1
    
    # After successful split, delete original
    os.remove(file_path)
    logger.success(f"Finished splitting {file_path}. Original deleted.")

def split_all_in_dir(target_dir, chunk_size_mb=50):
    for root, dirs, files in os.walk(target_dir):
        for file in files:
            file_path = os.path.join(root, file)
            # Skip hidden files and existing part files
            if file.startswith('.') or file[-4:].isdigit() and file[-5] == '.':
                continue
            
            try:
                split_file(file_path, chunk_size_mb)
            except Exception as e:
                logger.error(f"Failed to split {file_path}: {e}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Split files > 100MB into smaller chunks.")
    parser.add_argument("--dir", default="./models", help="Directory to scan")
    parser.add_argument("--size", type=int, default=50, help="Chunk size in MB")
    
    args = parser.parse_args()
    split_all_in_dir(args.dir, args.size)
