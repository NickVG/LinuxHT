#!/bin/bash

export BORG_PASSPHRASE='password'
borg init --encryption=repokey-blake2 server:/var/backup/$(hostname)
