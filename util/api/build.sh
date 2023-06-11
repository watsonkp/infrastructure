#!/bin/bash
set -xe

docker build -t example/util-api:latest .
docker tag example/util-api:latest registry.infrastructure.svc.cluster.local/example/util-api:latest
docker push registry.infrastructure.svc.cluster.local/example/util-api:latest
