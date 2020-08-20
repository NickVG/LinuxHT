#! /bin/bash

mkdir -p ~root/.ssh; cp ~vagrant/.ssh/auth* ~root/.ssh
sed -i '65s/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
systemctl restart sshd

groupadd admin
useradd day
usermod -aG admin root
usermod -aG admin vagrant
cp /vagrant/scripts/test_login.sh /usr/local/bin/test_login.sh
#echo "*;*;!admin;!Wd" >> /etc/security/time.conf
sudo sed -i '/nologin.so/a account    required     pam_exec.so /vagrant/scripts/test_login.sh' /etc/pam.d/login
sudo sed -i '/nologin.so/a account    required     pam_exec.so /usr/local/bin/test_login.sh' /etc/pam.d/sshd
#echo "account    required     pam_exec.so /vagrant/scripts/test_login.sh" >> /etc/pam.d/login
#echo "account    required     pam_exec.so /vagrant/scripts/test_login.sh" >> /etc/pam.d/sshd

