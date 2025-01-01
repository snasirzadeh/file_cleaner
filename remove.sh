#!/usr/bin/env bash

set -x
set -Eeuo pipefail
trap cleanup SIGINT SIGTERM ERR

# Define the cleanup function
cleanup() {
    logme "Script terminated"
    rm -f $LOCK_FILE
    exit 1
}
############

LOCK_FILE="/var/lock/remove.lock"
# Check if another instance of script is running
if [ -f $LOCK_FILE ];then
    echo "Another instance is running"
    exit 1
fi

# Create the lock file     
touch $LOCK_FILE


# script directory
script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)
cd "$script_dir"



#load environment variable from .env file
if [[ -f ".env" ]]; then
    source .env
else
    echo 'Error: .env file not found.'
    exit 1
fi

# Create the log directory if it doesn't exist
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/$(date +%Y%m%d).log"


# Define the logme function
logme() {
    local message=$1
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $message" >> "$LOG_FILE"

}

# Define the cleaner function
cleaner() {
    local LINE=$1

    if [[ -d "$LINE" ]]; then
        # Remove only files inside the directorys
        find "$LINE" -type f -print -exec rm -f {} \; >> "$LOG_FILE"
    else
	logme "Directory not found or invalid: $LINE"
    fi
}

# Read and check every line in remove file
while IFS= read -r DIR || [[ -n "$DIR" ]]; do
    # Skip empty lines or lines starting with #
    if [[ -z "$DIR" || "$DIR" =~ ^# ]]; then
        continue
    elif [[ "$DIR" != ${REMOVE_PATH}* ]]; then
        logme "Invalid Directory Path : $DIR"
        exit 1
    # Check for Invalid Filename 
    elif [[ "$DIR" =~ $INVALID_FILENAME ]]; then
	logme "Invalid Filename : $DIR"
	exit 1
    fi    
done < "$REMOVE_FILE_PATH"

# Raed lines and call cleaner function
while IFS= read -r LINE; do
    # Skip empty lines or lines starting with #
    if [[ -z "$LINE" || "$LINE" =~ ^# ]]; then
        continue
    else
    # Call the cleaner function
    cleaner "$LINE"
    fi
done < "$REMOVE_FILE_PATH"

rm -f $LOCK_FILE && logme "Cleanup completed."

