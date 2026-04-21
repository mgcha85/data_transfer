#!/bin/bash

# mineru-deploy.zip 복원 및 압축 해제 스크립트

echo "Checking for split parts..."
if ls mineru-deploy.zip.part* 1> /dev/null 2>&1; then
    echo "Combining parts into mineru-deploy.zip..."
    cat mineru-deploy.zip.part* > mineru-deploy.zip
    echo "Combination complete."
    
    echo "Unzipping mineru-deploy.zip..."
    if command -v unzip >/dev/null 2>&1; then
        unzip mineru-deploy.zip
        echo "Extraction complete."
    else
        echo "Error: 'unzip' command not found. Please install unzip to extract the file."
    fi
else
    echo "Error: Split parts not found (mineru-deploy.zip.part*)."
fi
