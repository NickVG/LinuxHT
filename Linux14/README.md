``ДЗ по Docker

docker-file для NGINX находится в корневой папке, называется `Dockerfile`
image размещён в dockerhub: `docker pull ingorbunovi/docker-hometask:1.2`

docker-file для PHP находится в корневой папке, называется `Dockerfile_php`
image размещён в dockerhub: `docker pull ingorbunovi/docker-hometask:1.1`

Описание инфраструткуры находится в `docker-compose.yml`

```Разница между Image и Container
Образ это
 - бинарники приложения с зависимостями
 - метаданные содерижимого образа и как образ запускается
 - внутри образа нет ядра или его модулей(это к вопросу о возможности сборки ядра в контейнере)
Контейнер это процесс использующий Образ.

