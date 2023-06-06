#!/bin/sh

set -xe

ping -c 3 $BACKUP_HOST

while true
do
	scp -i /key/id_ed25519 -o UserKnownHostsFile=/config/known_hosts /opt/youtrack/backups/* $BACKUP_USER@$BACKUP_HOST:$BACKUP_OUTPUT
	sleep 60
done
