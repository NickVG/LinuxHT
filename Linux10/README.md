Написана реализация ps ax через bash. Срипт ниже

Выводим заголовки

	#!/bin/bash 
	echo "PID    TTY   STAT   TIME    COMMAND" 

Получаем список всех процессов и для каждого найденного процесса ...

	for i in $(ls /proc/ | grep -x -E '[[:digit:]]+')
        	do

... выгрузку данных из /proc

        awk '{printf $1 "      "  $3 "     "  $7 "     " $14+$15+$16+$17 "    " }' /proc/$i/stat 2>/dev/null

Проверяем есть ли что-то в cmdline, если есть, то выводим содержимое, если нет, то берём данные из stat

                if [[ $(awk '{print length($0)}' /proc/$i/cmdline 2>/dev/null) > 0 ]]
                then
                awk '{printf $1}' /proc/$i/cmdline 2>/dev/null
                else
                awk '{printf  $2 " "}' /proc/$i/stat 2>/dev/null
                fi
        echo 
done
