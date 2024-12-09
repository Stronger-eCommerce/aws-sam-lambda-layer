#!/bin/bash

PYTHON_VERSION=python3.12

# Set some color codes for better output readability
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to print error and exit
error_exit() {
    echo -e "${RED}Error: $1${NC}" >&2
    exit 1
}

# Check if Python3 is installed
command -v python3 >/dev/null 2>&1 || error_exit "Python3 is not installed"

# Check if pip is installed
command -v pip >/dev/null 2>&1 || error_exit "pip is not installed"

# Check if sam is installed
command -v sam >/dev/null 2>&1 || error_exit "AWS SAM CLI is not installed"

# Create and activate virtual environment
echo -e "${YELLOW}Creating virtual environment...${NC}"
python3 -m venv venv || error_exit "Failed to create virtual environment"
source venv/bin/activate || error_exit "Failed to activate virtual environment"

# Ensure we're in the correct directory with requirements.txt
if [ ! -f layer/requirements.txt ]; then
    error_exit "requirements.txt not found in layer/ directory"
fi

# Install dependencies into layer
echo -e "${YELLOW}Installing dependencies into layer...${NC}"
pip install -r layer/requirements.txt --platform manylinux2014_x86_64 --target layer/python/lib/${PYTHON_VERSION}/site-packages --only-binary=:all: || error_exit "Failed to install dependencies"

# SAM build
echo -e "${YELLOW}Running SAM build...${NC}"
sam build || error_exit "SAM build failed"

# SAM deploy
echo -e "${YELLOW}Deploying with SAM...${NC}"
sam deploy --guided || error_exit "SAM deployment failed"

# Deactivate virtual environment
deactivate

echo -e "${GREEN}Lambda layer deployment completed successfully!${NC}"
