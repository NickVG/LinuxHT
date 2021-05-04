#ДЗ по Backup

###Реализован стенд по теме резервное копирование:

Для запуска стеда необходимо выполнить:

	ansible-galaxy collection install community.general
	ansible-galaxy collection install ansible.posix
	ansible-galaxy collection install community.crypto

	vagrant up --no-provision; vagrant provision --provision-with sshpassw; vagrant provision --provision-with sshkey; vagrant provision --provision-with BORG

###Выполнение домашнего задания

Настроить стенд Vagrant с двумя виртуальными машинами: server и client

Настроить удаленный бекап каталога /etc c сервера client при помощи borgbackup. Резервные копии должны соответствовать следующим критериям:

* Директория для резервных копий /var/backup. Это должна быть отдельная точка монтирования. В данном случае для демонстрации размер не принципиален, достаточно будет и 2GB.

	server.vm.provider "virtualbox" do |v|
		unless File.exist?(disk)
		v.customize ['createhd', '--filename', disk, '--variant', 'Fixed', '--size', 2 * 1024]
		end
	
	playbook для создания файловой системы и монтирования находится здесь: provision/roles/borg/tasks/mount.yml

* Репозиторий дле резервных копий должен быть зашифрован ключом или паролем - на ваше усмотрение

	Репозиторий зашифрован паролем
	script "provision/roles/borgclient/files/repoinit.sh"
	...
	borg init --encryption=repokey-blake2 server:/var/backup/$(hostname)
	...

* Имя бекапа должно содержать информацию о времени снятия бекапа
	script "provision/backup.sh"
	...
	borg create -v --stats $REPOSITORY::'{now:%Y-%m-%d-%H-%M}' /etc
	...

* Глубина бекапа должна быть год, хранить можно по последней копии на конец месяца, кроме последних трех. Последние три месяца должны содержать копии на каждый день. Т.е. должна быть правильно настроена политика удаления старых бэкапов

	script "provision/backup.sh"
        ...
	borg prune -v --show-rc --list $REPOSITORY --keep-within=92d --keep-monthly=12
	...
	
* Резервная копия снимается каждые 5 минут. Такой частый запуск в целях демонстрации.
	
	cat backup.timer
	[Unit]
	Description=Execute backup every 5 min

	[Timer]
	#Run 300 sec after boot
	OnBootSec=300
	#Run every 300 sec
	OnUnitInactiveSec=300
	Unit=backup.service

	[Install]
	WantedBy=multi-user.target
	
* Написан скрипт для снятия резервных копий. Скрипт запускается из соответствующей Cron джобы, либо systemd timer-а - на ваше усмотрение.

	script находится здесь: "provision/backup.sh"
	запускается с помощью systemd


