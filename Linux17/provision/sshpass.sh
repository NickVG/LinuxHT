#!/bin/bash

sshpass -p "vagrant" ssh-copy-id -o StrictHostKeyChecking=no root@server
sshpass -p "vagrant" ssh-copy-id -o StrictHostKeyChecking=no root@client
