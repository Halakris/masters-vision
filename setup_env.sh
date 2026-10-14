#!/bin/bash
# Masters-Vision Setup Script
# This script creates a virtual environment, sources it, and installs dependencies

set -e

echo "=== Masters-Vision Setup ==="

# Check if we're in a git repo and if there's a remote
if [ ! -d .git ]; then
    echo "Initializing git repository..."
    git init
fi

# Create virtual environment if it doesn't exist
if [ ! -d "venv" ]; then
    echo "Creating virtual environment..."
    python3 -m virtualenv venv --prompt "(masters-vision)"
    echo "Virtual environment created."
else
    echo "Virtual environment already exists."
fi

# Source the virtual environment
echo "Sourcing virtual environment..."
source venv/bin/activate

# Install dependencies
echo "Installing dependencies..."
python3 -m pip install --upgrade pip
pip install -r requirements.txt

echo ""
echo "=== Setup Complete ==="
echo "Virtual environment is active. To deactivate later, run: deactivate"
echo "To work on the project, make sure the venv is sourced:"
echo "  source venv/bin/activate"