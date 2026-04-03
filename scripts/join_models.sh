#!/bin/bash

# Find all files with 3-digit numeric extensions (e.g., .001, .002)
# and merge them into their parent filenames.

echo "Looking for split files to rejoin..."

find . -name "*.001" | while read first_part; do
    original_file="${first_part%.001}"
    echo "Rejoining parts into $original_file..."
    
    # Concatenate all parts in order: 001, 002, 003...
    cat "$original_file".[0-9][0-9][0-9] > "$original_file"
    
    # Verify reconstruction
    if [ $? -eq 0 ]; then
        echo "Successfully joined $original_file. Deleting parts..."
        rm "$original_file".[0-9][0-9][0-9]
    else
        echo "Error joining $original_file. Keeping parts."
    fi
done

echo "Rejoin complete!"
