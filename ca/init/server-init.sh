#!/bin/bash
set -xe

test -d /key/etc/ssh || mkdir -p /key/etc/ssh
# Generate host keys
test -d /key/etc/ssh/ssh_host_id_ed25519_key || ssh-keygen -A -f /key
# Sign host keys
ssh-keygen -s /secret/ca_host_key -I $IDENTITY -h /key/etc/ssh/ssh_host_ed25519_key.pub
