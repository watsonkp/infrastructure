#!/bin/sh
set -xe

# Check if the backup host is reachable. Fail if it is unreachable.
ping -c 3 $BACKUP_HOST

# Check if there are remote backup files.
COUNT=$(ssh -i /key/id_ed25519 -o UserKnownHostsFile=/config/known_hosts "$BACKUP_USER@$BACKUP_HOST" "ls $BACKUP_OUTPUT" | wc -l)
# Succeed if there are no remote backup files.
test $COUNT != 0 || return 0

# Copy remote backup files to local backup directory.
scp -i /key/id_ed25519 -o UserKnownHostsFile=/config/known_hosts "$BACKUP_USER@$BACKUP_HOST:$BACKUP_OUTPUT*" /opt/youtrack/backups/
