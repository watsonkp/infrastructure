#!/bin/sh
set -xe

# Check if the backup host is reachable
ping -c 3 $BACKUP_HOST

# Dump PostgreSQL database to a file.
# Credentials and configuration are pulled from environment variables.
BACKUP_FILE="operating_manual-"$(date -u +%Y-%m-%d-%H-%M-%S)".sql"
pg_dump > $BACKUP_FILE

# Copy local backup files to remote backup host
scp -i /key/id_ed25519 -o UserKnownHostsFile=/config/known_hosts $BACKUP_FILE "$BACKUP_USER@$BACKUP_HOST:$BACKUP_OUTPUT"
