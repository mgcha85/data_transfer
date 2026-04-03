#!/bin/bash
# restore.sh - Reassemble and extract project chunks

# Find all chunks and concatenate them
if ls project_chunk_* 1> /dev/null 2>&1; then
    echo "Combining chunks into project.zip..."
    cat project_chunk_* > project.zip
    
    echo "Extracting project.zip..."
    unzip project.zip
    
    echo "Cleaning up..."
    rm project.zip
    echo "Project restoration complete."
else
    echo "Error: No project chunks found (expected project_chunk_*)."
    exit 1
fi
