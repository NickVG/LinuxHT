# Описание

Стенд для практики к уроку «Автоматизация администрирования. Ansible.»  

Разворачивается два сервера: `host1` и `host2`. При развертывании Vagrant запускается Ansible [playbook](provisioning/playbook.yml). 

# Инструкция по применению
## Перед запуском
Требуется устнаовить git, ansible, virtualbox, vagrant
```bash
git clone https://github.com/NickVG/LinuxHT.git
cd LinuxHT/Linux11/
```
Все дальнейшие действия нужно делать из текущего каталога.

## Запускаем и работаем со стендом

Поднимем виртуальную машину: `vagrant up host1`

Запустим роль: `ansible-playbook nginx_new.yml`  
Так выглядит основной playbook `nginx_new.yml`, который уже в свою очередь ссылается на роли `nginx` и `mkrepo`:

```yml
---
- name: Install nginx && create repo
  hosts: host1
  become: true
  roles:
    - nginx 
    - mkrepo
```
Роль `nginx` поднимает вебсервер на центос.
Роль `mkrepo` создаёт репозиторий.

# список тасков в ролях

Посмотреть все таски, которые входят в роль:
```bash
ansible-playbook nginx_new.yml --list-tasks
playbook: nginx_new.yml

  play #1 (host1): Install EPEL Repo	TAGS: []
    tasks:
      nginx : Install NGINX	TAGS: []
      nginx : configure Nginx	TAGS: []
      nginx : Disable selinux	TAGS: []
      mkrepo : Install Packages	TAGS: []
      mkrepo : configure Nginx for repo	TAGS: []
      mkrepo : configure repo	TAGS: []
```
