#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source "$SCRIPT_DIR"/settings.sh

echo -n Docker Hub password:
read -rs password
echo

echo "1. docker build ..."
docker build -t "$IMAGE" "$SCRIPT_DIR"/../SpringBootServer/

echo "2. docker images ..."
docker images "$IMAGE"

echo "3. docker login ..."
docker login --username "$DOCKER_USERNAME" --password "$password"

echo "4. docker tag ..."
docker tag "$IMAGE" "$DOCKER_USERNAME"/"$DOCKER_REPO"

echo "5. docker push ..."
docker push "$DOCKER_USERNAME"/"$DOCKER_REPO"

echo "6. delete local image ..."
docker image rm "$IMAGE" "$DOCKER_USERNAME"/"$DOCKER_REPO"
