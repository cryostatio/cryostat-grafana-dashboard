#!/bin/sh

if [ -z "$GRAFANA_IMAGE" ]; then
    GRAFANA_IMAGE="quay.io/cryostat/cryostat-grafana-dashboard"
fi

if [ -z "$BUILDER" ]; then
    BUILDER="podman"
fi

$BUILDER build -t $GRAFANA_IMAGE:2.4.0 -f "$(dirname $0)"/Dockerfile
