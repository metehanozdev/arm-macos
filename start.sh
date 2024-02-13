#!/bin/bash

# Dynamically get the user's home directory
USER_HOME=$(eval echo ~$USER)

# Path to your Python program
PROGRAM_PATH="$USER_HOME/FumeDev/start.py"

# Check if the program path exists
if [ -f "$PROGRAM_PATH" ]; then
    # Run your Python program
    python3 "$PROGRAM_PATH" "$@"
else
    echo "Error: Python program not found at $PROGRAM_PATH"
    exit 1
fi