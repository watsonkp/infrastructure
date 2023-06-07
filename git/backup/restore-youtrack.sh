#!/bin/sh

set -xe

ping -c 3 $BACKUP_HOST

COUNT=$(ssh -i /key/id_ed25519 -o UserKnownHostsFile=/config/known_hosts "$BACKUP_USER@$BACKUP_HOST" "ls $BACKUP_OUTPUT" | wc -l)
test $COUNT != 0 || return 0
scp -i /key/id_ed25519 -o UserKnownHostsFile=/config/known_hosts "$BACKUP_USER@$BACKUP_HOST:$BACKUP_OUTPUT*" /opt/youtrack/backups/
