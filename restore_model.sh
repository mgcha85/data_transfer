#!/bin/bash
# restore_model.sh
# This script restores the BGE-m3-ko model from the zip archive.

ZIP_NAME="model.zip"
TARGET_DIR="models/bge-m3-ko"

echo "Checking for model archive..."

if [ -f "${ZIP_NAME}.part_aa" ]; then
    echo "Split files detected. Recombining..."
    cat ${ZIP_NAME}.part_* > combined_model.zip
    JOINED_ZIP="combined_model.zip"
elif [ -f "$ZIP_NAME" ]; then
    echo "Single zip file detected."
    JOINED_ZIP="$ZIP_NAME"
else
    echo "Error: Model archive not found!"
    exit 1
fi

echo "Unzipping model to $TARGET_DIR..."
mkdir -p "$TARGET_DIR"
unzip "$JOINED_ZIP" -d .

# If we created a temporary joined zip, clean it up
if [ "$JOINED_ZIP" == "combined_model.zip" ]; then
    rm combined_model.zip
fi

echo "Done! Model restored successfully."
