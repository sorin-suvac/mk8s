#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source "$SCRIPT_DIR"/settings.sh

TLS_DIR="$SCRIPT_DIR"/../tls
TLS_HOST="my-tls.example.com"
TLS_SECRET="external-ip-tls"

echo "Generate ssl certificate ..."
mkdir "$TLS_DIR"
openssl req -x509 -newkey rsa:4096 -sha256 -nodes -keyout "$TLS_DIR"/tls.key -out "$TLS_DIR"/tls.crt -subj "/CN=$TLS_HOST" -days 3650

echo "Create tls secret ..."
microk8s kubectl -n "$NAMESPACE" create secret tls "$TLS_SECRET" --cert="$TLS_DIR"/tls.crt --key="$TLS_DIR"/tls.key

echo "Create tls ingress ..."
microk8s kubectl -n helm-server apply -f - <<EOF
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
  name: tls-ingress
  namespace: "$NAMESPACE"
  labels:
    app: "$APP"
spec:
  tls:
  - hosts:
      - "$TLS_HOST"
    secretName: "$TLS_SECRET"
  rules:
  - host: "$TLS_HOST"
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: helm-server-load-balancer
            port:
              number: 80
EOF
