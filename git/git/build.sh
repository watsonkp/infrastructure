#!/bin/bash

set -e

docker build -t sulliedeclat/git-git:0.1 .
docker tag sulliedeclat/git-git:0.1 registry.convex.watsonkp.com/sulliedeclat/git-git:latest
docker push registry.convex.watsonkp.com/sulliedeclat/git-git:latest
