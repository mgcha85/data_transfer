#!/bin/bash

# This script reassembles and extracts the split zip files.

echo "Reassembling wheels.zip from parts..."
cat wheels.zip.part_* > wheels.zip

if [ $? -eq 0 ]; then
    echo "Reassembly successful. Extracting wheels.zip..."
    unzip wheels.zip
    
    if [ $? -eq 0 ]; then
        echo "Extraction successful. Cleaning up wheels.zip..."
        rm wheels.zip
    else
        echo "Error: Extraction failed."
        exit 1
    fi
else
    echo "Error: Reassembly failed."
    exit 1
fi

echo "Done. All .whl files have been restored."
