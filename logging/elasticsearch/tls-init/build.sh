#!/bin/bash
set -xe

docker build -t example/elastic-tls-init:latest .
docker tag example/elastic-tls-init:latest registry.infrastructure.svc.cluster.local/example/elastic-tls-init:latest
docker push registry.infrastructure.svc.cluster.local/example/elastic-tls-init:latest
