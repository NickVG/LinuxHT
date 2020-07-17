1) Создать свой RPM пакет 
2) Создать свой репозиторий и разместить там ранее собранный RPM

Для данного задания нам понадобятся следующие установленные пакеты:

	[root@packages ~]# yum install -y \
	redhat-lsb-core \
	wget \
	rpmdevtools \
	rpm-build \
	createrepo \
	yum-utils

Длā примера возþмем пакет NGINX и соберем его с поддержкой openssl
● Загрузим SRPM пакет NGINX длā далþнейшей работý над ним:
[root@packages ~]# wget
https://nginx.org/packages/centos/7/SRPMS/nginx-1.14.1-1.el7_4.ngx.src.rpm
● При установке такого пакета в домашней директории создаетсā древо каталогов длā
сборки:
[root@packages ~]# rpm -i nginx-1.14.1-1.el7_4.ngx.src.rpm

Также нужно скачатþ и разархивироватþ последний исходники длā openssl - он
потребуетсā при сборке
[root@packages ~]# wget https://www.openssl.org/source/latest.tar.gz
[root@packages ~]# tar -xvf latest.tar.gz
● Заранее поставим все зависимости чтобý в процессе сборки не бýло ошибок
[root@packages ~]# yum-builddep rpmbuild/SPECS/nginx.spec

Ну и собственно поправитþ сам spec файл чтобý NGINX собиралсā с необходимýми нам опциāми:

