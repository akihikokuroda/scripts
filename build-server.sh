#!/usr/bin/env bash

# Generate a development image
# Usage:
# ./build-server.sh <image-prefix>

docker build -t $1-image -f Dockerfile .
