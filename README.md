Development Environment in Docker

Build docker image

./build-server.sh "image prefix"

This scripts builds a development environment image with Docker file

Start the image

./start-server.sh "image prefix" "access port"

This script starts the development environment image.  The environment is accessible via ssh.

ssh root@localhost:"access port"

The password is "root"

Clean up

docker kill "id"
docker rm "id"
docker rmi "image-name"
remove a line in ~/.ssh/known_hosts

Restart server

docker start "id"