FROM nginx:alpine as build
EXPOSE 80
RUN ln -s /usr/share/zoneinfo/Europe/Paris /etc/localtime
CMD ["nginx","-g","daemon off;"]
