#!/bin/bash 
echo "PID    TTY   STAT   TIME    COMMAND" 

for i in $(ls /proc/ | grep -x -E '[[:digit:]]+') 
	do 
	awk '{printf $1 "      "  $3 "     "  $7 "     " $14+$15+$16+$17 "    " }' /proc/$i/stat 2>/dev/null 
		if [[ $(awk '{print length($0)}' /proc/$i/cmdline 2>/dev/null) > 0 ]] 
		then 
		awk '{printf $1}' /proc/$i/cmdline 2>/dev/null 
		else 
		awk '{printf  $2 " "}' /proc/$i/stat 2>/dev/null 
		fi 
	echo 
done 
