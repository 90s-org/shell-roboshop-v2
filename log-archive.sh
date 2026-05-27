#!/bin/bash

# Usage: ./log-archive.sh <source-dir> <destination-dir> [days]

SOURCE_DIR="$1"
DEST_DIR="$2"
DAYS="${3:-14}"

if [ -z "$SOURCE_DIR" ] || [ -z "$DEST_DIR" ]; then
    echo "ERROR: Missing arguments."
    echo "Usage: $0 <source-dir> <destination-dir> [days]"
    exit 1
fi

if [ ! -d "$SOURCE_DIR" ]; then
    echo "ERROR: Source directory '$SOURCE_DIR' does not exist."
    exit 1
fi

if [ ! -d "$DEST_DIR" ]; then
    echo "Destination '$DEST_DIR' not found. Creating it..."
    mkdir -p "$DEST_DIR"
fi

FILES=$(find "$SOURCE_DIR" -maxdepth 1 -name "*.log" -type f -mtime +$DAYS)

if [ -z "$FILES" ]; then
    echo "No log files older than $DAYS days found in '$SOURCE_DIR'."
    exit 0
fi

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
ARCHIVE_NAME="logs_archive_${TIMESTAMP}.tar.gz"
ARCHIVE_PATH="${DEST_DIR}/${ARCHIVE_NAME}"

echo "Archiving files older than $DAYS days from '$SOURCE_DIR' to '$ARCHIVE_PATH'..."

while IFS= read -r FILE; do
    echo "  Adding: $FILE"
done <<< "$FILES"

tar -czf "$ARCHIVE_PATH" $FILES

if [ $? -eq 0 ]; then
    echo "Archive created: $ARCHIVE_PATH"
else
    echo "ERROR: Failed to create archive."
    exit 1
fi
