# Домашнее задание по BASH

Написан скрипт

Сначала проводим проверку на то, существует ли lock

  #!/bin/bash

  FILECOUNTER=/vagrant/files/counter
  source $FILECOUNTER
  LINESCOUNTER=$(awk 'END {print NR}' $SOURCEFILE)

  if [ -e ${LOCKFILE} ] && kill -0 `cat ${LOCKFILE}`; then
      echo "Lock file ${LOCKFILE} exists. Script is already running."
      exit
  fi

Создаём лок для защиты от мультизапуска, в лок записываем PID, лок удаляется при получении сигнала на завершение работы скрипта

  #make sure the lockfile is removed when we exit and then claim it
  trap "rm -f ${LOCKFILE}; exit" INT TERM EXIT
  echo $$ > ${LOCKFILE}

Проверяем существует ли файл для формированя отчёта, если он отсутствует - создаём его.

  if [ ! -f ${MAILFILE} ]; then touch /home/$USER/mail.txt; fi

Создаём функцию для чтения определённых полей

  #функция для считываня полей
  #function for fields reading
  readfile(){
          sed -n $1,$2p $3|cut -d" " --fields=$4
  }

Создаём функцию для формирования отчёта
  printstr(){
          echo "= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =" > ${MAILFILE}
          echo "Список ошибок и их типы за следующий промежуток времени " >> ${MAILFILE}
          echo $(readfile ${STARTLINE} ${STARTLINE} ${SOURCEFILE} 4,5 1) ' --- ' $(sed -n ${LINESCOUNTER}p ${SOURCEFILE} |cut -d" " --fields=4,5 1) >> ${MAILFILE}
          echo "= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =" >> ${MAILFILE}
          readfile ${STARTLINE} ${LINESCOUNTER} ${SOURCEFILE} 9|grep [45].. |  sort|uniq -c |sort -nr|head -n 10 >> ${MAILFILE}
          echo "= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =" >> ${MAILFILE}
  
  #TOP Запрашиваемых адресов
          echo "= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =" >> $MAILFILE
          echo "TOP 10 запрашиваемых адресов (с наибольшим кол-вом запросов) с указанием кол-ва запросов c момента последнего запуска скрипта" >> $MAILFILE
          echo "= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =" >> ${MAILFILE}
          readfile ${STARTLINE} ${LINESCOUNTER} ${SOURCEFILE} 11| sort|uniq -c |sort -nr|head -n 10 >> ${MAILFILE}
          echo "= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =" >> ${MAILFILE}
  
  #TOP Запросов 
          echo "= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =" >> ${MAILFILE}
          echo "X IP адресов (с наибольшим кол-вом запросов) с указанием кол-ва запросов c момента последнего запуска скрипта" >> ${MAILFILE}
          echo "= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =" >> ${MAILFILE}
          readfile ${STARTLINE} ${LINESCOUNTER} ${SOURCEFILE} 1| sort|uniq -c |sort -nr|head -n 10 >> ${MAILFILE}
          echo "= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =" >> ${MAILFILE}
     }
  printstr

Назначаем начало строки для следующего запуска скрипта

  sed -i "s/.*STARTLINE=${STARTLINE}*/STARTLINE=$(expr ${LINESCOUNTER} + 1)/g" $FILECOUNTER

Отправляем письмо

  echo "" | mutt -s "report at $(date)" $address -i "body.txt" -a "mail.txt"
