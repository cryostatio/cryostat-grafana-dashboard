#!/bin/sh

if [ -z "$GRAFANA_IMAGE" ]; then
    GRAFANA_IMAGE="quay.io/cryostat/cryostat-grafana-dashboard"
fi

if [ -z "$BUILDER" ]; then
    BUILDER="podman"
fi

$BUILDER build -t $GRAFANA_IMAGE:latest -f "$(dirname $0)"/Containerfile
