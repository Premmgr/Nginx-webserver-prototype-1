FROM nginx:alpine as build
EXPOSE 80
CMD ["nginx","-g","daemon off;"]
