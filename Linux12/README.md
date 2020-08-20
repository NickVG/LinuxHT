# Описание

Стенд для практики к уроку «Пользователи и группы. Авторизация и аутентификация.»

Разворачивается сервер: `host1`. 

# Инструкция по применению
## Перед запуском
Требуется устнаовить git, ansible, virtualbox, vagrant
```bash
git clone https://github.com/NickVG/LinuxHT.git
cd LinuxHT/Linux12/
```
Все дальнейшие действия нужно делать из текущего каталога.

## Запускаем и работаем со стендом

Поднимем виртуальную машину: `vagrant up host1`
Настройка pam производится с помощью скрипта provision/task1.sh

Сначала настраивается виртуальная машина для работы с `ssh`

	#! /bin/bash
	mkdir -p ~root/.ssh; cp ~vagrant/.ssh/auth* ~root/.ssh
	sed -i '65s/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
	systemctl restart sshd

Добавляем группу `admin` и прописываем в неё пользователей `root` и `vagrant`

	groupadd admin
	useradd day
	usermod -aG admin root
	usermod -aG admin vagrant

Копируем скрипт в `/usr/local/bin/test_login.sh` и правим модуль файлы конфигураций `login` и `sshd` для работы с `pam_exec`

	cp /vagrant/scripts/test_login.sh /usr/local/bin/test_login.sh
	sudo sed -i '/nologin.so/a account    required     pam_exec.so /vagrant/scripts/test_login.sh' /etc/pam.d/login
	sudo sed -i '/nologin.so/a account    required     pam_exec.so /usr/local/bin/test_login.sh' /etc/pam.d/sshd


##Описание скрипта pam_exec

Сначала проверям входит ли пользователь в группу `admin`, если входит, то пропускаем

	#!/bin/bash

	if [ $(id -Gn ${PAM_USER}|grep -c "admin") != 0 ]; then
	  exit 0
	fi

Если пользователь не входит в группу `admin`, то проверяем день недели. Если не суббота или воскрсение, то пропускаем.

	if [ $(id -Gn ${PAM_USER}|grep -c "admin") = 0 ]; then
	if [ $(date +%a) != "Sun" -o $(date +%a) != "Sut" ]; then
	      exit 0
	    else
	      exit 1
	  fi
	fi

