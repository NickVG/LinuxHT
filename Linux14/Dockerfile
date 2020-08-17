#FROM alpine:3.12
#RUN apk update && apk upgrade
#RUN apk add nginx
#RUN rc-update add nginx default
#EXPOSE 80 443
#RUN apk add openrc --no-cache
#CMD ["nginx", "-g", "daemon off;"]
#CMD ["service","nginx","start"]
#STOPSIGNAL SIGTERM
#CMD ["nginx", "-g", "daemon off;"]

FROM nginx:1.18.0-alpine
#COPY ./files/nginx.conf /etc/nginx/conf.d/nginx.conf
#WORKDIR /usr/share/nginx/html
#COPY ./files/index.php /usr/share/nginx/html/
COPY ./files/index.html ./files/index.php /usr/share/nginx/html/
#COPY ./files/index.html /usr/share/nginx/html/index.html
EXPOSE 80 443

