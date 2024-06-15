#!/bin/sh

# URL of the web application
URL="http://localhost"

# Expected content
EXPECTED_CONTENT="Welcome to My Simple Web App"

# Send a request to the URL and store the response
RESPONSE=$(curl -s $URL)

# Check if the response contains the expected content
if echo "$RESPONSE" | grep -q "$EXPECTED_CONTENT"; then
    echo "Test passed: Found expected content."
    exit 0
else
    echo "Test failed: Expected content not found."
    exit 1
fi
