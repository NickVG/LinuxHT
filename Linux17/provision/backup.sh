#!/bin/bash
# Client and server name

BACKUP_USER=root
BACKUP_HOST=server
export BORG_PASSPHRASE='password'

TYPEOFBACKUP=etc

REPOSITORY=$BACKUP_USER@$BACKUP_HOST:/var/backup/$(hostname)


borg create -v --stats                    \
     $REPOSITORY::'{now:%Y-%m-%d-%H-%M}'  \
     /etc

borg prune -v --show-rc --list $REPOSITORY \
     --keep-within=92d --keep-monthly=12
