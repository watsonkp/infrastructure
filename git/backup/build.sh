#!/bin/bash

set -xe

docker build -t sulliedeclat/backup:latest .
docker tag sulliedeclat/backup:latest registry.convex.watsonkp.com/sulliedeclat/backup:latest
docker push registry.convex.watsonkp.com/sulliedeclat/backup:latest
