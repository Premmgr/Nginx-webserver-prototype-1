This tools allows you to automatically host webserver,static webserver depending on docker-compose.yml file.
tool name <webserver-tool.sh>
version: v1.02
code owner: prem gharti

usage: 
script made for ubuntu 22.04 LTS 

install <options>                 - start build,configuration for webserver(host/container) 
start                             - starts the container 
status                            - shows the status 
docker                            - installs the docker on the system 
nginx                             - installs the nginx on the system 


complete video guide url : (comming soon) 

to build container 
- ./webserver-tool.sh install container 
this command will delete previously built docker image and build new image from Dockerfile 


to start webserver docker container 
- ./webserver-tool.sh start container 

to stop the webserer docker container 
- ./webserver-tool.sh halt container


