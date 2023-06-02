#!/bin/bash

set -e

docker build -t sulliedeclat/git-ssh:0.3 .
docker tag sulliedeclat/git-ssh:0.3 registry.convex.watsonkp.com/sulliedeclat/git-ssh:0.3
docker push registry.convex.watsonkp.com/sulliedeclat/git-ssh:0.3
