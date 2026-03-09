#!/bin/bash

# Script to install package with optional virtual environment
# Usage: ./script.sh [venv|no_venv]

MODE="${1:-no_venv}"
PROJECT_DIR="WORKING_DIR"
OSCRYPTO_FILE="$PROJECT_DIR/v/lib/python3.12/site-packages/oscrypto/_openssl/_libcrypto_ctypes.py"

if [ "$MODE" = "venv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv "$PROJECT_DIR/v"
    "$PROJECT_DIR/v/bin/pip" install .
    echo "Package installed in virtual environment"
elif [ "$MODE" = "no_venv" ]; then
    echo "Installing package in system Python..."
    pip install .
    echo "Package installed in system Python"
else
    echo "Invalid argument. Use 'venv' or 'no_venv'"
    exit 1
fi

# Fix oscrypto for double-digit OpenSSL versions
echo "Fixing oscrypto for double-digit OpenSSL versions..."
if [ -f "$OSCRYPTO_FILE" ]; then
    sed -i "s/\\\\b(\\\\d\\\\.\\\\d\\\\.\\\\d\[a-z\]*)\\\\b/\\\\b(\\\\d+\\\\.\\\\d+\\\\.\\\\d+\[a-z\]*)\\\\b/" "$OSCRYPTO_FILE"
    echo "Fixed $OSCRYPTO_FILE"
else
    echo "oscrypto file not found at $OSCRYPTO_FILE"
    exit 1
fi

echo "Done!"
