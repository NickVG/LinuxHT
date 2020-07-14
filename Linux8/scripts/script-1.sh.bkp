#!/bin/bash

LOCKFILE=/tmp/lock.lck
SOURCEFILE=/home/$USER/access.log
MAILFILE=/home/$USER/mail.txt
FILECOUNTER=/home/$USER/counter
LINESCOUNTER=$(wc -l $SOURCEFILE | cut -d" " -f1)
# SED: $= (10.2 c.); awk 'END {print NR}' "httpd.spec"
source $FILECOUNTER
echo $STARTLINE

if [ -e ${LOCKFILE} ] && kill -0 `cat ${LOCKFILE}`; then
    echo "Script is already running"
    exit
fi

if [ ! -f ${MAILFILE} ]; then touch /home/$USER/mail.txt; fi

# make sure the lockfile is removed when we exit and then claim it
trap "rm -f ${LOCKFILE}; exit" INT TERM EXIT
echo $$ > ${LOCKFILE}

# do stuff
# ERRORS
readfile(){
        sed -n ${STARTLINE},${LINESCOUNTER}p ${SOURCEFILE}
}
printstr(){
        echo "= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =" > ${MAILFILE}
        echo "Список ошибок и их типы за следующий промежуток времени " >> ${MAILFILE}
        echo $(sed -n ${STARTLINE}p ${SOURCEFILE} |cut -d" " --fields=4,5) ' --- ' $(sed -n ${LINESCOUNTER}p ${SOURCEFILE} |cut -d" " --fields=4,5) >> ${MAILFILE}
        echo "= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =" >> ${MAILFILE}
        readfile |cut -d" " -f9|grep [45].. |  sort|uniq -c |sort -nr|head -n 10 >> ${MAILFILE}
        echo "= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =" >> ${MAILFILE}
#        echo -e '\n' >> ${MAILFILE}
        sleep 1

#TOP
        echo "= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =" >> $MAILFILE
        echo "TOP 10 запрашиваемых адресов (с наибольшим кол-вом запросов) с указанием кол-ва запросов c момента последнего запуска скрипта" >> $MAILFILE
        echo "= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =" >> ${MAILFILE}
        readfile |cut -d" " -f11| sort|uniq -c |sort -nr|head -n 10 >> ${MAILFILE}
        echo "= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =" >> ${MAILFILE}
#        echo -e '\n' >> ${MAILFILE}

#TOP
        echo "= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =" >> ${MAILFILE}
        echo "X IP адресов (с наибольшим кол-вом запросов) с указанием кол-ва запросов c момента последнего запуска скрипта" >> ${MAILFILE}
        echo "= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =" >> ${MAILFILE}
        readfile |cut -d" " -f1| sort|uniq -c |sort -nr|head -n 10 >> ${MAILFILE}
        echo "= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =" >> ${MAILFILE}
   }
printstr

sed -i "s/.*STARTLINE=${STARTLINE}*/STARTLINE=$(expr ${LINESCOUNTER} + 1)/g" $FILECOUNTER
echo "" | mutt -s "report at $(date)" nick@nick-VirtualBox -i "body.txt" -a "mail.txt"

#echo "STARTLINE=$(expr $LINESCOUNTER + 1)" > $FILECOUNTER
#sed -n ${STARTLINE},${LINESCOUNTER}p ${SOURCEFILE} |cut -d" " -f9|grep [45].. |  sort|uniq -c |sort -nr|head -n 10
