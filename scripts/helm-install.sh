#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source "$SCRIPT_DIR"/settings.sh

echo -n Docker Hub password:
read -rs password
echo

microk8s kubectl create namespace "$NAMESPACE"
microk8s kubectl -n "$NAMESPACE" create secret "$SECRET_DOCKER_REGISTRY" docker-credentials \
        --docker-server=https://index.docker.io/v1/ \
        --docker-username="$DOCKER_USERNAME" \
        --docker-password="$password" \
        --docker-email="$DOCKER_EMAIL"

microk8s helm -n "$NAMESPACE" install "$DEPLOYMENT" "$SCRIPT_DIR"/../SpringBootServer/helm/chart-spring-boot/ \
        --set serverdeployment.image="$DOCKER_USERNAME"/"$DOCKER_REPO"

echo "Helm deployment ..."
microk8s helm -n "$NAMESPACE" list
echo "Namespace all ..."
microk8s kubectl -n "$NAMESPACE" get all
