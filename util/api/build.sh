#!/bin/bash
set -xe

docker build -t sulliedeclat/util-api:latest .
docker tag sulliedeclat/util-api:latest registry.convex.watsonkp.com/sulliedeclat/util-api:latest
docker push registry.convex.watsonkp.com/sulliedeclat/util-api:latest
