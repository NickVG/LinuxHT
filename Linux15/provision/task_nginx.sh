#! /bin/bash

yum install yum-utils -y
cp /vagrant/provision/nginx.repo /etc/yum.repos.d/nginx.repo

# запуск удалённого аудита
#sed -i '/active = no/c active = yes'  /etc/audisp/plugins.d/au-remote.conf

#cat >> /etc/audit/rules.d/audit.rules << EOF
#-w /etc/nginx/nginx.conf -p wa -k nginx_conf
#-w /etc/nginx/conf.d -p wa -k nginx_conf
#EOF

#sed -i '/remote_server =/c remote_server = 192.168.11.151'  /etc/audisp/audisp-remote.conf
#sed -i '/port = /c port = 60'  /etc/audisp/audisp-remote.conf

#sed -i '/write_logs = yes/c write_logs = no' /etc/audit/auditd.conf
#sed -i '/log_format = RAW/c log_format = ENRICHED' /etc/audit/auditd.conf
#sed -i '/#### RULES ####/a *.crit action(type="omfwd" target="192.168.11.151" port="60" protocol="tcp"\n              action.resumeRetryCount="100"\n              queue.type="linkedList" queue.size="10000")' /etc/rsyslog.conf
cat /vagrant/provision/web/web-audisp-remote.conf > /etc/audisp/audisp-remote.conf
cat /vagrant/provision/web/web-auditd.conf > /etc/audit/auditd.conf
cat /vagrant/provision/web/web-audit.rules > /etc/audit/rules.d/audit.rules
cat /vagrant/provision/web/web-au-remote.conf > /etc/audisp/plugins.d/au-remote.conf
service auditd restart

cat >> /etc/rsyslog.conf << EOF
*.* @192.168.11.151
EOF

#service auditd restart


