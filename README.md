# AWS Lambda Layer for OpenAI

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A streamlined AWS Lambda Layer deployment solution for OpenAI integration using AWS SAM (Serverless Application Model). This repository provides an automated setup for creating and deploying an OpenAI-ready Lambda layer with Python 3.12.

## Features

- Automated Lambda layer creation for OpenAI dependencies
- Cross-platform compatibility (Linux, macOS, Windows)
- Preconfigured for Python 3.12
- Automated dependency management
- AWS SAM deployment pipeline
- Error handling and detailed logging

## Prerequisites

Before you begin, ensure you have the following installed:

- Python 3.12
- AWS CLI configured with appropriate credentials
- AWS SAM CLI
- pip (Python package installer)
- Git

## Quick Start

1. Clone the repository:
```bash
git clone https://github.com/yourusername/aws-lambda-openai-layer
cd aws-lambda-openai-layer
```

2. Run the deployment script:
```bash
chmod +x deploy.sh
./deploy.sh
```

## Directory Structure

```
.
├── deploy.sh
├── layer/
│   └── requirements.txt
├── template.yaml
└── README.md
```

## Deployment Script

The `deploy.sh` script automates the entire process:

```bash
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
```

## Example Lambda Function

After deploying the layer, create a new Lambda function with this code to test the layer:

```python
import json

def lambda_handler(event, context):
    print("importing openai")
    import openai
    print("imported openai")
    
    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Lambda!')
    }
```

This example function:
1. Imports the `openai` package from the layer
2. Prints logging messages to confirm the import
3. Returns a successful response with a greeting message

## Testing Your Function

1. Navigate to your Lambda function in the AWS Console
2. Click on the "Test" tab
3. Create a new test event with any name (e.g., "MyEventName")
4. The test event can be empty as this example doesn't require any input:
```json
{}
```

5. Click "Test" to run the function

### Expected Output
You should see a response like this:
```json
{
    "statusCode": 200,
    "body": "\"Hello from Lambda!\""
}
```

The function logs will show:
```
importing openai
imported openai
```

This confirms that:
- The Lambda function executed successfully (200 status code)
- The OpenAI package was imported correctly from the layer
- The basic functionality is working

## Troubleshooting

Common issues and solutions:

1. **Python Version Issues**
   - Ensure Python 3.12 is installed on your system
   - Verify your Lambda function is using Python 3.12 runtime

2. **Deployment Failures**
   - Verify AWS credentials are configured correctly
   - Check CloudWatch logs for detailed error messages

3. **Dependency Issues**
   - Ensure all packages in requirements.txt are compatible with Lambda
   - Verify package versions are specified correctly

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes:

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

If you encounter any issues or have questions:
1. Check the [Issues](https://github.com/yourusername/aws-lambda-openai-layer/issues) page
2. Create a new issue if your problem isn't already listed
3. Provide detailed information about your environment and the issue

---
Made with ❤️ by Stronger eCommerce
