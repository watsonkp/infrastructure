#!/bin/bash

set -xe

docker build -t example/backup:latest .
docker tag example/backup:latest registry.infrastructure.svc.cluster.local/example/backup:latest
docker push registry.infrastructure.svc.cluster.local/example/backup:latest
