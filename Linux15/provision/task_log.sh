#! /bin/sh

#Добавляем директорию для хранения логов
mkdir -p /var/log/rsyslog
# Настраиваем selinux
semanage fcontext -a -t var_log_t '/var/log/rsyslog(/.*)?'
restorecon -Rv /var/log/rsyslog
#Настраиваем firewall
firewall-cmd --permanent --add-port=514/udp; firewall-cmd --permanent --add-port=514/tcp
firewall-cmd --permanent --add-port=60/udp; firewall-cmd --permanent --add-port=60/tcp; firewall-cmd --reload

#Настраиваем auditd и rsyslog на приём журналов
cat /vagrant/provision/log/log-auditd.conf > /etc/audit/auditd.conf
cat /vagrant/provision/log/log-rsyslog.conf > /etc/rsyslog.conf

#cat >> /etc/rsyslog.conf << EOF
# Remote logging
#\$template HostIPtemp,"/var/log/rsyslog/%FROMHOST-IP%.log"
#if ($fromhost-ip != "127.0.0.1" ) then ?HostIPtemp
#& stop
#EOF

#sed -i '/remote_server =/c remote_server = 192.168.11.150'  /etc/audisp/audisp-remote.conf

#cat >> /etc/rsyslog.conf << EOF
#\$ModLoad imudp
#\$UDPServerRun 514
#\$ModLoad imtcp
#\$InputTCPServerRun 514
#EOF

#sed -i '/##tcp_listen_port/c tcp_listen_port = 60\' /etc/audit/auditd.conf

# после настройки auditd и rsyslog рестартуем сервисы
systemctl restart rsyslog
service auditd restart
systemctl daemon-reload

