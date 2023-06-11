#!/bin/bash

set -e

docker build -t example/git-git:0.1 .
docker tag example/git-git:0.1 registry.infrastructure.svc.cluster.local/example/git-git:latest
docker push registry.infrastructure.svc.cluster.local/example/git-git:latest
