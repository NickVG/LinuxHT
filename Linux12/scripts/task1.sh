#! /bin/bash

groupadd admin
useradd day
usermod -aG day admin
echo "*;*;!admin;!Wd" >> /etc/security/time.conf

