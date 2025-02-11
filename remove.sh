#!/usr/bin/env bash

#set -x
set -Eeuo pipefail
trap cleanup SIGINT SIGTERM ERR EXIT

# Define the cleanup function
cleanup() {
    rm -f $LOCK_FILE
    exit 0
}

LOCK_FILE="/var/lock/remove.lock"
# Check if another instance of script is running
if [ -f $LOCK_FILE ];then
    echo "Another instance is running"
    exit 1
fi

# Create the lock file     
touch $LOCK_FILE

# Create the log directory if it doesn't exist
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/$(date +%Y%m%d).log"


# Define the logme function
logme() {
    local message=$1
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $message" >> "$LOG_FILE"
    curl -s -X POST https://api.telegram.org/bot$BOT_TOKEN/sendMessage -d chat_id=$CHAT_ID -d text="$(date '+%Y-%m-%d %H:%M:%S') - $message" > /dev/null

}

#  Define the cleaner function
cleaner() {
    local LINE=$1

    if [[ -d "$LINE" ]]; then
        # Remove only files inside the directorys
        find "$LINE" -type f -print -exec rm -f {} \; >> "$LOG_FILE"
    else
	logme "Directory not found or invalid: $LINE"
	exit 1
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

logme "Cleanup completed."

