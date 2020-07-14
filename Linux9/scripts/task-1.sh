#! /bin/bash

yum install -y redhat-lsb-core wget rpmdevtools rpm-build createrepo yum-utils

cd /tmp wget https://nginx.org/packages/centos/7/SRPMS/nginx-1.14.1-1.el7_4.ngx.src.rpm

rpm -i nginx-1.14.1-1.el7_4.ngx.src.rpm

wget https://www.openssl.org/source/latest.tar.gz
tar -xvf latest.tar.gz

yum-builddep rpmbuild/SPECS/nginx.spec
wget https://gist.github.com/lalbrekht/6c4a989758fccf903729fc55531d3a50

