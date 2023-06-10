#!/bin/bash
set -xe

docker build -t sulliedeclat/elastic-tls-init:latest .
docker tag sulliedeclat/elastic-tls-init:latest registry.convex.watsonkp.com/sulliedeclat/elastic-tls-init:latest
docker push registry.convex.watsonkp.com/sulliedeclat/elastic-tls-init:latest
