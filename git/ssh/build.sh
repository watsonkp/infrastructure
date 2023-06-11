#!/bin/bash

set -e

docker build -t example/git-ssh:0.3 .
docker tag example/git-ssh:0.3 registry.infrastructure.svc.cluster.local/example/git-ssh:0.3
docker push registry.infrastructure.svc.cluster.local/example/git-ssh:0.3
