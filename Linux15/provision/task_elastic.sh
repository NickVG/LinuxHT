#! /bin/bash

rpm --import https://packages.elastic.co/GPG-KEY-elasticsearch

cat > /etc/yum.repos.d/elastic.repo <<EOF 
[elastic-7.x]
name=Elastic repository for 7.x packages
baseurl=https://artifacts.elastic.co/packages/7.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
EOF

mkdir -p /var/log/rsyslog
semanage fcontext -a -t var_log_t '/var/log/rsyslog(/.*)?'
restorecon -Rv /var/log/rsyslog
firewall-cmd --permanent --add-port=514/udp; sudo firewall-cmd --permanent --add-port=514/tcp

cat /vagrant/provision/log/log-rsyslog.conf > /etc/rsyslog.conf
systemctl restart rsyslog
systemctl daemon-reload

