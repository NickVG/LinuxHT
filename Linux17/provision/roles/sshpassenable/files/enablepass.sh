#!/bin/bash
mkdir -p ~root/.ssh; cp ~vagrant/.ssh/auth* ~root/.ssh
sed -i '65s/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
systemctl restart sshd

#sshpass -p "vagrant" ssh-copy-id -o StrictHostKeyChecking=no root@server
#sshpass -p "vagrant" ssh-copy-id -o StrictHostKeyChecking=no root@client
#sed -i '65s/PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
#systemctl restart sshd
#borg init -e none server:/var/backup/client
