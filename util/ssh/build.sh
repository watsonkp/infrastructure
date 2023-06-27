#!/bin/bash

set -e

docker build -t example/ssh:latest .
docker tag example/ssh:latest registry.infrastructure.svc.cluster.local/example/ssh:latest
docker push registry.infrastructure.svc.cluster.local/example/ssh:latest
