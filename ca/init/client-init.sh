#!/bin/bash
set -xe

test -d /key || mkdir /key
# Generate client key
test -d /key/id_ed25519 || ssh-keygen -t ed25519 -f /key/id_ed25519 -N ""
# Sign client key
ssh-keygen -s /secret/ca_user_key -I $IDENTITY -n $PRINCIPALS /key/id_ed25519.pub
