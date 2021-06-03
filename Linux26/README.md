# ДЗ Dynamic WEB

ansible-galaxy collection install community.mysql
ansible-galaxy collection install ansible.posix


nginx config
openssl req -newkey rsa:2048 -nodes -keyout /etc/nginx/key.pem -x509 -days 365 -out /etc/nginx/certificate.pem

#semanage fcontext -a -t cert_t '/vagrant/certificate.pem'
#restorecon -v '/vagrant/certificate.pem'
#semanage fcontext -a -t cert_t '/vagrant/key.pem'
#restorecon -v '/vagrant/key.pem'

sudo systemctl stop firewalld

chown -R root:nginx /var/lib/php
selinux

chown -R nginx:  wordpress
selinux

#sudo chown -R nginx:nginx /usr/share/nginx/html/wordpress
#sudo chmod -R 755 /usr/share/nginx/html/wordpress

systemctl restart nginx
