# ДЗ по Monitoring

## Основная часть.
### *1. Настроить аудит на изменение конфигов nginx.*

Прописываем правила аудита:

	cat >> /etc/audit/rules.d/audit.rules << EOF
	-w /etc/nginx/nginx.conf -p wa -k nginx_config
	-w /etc/nginx/conf.d -p wa -k nginx_config
	EOF

Для того, чтобы правила применились необходимо перезапустить службу аудита

	service auditd restart

Проверить работоспособность возможно изменив конфигурационные файлы и выполнив команду:

	ausearch -k nginx_conf

### *2. Отправлять все аудит логи на сервер log.*

Для того, чтобы логи аудита писались на удалённый сервер необходимо установить пакет `audispd-plugins` и на клинет, и на сервер принимающий логи.
На клиенте web:

	echo 'настраиваем удаёлнное логирование'
	sed -i '/remote_server =/c remote_server = 192.168.11.150'  /etc/audisp/audisp-remote.conf
	sed -i '/port = /c port = 60'  /etc/audisp/audisp-remote.conf
	echo 'Отключаем хранение логов локально'
	sed -i '/write_logs = yes/c write_logs = no' /etc/audit/auditd.conf
	echo 'Меняем формат логов'
	sed -i '/log_format = RAW/c log_format = ENRICHED' /etc/audit/auditd.conf
        echo 'включаем удалённое логирование'
	sed -i '/active = no/c active = yes'  /etc/audisp/plugins.d/au-remote.conf
        service auditd restart

На сервере log:

	echo 'Включаем приём логов'
	cat >> /etc/rsyslog.conf << EOF
	\$ModLoad imudp
	\$UDPServerRun 514
	\$ModLoad imtcp
	\$InputTCPServerRun 514
	EOF

Для проверки конфигурации необходимо изменить настройки nginx и выполнить

	ausearch -i -k nginx_conf

### *3. Критичные логи оставляем на web и отправляем на log.*

В файлы `/etc/audit/auditd.conf` и `/etc/rsyslog.conf` вносим соответствуюшие изменения

	sed -i '/##tcp_listen_port/c tcp_listen_port = 60\' /etc/audit/auditd.conf

	

В раздел RULES серверов log и elk добавляем следующее для отправки всех критических событий на сервера хранения журналов:
	
	cat >> /etc/rsyslog.conf << EOF
	$ModLoad imudp
	$UDPServerRun 514
	$ModLoad imtcp
	$InputTCPServerRun 514

	$template Incoming-logs,"/var/log/rsyslog/192.168.11.150/%PROGRAMNAME%.log"
	if $fromhost-ip == "192.168.11.150"  then -?Incoming-logs
	& stop
        EOF



### *4. Все логи нжинкса отправляем на log(а заодно и на ELK), критичные также оставляем на web.*

Добавляем в конфиг NGINX 

	sed -i  '/error_log /c error_log /var/log/nginx/error.log crit;\nerror_log syslog:server=192.168.11.151:514,tag=nginx_error notice;\nerror_log syslog:server=192.168.11.152:514,tag=nginx_error notice;' /etc/nginx/nginx.conf
	sed -i '/access_log /c access_log syslog:server=192.168.11.151:514,tag=nginx_access main;\naccess_log syslog:server=192.168.11.152:514,tag=nginx_access main;' /etc/nginx/nginx.conf

## **ELK**

### *1. Логи nginx отправляем на elk(настройка аналогична настройкам для сервера log).*
### *2. Установим и настроим ELK*

Добавим репозиторий.

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

### *3. Установка ELK и настройка elastic:*

	[root@elk ~]# yum -y install elasticsearch kibana filebeat
	[root@elk ~]# echo network.host: 0.0.0.0 >> /etc/elasticsearch/elasticsearch.yml
        [root@elk ~]# echo http.port: 9200 >> /etc/elasticsearch/elasticsearch.yml
        [root@elk ~]# echo discovery.type: single-node >> /etc/elasticsearch/elasticsearch.yml
        [root@elk ~]# systemctl enable elasticsearch.service --now
	
### *4. Настройка kibana:*

	[root@elk ~]# sed -i  '/server.host/c server.host: "0.0.0.0"' /etc/kibana/kibana.yml
        [root@elk ~]# systemctl enable kibana.service --now
	
### *5. Настройка filebeat:*

	[root@elk ~]# sed -i  '/#host: "localhost:5601"/c\  host: "localhost:5601"' /etc/filebeat/filebeat.yml
        [root@elk ~]# sed -i "0,/#var.paths:/{s/#var.paths:.*/var.paths: [\"\/var\/log\/rsyslog\/192.168.11.150\/nginx_access.log*\"]/}" /etc/filebeat/modules.d/nginx.yml.disabled
        [root@elk ~]# sed -i "1,/#var.paths:/{s/#var.paths:.*/var.paths: [\"\/var\/log\/rsyslog\/192.168.11.150\/nginx_error.log*\"]/}" /etc/filebeat/modules.d/nginx.yml.disabled
        [root@elk ~]# filebeat modules enable nginx
        [root@elk ~]# filebeat setup
        [root@elk ~]# systemctl enable filebeat.service --now


