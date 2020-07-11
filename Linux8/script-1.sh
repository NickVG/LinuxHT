#!/bin/bash 
  
LOCKFILE=/tmp/lock.lck

if [ -e ${LOCKFILE} ] && kill -0 `cat ${LOCKFILE}`; then
    echo "Scrip is already running" 
    exit
fi

# make sure the lockfile is removed when we exit and then claim it 

trap "rm -f ${LOCKFILE}; exit" INT TERM EXIT
echo $$ > ${LOCKFILE}

# do stuff 


more /home/nick/access-4560-644067.log |cut -d" " -f9|grep [45].. |  sort|uniq -c |sort -nr|head -n 10 > /home/nick/mail.txt
echo '\\n' >> /home/nick/mail.txt
sleep 10
more /home/nick/access-4560-644067.log |cut -d" " -f11| sort|uniq -c |sort -nr|head -n 10 >> /home/nick/mail.txt
echo '\\n' >> /home/nick/mail.txt
cat /home/nick/access-4560-644067.log |cut -d" " -f1| sort|uniq -c |sort -nr|head -n 10 >> /home/nick/mail.txt
