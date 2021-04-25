#! /bin/bash

### Настройка отправки логов на сервера LOG и ELK
sed -i  '/error_log /c error_log /var/log/nginx/error.log crit;\nerror_log syslog:server=192.168.11.151:514,tag=nginx_error notice;\nerror_log syslog:server=192.168.11.152:514,tag=nginx_error notice;' /etc/nginx/nginx.conf
sed -i '/access_log /c access_log syslog:server=192.168.11.151:514,tag=nginx_access main;\naccess_log syslog:server=192.168.11.152:514,tag=nginx_access main;' /etc/nginx/nginx.conf

service auditd restart
