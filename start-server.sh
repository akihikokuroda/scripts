#!/usr/bin/env bash

# Start a development container
# Usage:
# ./start-server.sh <image-prefix> <unique port number>
#
# Access:
# ssh root@localhost -p <unique port number>

docker run -d --name $1-container -v /var/run/docker.sock:/var/run/docker.sock -v /Users/akihikokuroda/development/scripts:/root/scripts -v /Users/akihikokuroda/.kube:/root/.kube -p $2:22 $1-image
