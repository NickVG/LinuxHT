#! /bin/bash
yum install sendmail -y
yum install mutt -y
cp /vagrant/files/script-1.sh /etc/cron.hourly/
chmod +x /etc/cron.hourly/script-1.sh 
