#!/bin/bash
# restore_models.sh
# This script restores the Jina and BGE reranker models from their zip archives.

MODELS=("jina-reranker-v3.zip" "bge-reranker-v2-m3-ko.zip")

echo "Starting model restoration..."

for ZIP_NAME in "${MODELS[@]}"; do
    TARGET_DIR="models/${ZIP_NAME%.zip}"
    echo "----------------------------------------"
    echo "Processing $ZIP_NAME..."

    # Check for split parts first
    if [ -f "${ZIP_NAME}.part_aa" ]; then
        echo "Split files detected for $ZIP_NAME. Recombining..."
        cat ${ZIP_NAME}.part_* > "combined_${ZIP_NAME}"
        JOINED_ZIP="combined_${ZIP_NAME}"
    elif [ -f "$ZIP_NAME" ]; then
        echo "Single zip file detected for $ZIP_NAME."
        JOINED_ZIP="$ZIP_NAME"
    else
        echo "Warning: Archive $ZIP_NAME not found. Skipping..."
        continue
    fi

    echo "Unzipping to $TARGET_DIR..."
    mkdir -p "$TARGET_DIR"
    unzip -o "$JOINED_ZIP" -d .

    # Clean up temporary combined zip if it was created
    if [ "$JOINED_ZIP" == "combined_${ZIP_NAME}" ]; then
        rm "combined_${ZIP_NAME}"
    fi
done

echo "----------------------------------------"
echo "All models restored successfully."
