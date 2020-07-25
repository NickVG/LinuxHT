FROM centos:7
#RUN systemctl enable nginx --now
RUN yum update -y
RUN yum install -y redhat-lsb-core rpmbuild\
                   wget rpmdevtools epel-release \
                   rpm-build createrepo \
                   yum-utils percona-release\
                   headers packages metadata dbcache\
                   plugins expire-cache rpmdb all cc gcc; yum install -y nginx; yum clean all
RUN groupadd builder && useradd -g builder builder
RUN mkdir /tmp/nginx && cd /tmp/nginx
RUN wget https://nginx.org/packages/centos/7/SRPMS/nginx-1.14.1-1.el7_4.ngx.src.rpm
RUN rpm -i nginx-1.14.1-1.el7_4.ngx.src.rpm
RUN wget https://www.openssl.org/source/latest.tar.gz
RUN tar -xvf latest.tar.gz 2>&1 > /dev/null
RUN yes y|yum-builddep ~/rpmbuild/SPECS/nginx.spec
RUN sed -i 's/--with-debug/--with-openssl=\/tmp\/nginx\/openssl-1.1.1g/g' ~/rpmbuild/SPECS/nginx.spec
#RUN rpmbuild -bb ~/rpmbuild/SPECS/nginx.spec
#RUN yum localinstall -y ~/rpmbuild/RPMS/x86_64/nginx-1.14.1-1.el7_4.ngx.x86_64.rpm
#RUN systemctl start nginx
#RUN mkdir /usr/share/nginx/html/repo
#RUN cp ~/rpmbuild/RPMS/x86_64/nginx-1.14.1-1.el7_4.ngx.x86_64.rpm /usr/share/nginx/html/repo/
#RUN wget http://www.percona.com/downloads/percona-release/redhat/0.1-6/percona-release-0.1-6.noarch.rpm -O /usr/share/nginx/html/repo/percona-release-0.1-6.noarch.rpm
#RUN createrepo /usr/share/nginx/html/repo/
#RUN awk '/index  index.html index.htm/{print;print "        autoindex on;";next}1' /etc/nginx/conf.d/default.conf > tmp.tmp && mv tmp.tmp -f /etc/nginx/conf.d/default.conf
#RUN nginx -s reload
#RUN curl -a http://localhost/repo/
#cat >> /etc/yum.repos.d/otus.repo << EOF
#[otus]
#name=otus-linux
#baseurl=http://localhost/repo
#gpgcheck=0
#enabled=1
#EOF
#
EXPOSE 80 80
CMD ["/bin/bash"]
