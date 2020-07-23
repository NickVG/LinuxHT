#! /bin/bash

yum install -y redhat-lsb-core wget rpmdevtools rpm-build createrepo yum-utils
groupadd builder
useradd -g builder builder
mkdir /tmp/nginx && cd /tmp/nginx
wget https://nginx.org/packages/centos/7/SRPMS/nginx-1.14.1-1.el7_4.ngx.src.rpm
rpm -i nginx-1.14.1-1.el7_4.ngx.src.rpm
wget https://www.openssl.org/source/latest.tar.gz
echo "------------------------------------------"
tar -xvf latest.tar.gz 2>&1 > /dev/null
echo "------------------------------------------"
yes y|yum-builddep ~/rpmbuild/SPECS/nginx.spec
sleep 1
echo "-----------------------------------------------------------------------------------------------------------------"
sed -i 's/--with-debug/--with-openssl=\/tmp\/nginx\/openssl-1.1.1g/g' ~/rpmbuild/SPECS/nginx.spec
sleep 1
echo "-----------------------------------------------------------------------------------------------------------------"
#Правим spec-file
rpmbuild -bb ~/rpmbuild/SPECS/nginx.spec
sleep 1
echo "------------------------------------------"
yum localinstall -y ~/rpmbuild/RPMS/x86_64/nginx-1.14.1-1.el7_4.ngx.x86_64.rpm
sleep 1
echo "------------------------------------------"
systemctl start nginx
sleep 1
echo "------------------------------------------"
#Создадим там каталог repo:
mkdir /usr/share/nginx/html/repo
sleep 1
echo "------------------------------------------"
cp ~/rpmbuild/RPMS/x86_64/nginx-1.14.1-1.el7_4.ngx.x86_64.rpm /usr/share/nginx/html/repo/
sleep 1
echo "------------------------------------------"
wget http://www.percona.com/downloads/percona-release/redhat/0.1-6/percona-release-0.1-6.noarch.rpm -O /usr/share/nginx/html/repo/percona-release-0.1-6.noarch.rpm
sleep 1
echo "------------------------------------------"
createrepo /usr/share/nginx/html/repo/
sleep 1
echo "------------------------------------------"
#В location / в файле /etc/nginx/conf.d/default.conf добавим директиву autoindex on
awk '/index  index.html index.htm/{print;print "        autoindex on;";next}1' /etc/nginx/conf.d/default.conf > tmp.tmp && mv tmp.tmp -f /etc/nginx/conf.d/default.conf
nginx -s reload
echo "------------------------------------------"
curl -a http://localhost/repo/
sleep 2
echo "------------------------------------------"
cat >> /etc/yum.repos.d/otus.repo << EOF
[otus]
name=otus-linux
baseurl=http://localhost/repo
gpgcheck=0
enabled=1
EOF
yum install percona-release -y
