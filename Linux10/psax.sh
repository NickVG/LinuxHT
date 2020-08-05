#!/bin/bash

#выводим заголовок
printf  '%7s %-10s %-10s %-7s %-10s\n' "PID" "TTY" "STAT" "TIME" "COMMAND"
#Объявляем переменные для записи значений требуемых параметров
TTY=""
STAT=""
COMMAND=""
#Собираем список PID и начинаем сбор информации проверяя, что процесс ещё жив.
        for i in $(ls /proc/ | grep -x -E '[[:digit:]]+'|sort -n)
        do
        if [[ -e /proc/$i ]]
        then
#проверям tty
                TTY=$(ls -l /proc/$i/fd | awk '{printf $11 "\n"}'|uniq|grep "tty\|pts"|head -n 1)
                if [[ -z $TTY ]]
                then
                        TTY="?"
                fi
#Собираем данные по состоянию процессы
                STAT=$(awk '{printf $3}' /proc/$i/stat)
                if [[ $(cat /proc/$i/stat|cut -d" " -f19) > 0  ]]
                then
                        STAT=$STAT$(echo N)
                fi
                if [[ $(cat /proc/$i/stat|cut -d" " -f19) < 0  ]]
                then
                        STAT=$STAT$(echo "<")
                fi
                if [[ -n $(cat  /proc/$i/smaps |grep VmFlags|grep lo) ]]
		then
                        STAT=$STAT$(echo l)
                fi
                if [[ $(awk '{printf $6}' /proc/$i/stat) == $(awk '{printf $1}' /proc/$i/stat) ]]
                then
                        STAT=$STAT$(echo s)
                fi
                if [[ $(awk '{printf $8 "\n"}' /proc/$i/stat) != -1  ]]
                then STAT=$STAT$(echo "+")
                fi
#расчитываем процессорное время
                TIME=$(awk '{printf ($14+$15+$16+$17)/100}' /proc/$i/stat)
#Выводим данные о "команде" запустивщей процесс
               if [[ $(awk '{print length($0)}' /proc/$i/cmdline 2>/dev/null) > 0 ]]
               then
                       COMMAND=$(tr -d '\0' < /proc/$i/cmdline)
#                       COMMAND=$(awk '{printf $1"\n"}' /proc/$i/cmdline 2>/dev/null)
               else
			COMMAND=$(awk '{printf  $2 " "}' /proc/$i/stat)
               fi
        fi
#выводим результат на экран
        printf  '%7s %-10s %-10s %-7s %-10s\n' "$i" "$TTY" "$STAT" "$TIME" "$COMMAND"
        done
