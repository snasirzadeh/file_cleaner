#!/usr/bin/env bash

set -x

# Function to clean up or handle interrupts
cleanup() {
  echo "Script interrupted or finished. Cleaning up..."
  exit
}

# Set up the trap to call the cleanup function on exit or interrupt
trap cleanup EXIT INT TERM

# Check if the directory and remove.txt file are provided
if [ -z "$1" ]; then
  echo "Usage: $0 <directory>"
  exit 1
fi

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

