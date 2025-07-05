#!/bin/bash

# ANSI color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print a separator
separator() {
  echo -e "${YELLOW}--------------------------------------------------${NC}"
}

# Function to format and print output
print_info() {
  separator
  echo -e "${BLUE}$1${NC}"
  separator
  echo "$2"
  separator
}

# Default model

# Default model
MODEL="gemini-2.0-flash"
API_URL="https://generativelanguage.googleapis.com/v1beta/models/$MODEL:generateContent?key=$GEMINI_API_KEY"

# Model Selection
while getopts "go" opt; do
  case $opt in
  g)
    MODEL="gemini-2.0-flash"
    API_URL="https://generativelanguage.googleapis.com/v1beta/models/$MODEL:generateContent"
    API_KEY="$GEMINI_API_KEY"
    ;;
  o)
    MODEL="gpt-4o"
    API_URL="https://api.openai.com/v1/chat/completions"
    API_KEY="$OPENAI_API_KEY"
    ;;
  \?)
    echo "Invalid option: -$OPTARG" >&2
    exit 1
    ;;
  esac
done

# Remove the options from the argument list
shift $((OPTIND - 1))

# Read user input
if [ -t 0 ]; then
  read -r -p "Enter your prompt: " PROMPT
else
  PROMPT=$(cat)
fi

# Check if prompt is empty
if [ -z "$PROMPT" ]; then
  echo "Prompt is empty. Exiting."
  exit 1
fi

# Prepare the request body
# Prepare the request body
if [ "$MODEL" == "gemini-2.0-flash" ]; then
  DATA='{"contents": [{"parts": [{"text": "'"$PROMPT"'"}]}]}'
elif [ "$MODEL" == "gpt-4o" ]; then
  DATA='{"model": "gpt-4o", "messages": [{"role": "user", "content": "'"$PROMPT"'"}]}'
fi

# Sending Request
print_info "Sending to $MODEL" "$DATA"

# Make the API request
RESPONSE=$(curl -s -X POST \
  -H "Content-Type: application/json" \
  -d "$DATA" \
  "$API_URL" 2>&1)

# Display the entire response
print_info "Full API Response" "$RESPONSE"

# Extracting Response
if [ "$MODEL" == "gemini-2.0-flash" ]; then
  RESULT=$(echo "$RESPONSE" | jq -r '.candidates[0].content.parts[0].text')
elif [ "$MODEL" == "gpt-4o" ]; then
  RESULT=$(echo "$RESPONSE" | jq -r '.choices[0].message.content')
fi

# Displaying Response
print_info "Received from $MODEL" "$RESULT"
