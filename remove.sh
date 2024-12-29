#!/usr/bin/env bash


# Check if another instance of script is running
if pidof -o %PPID -x "$0" >/dev/null; then
  printf >&2 '%s\n' "ERROR: Script $0 already running"
  exit 1
fi

set -x

set -Eeuo pipefail
trap cleanup SIGINT SIGTERM ERR

# script directory
script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)
cd "$script_dir"

    #load environment variable from .env file
    if [[ -f ".env" ]]; then
    	source .env
    else
    	echo "Error: .env file not found."
    	exit 1
    fi

#Create the log directory if it doesn't exist
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/$(date +%Y%m%d).log"

# Define the cleaner function
cleaner() {
    local DIR=$1

    if [[ -d "$DIR" ]]; then
        echo "Cleaning up files inside directory: $DIR" >> "$LOG_FILE"

        # Remove only files inside the directorys
        find "$DIR" -type f -exec rm -f {} \;

        echo "Files inside $DIR have been removed." >> "$LOG_FILE"
    else
        echo "Directory not found or invalid: $DIR" >> "$LOG_FILE"
    fi
}


while IFS= read -r DIR || [[ -n "$DIR" ]]; do
    # Skip empty lines or lines starting with #
    if [[ -z "$DIR" || "$DIR" =~ ^# ]]; then
        continue
    # check if the path contains a space
    elif [[ "$DIR" == *" "* ]]; then
	echo "Error remove file contains a space." >> "$LOG_FILE"
	exit 1
    fi

    # Call the cleaner function
    cleaner "$DIR"
done < "$REMOVE_FILE_PATH"

echo "Cleanup completed. $(date +%Y_%m_%d)" >> "$LOG_FILE"

