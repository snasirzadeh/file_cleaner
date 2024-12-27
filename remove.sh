#!/usr/bin/env bash

#set -x

#set -Eeuo pipefail

# snippet from https://stackoverflow.com/a/246128/10102404
script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

cd "$script_dir"

    #load environment variable from .env file
    if [[ -f ".env" ]]; then
    	source .env
    else
    	echo "Error: .env file not found."
    	exit 1
    fi

# Define the cleanup function
cleanup() {
    local DIR=$1

    if [[ -d "$DIR" ]]; then
        echo "Cleaning up files inside directory: $DIR"

        # Remove only files inside the directorys
        find "$DIR" -type f -exec rm -f {} \;

        echo "Files inside $DIR have been removed."
    else
        echo "Warning: Directory not found or invalid: $DIR"
    fi
}


while IFS= read -r DIR || [[ -n "$DIR" ]]; do
    # Skip empty lines or lines starting with #
    if [[ -z "$DIR" || "$DIR" =~ ^# ]]; then
        continue
    # check if the path contains a space
    elif [[ "$DIR" == *" "* ]]; then
	echo "Error remove file contains a space."
	exit 1
    fi

    # Call the cleanup function
    cleanup "$DIR"
done < "$REMOVE_FILE_PATH"

echo "Cleanup completed."

