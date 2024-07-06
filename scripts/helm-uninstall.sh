#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source "$SCRIPT_DIR"/settings.sh

microk8s helm -n "$NAMESPACE" uninstall "$DEPLOYMENT"

microk8s kubectl -n "$NAMESPACE" delete secrets docker-credentials
microk8s kubectl delete namespace "$NAMESPACE"
