#!/usr/bin/env bash

#set -x

# Define the cleanup function
cleanup() {
    local DIR=$1

    if [[ -d "$DIR" ]]; then
        echo "Cleaning up files inside directory: $DIR"

        # Remove only files inside the directory, not subdirectories
        find "$DIR" -type f -exec rm -f {} \;

        echo "Files inside $DIR have been removed."
    else
        echo "Warning: Directory not found or invalid: $DIR"
    fi
}

# Specify the directory containing remove.txt
REMOVE_FILE_DIR="/home/sepehr/files"
REMOVE_FILE="${REMOVE_FILE_DIR}/remove.txt"

# Check if the remove.txt file exists
if [ ! -f "$REMOVE_FILE" ]; then
  echo "Error: $REMOVE_FILE does not exist."
  exit 1
fi

while IFS= read -r DIR || [[ -n "$DIR" ]]; do
    # Skip empty lines or lines starting with #
    if [[ -z "$DIR" || "$DIR" =~ ^# ]]; then
        continue
    fi

    # Call the cleanup function
    cleanup "$DIR"
done < "$REMOVE_FILE"

echo "Cleanup completed."

