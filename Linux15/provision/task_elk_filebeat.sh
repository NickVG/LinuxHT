#! /bin/bash

# указываем откуда будем принимать логи
sed -i  '/#host: "localhost:5601"/c  host: "localhost:5601"' /etc/filebeat/filebeat.yml
# Указываем где хоанятся логи NGINX
sed -i "0,/#var.paths:/{s/#var.paths:.*/var.paths: [\"\/var\/log\/rsyslog\/192.168.11.150\/nginx_access.log*\"]/}" /etc/filebeat/modules.d/nginx.yml.disabled
sed -i "0,/#var.paths:/{s/#var.paths:.*/var.paths: [\"\/var\/log\/rsyslog\/192.168.11.150\/nginx_error.log*\"]/}" /etc/filebeat/modules.d/nginx.yml
# Активируем модуль NGINX
filebeat modules enable nginx
sleep 20
filebeat setup
sleep 180
curl 192.168.11.150

