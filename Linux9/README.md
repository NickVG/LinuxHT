Для данного задания нам понадобятся следующие установленные пакеты:

        [root@packages ~]# yum install -y \
        redhat-lsb-core \
        wget \
        rpmdevtools \
        rpm-build \
        createrepo \
        yum-utils

Для примера возьмём пакет NGINX и соберем его с поддержкой openssl

Загрузим SRPM пакет NGINX длā дальнейшей работы над ним:

        wget https://nginx.org/packages/centos/7/SRPMS/nginx-1.14.1-1.el7_4.ngx.src.rpm

При установке такого пакета в домашней директории создается древо каталогов для сборки:

        rpm -i nginx-1.14.1-1.el7_4.ngx.src.rpm

Также нужно скачать и разархивировать последний исходники для openssl - он потребуется при сборке

        wget https://www.openssl.org/source/latest.tar.gz
        tar -xvf latest.tar.gz

Заранее поставим все зависимости чтобы в процессе сборки не бýло ошибок

        yum-builddep rpmbuild/SPECS/nginx.spec

Ну и собственно поправить сам spec файл чтобы NGINX собирался с необходимыми нам опциями:

	sed -i 's/--with-debug/--with-openssl=\/tmp\/nginx\/openssl-1.1.1g/g' ~/rpmbuild/SPECS/nginx.spec

Собираем приложение

	rpmbuild -bb ~/rpmbuild/SPECS/nginx.spec

Устанавливаем зависимости

	yum localinstall -y ~/rpmbuild/RPMS/x86_64/nginx-1.14.1-1.el7_4.ngx.x86_64.rpm

Создаём папку для репозитория и копируем туда пакеты

	mkdir /usr/share/nginx/html/repo
	cp ~/rpmbuild/RPMS/x86_64/nginx-1.14.1-1.el7_4.ngx.x86_64.rpm /usr/share/nginx/html/repo/
	wget http://www.percona.com/downloads/percona-release/redhat/0.1-6/percona-release-0.1-6.noarch.rpm -O /usr/share/nginx/html/repo/percona-release-0.1-6.noarch.rpm

Создаём репозиотрий

	createrepo /usr/share/nginx/html/repo/
	cat >> /etc/yum.repos.d/otus.repo << EOF
	[otus]
	name=otus-linux
	baseurl=http://localhost/repo
	gpgcheck=0
	enabled=1
	EOF

yum install percona-release -y


