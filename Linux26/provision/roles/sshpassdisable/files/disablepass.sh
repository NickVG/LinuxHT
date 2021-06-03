#!/bin/bash
sed -i '65s/PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
systemctl restart sshd
#borg init -e none server:/var/backup/client
