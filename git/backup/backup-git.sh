#!/bin/sh

set -xe

ping -c 3 $BACKUP_HOST

repositories=$(ssh -i /key/id_ed25519 -o UserKnownHostsFile=/config/known_hosts git@git.infrastructure.svc.cluster.local -p $GIT_SERVICE_PORT_SSH ls)
for repository in $repositories; do
	git clone --mirror --quiet git://git.infrastructure.svc.cluster.local:$GIT_SERVICE_PORT_GIT/$repository
	cd $repository.git
	git bundle create --quiet /data/$repository.bundle --all
	cd ..
	rm -rf $repository.git
done 

BACKUP_FILE="git-"$(date -u +%Y-%m-%d-%H-%M-%S)".tar.gz"
tar czf $BACKUP_FILE /data
scp -i /key/id_ed25519 -o UserKnownHostsFile=/config/known_hosts $BACKUP_FILE $BACKUP_USER@$BACKUP_HOST:$BACKUP_OUTPUT
