#! /bin/bash

yum install -y redhat-lsb-core wget rpmdevtools rpm-build createrepo yum-utils
mkdir /tmp/nginx
cd /tmp/nginx
 wget https://nginx.org/packages/centos/7/SRPMS/nginx-1.14.1-1.el7_4.ngx.src.rpm

rpm -i nginx-1.14.1-1.el7_4.ngx.src.rpm
sleep 60
wget https://www.openssl.org/source/latest.tar.gz
tar -xvf latest.tar.gz

yum-builddep ~/rpmbuild/SPECS/nginx.spec
#wget https://gist.github.com/lalbrekht/6c4a989758fccf903729fc55531d3a50

Правим spec-file

rpmbuild -bb ~/rpmbuild/SPECS/nginx.spec
yum localinstall -y ~/rpmbuild/RPMS/x86_64/nginx-1.14.1-1.el7_4.ngx.x86_64.rpm

systemctl start nginx
#Создадим там каталог repo:
mkdir /usr/share/nginx/html/repo
cp ~/rpmbuild/RPMS/x86_64/nginx-1.14.1-1.el7_4.ngx.x86_64.rpm /usr/share/nginx/html/repo/

wget http://www.percona.com/downloads/percona-release/redhat/0.1-6/percona-release-0.1-6.noarch.rpm -O /usr/share/nginx/html/repo/percona-release-0.1-6.noarch.rpm

createrepo /usr/share/nginx/html/repo/

#В location / в файле /etc/nginx/conf.d/default.conf добавим директиву autoindex on

nginx -s reload
curl -a http://localhost/repo/

cat >> /etc/yum.repos.d/otus.repo << EOF
[otus]
name=otus-linux
baseurl=http://localhost/repo
gpgcheck=0
enabled=1
EOF

yum install percona-release -y


