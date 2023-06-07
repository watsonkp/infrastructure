#!/bin/sh

set -xe

ping -c 3 $BACKUP_HOST

while
	COUNT=$(ls /opt/youtrack/backups/ | wc -l)
	test $COUNT != 0 || continue
	scp -i /key/id_ed25519 -o UserKnownHostsFile=/config/known_hosts /opt/youtrack/backups/* "$BACKUP_USER@$BACKUP_HOST:$BACKUP_OUTPUT"
do sleep 3600; done
