#!/bin/bash

set -xe
docker build -t example/ssh-init:latest .
docker tag example/ssh-init:latest registry.infrastructure.svc.cluster.local/example/ssh-init:latest
docker push registry.infrastructure.svc.cluster.local/example/ssh-init:latest
