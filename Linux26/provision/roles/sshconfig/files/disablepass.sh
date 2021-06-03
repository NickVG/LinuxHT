#!/bin/bash
sshpass -p "vagrant" ssh-copy-id -f -o StrictHostKeyChecking=no root@server
sshpass -p "vagrant" ssh-copy-id -f -o StrictHostKeyChecking=no root@client
systemctl restart sshd
#borg init -e none server:/var/backup/client
