#!/bin/sh
set -xe

while
	# Check if the backup host is reachable
	ping -c 3 $BACKUP_HOST || continue

	# Check if there are local backup files
	COUNT=$(ls /opt/youtrack/backups/ | wc -l)
	test $COUNT != 0 || continue

	# Copy local backup files to remote backup host
	scp -i /key/id_ed25519 -o UserKnownHostsFile=/config/known_hosts /opt/youtrack/backups/* "$BACKUP_USER@$BACKUP_HOST:$BACKUP_OUTPUT"
do sleep 3600; done
