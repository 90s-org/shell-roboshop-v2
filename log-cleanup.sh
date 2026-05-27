#!/bin/bash

# Usage: ./log-cleanup.sh <directory>

LOG_DIR="$1"
DAYS=14

if [ -z "$LOG_DIR" ]; then
    echo "ERROR: No directory provided."
    echo "Usage: $0 <directory>"
    exit 1
fi

if [ ! -d "$LOG_DIR" ]; then
    echo "ERROR: Directory '$LOG_DIR' does not exist."
    exit 1
fi

echo "Scanning '$LOG_DIR' for log files older than $DAYS days..."

FILES=$(find "$LOG_DIR" -maxdepth 1 -name "*.log" -type f -mtime +$DAYS)

if [ -z "$FILES" ]; then
    echo "No log files older than $DAYS days found."
    exit 0
fi

echo "Files to be deleted:"

while IFS= read -r FILE; do
    echo "Deleting: $FILE"
    rm -f "$FILE"
done <<< "$FILES"

echo "Cleanup complete."
