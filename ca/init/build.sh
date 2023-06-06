#!/bin/bash

set -xe
docker build -t sulliedeclat/ssh-init:latest .
docker tag sulliedeclat/ssh-init:latest registry.convex.watsonkp.com/sulliedeclat/ssh-init:latest
docker push registry.convex.watsonkp.com/sulliedeclat/ssh-init:latest
