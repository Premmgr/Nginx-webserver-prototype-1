#!/usr/bin/env bash

tool_name="webserver-tool"
s_version="v1.02"
code_owner="prem gharti"

source utilscript

# subcommand section
case "$1" in
	"help")
		printf "\n$0 install <options>\t\t\t- start build,configuration for webserver(host/container)\n"
		printf "$0 start\t\t\t\t- starts the container\n"
		printf "$0 status\t\t\t\t- shows the status\n"
		printf "$0 docker\t\t\t\t- installs the docker on the system\n"
		printf "$0 nginx\t\t\t\t- installs the nginx on the system\n"
	;;
	"start")
		case "$2" in
                        "container")
                                ${f_start_container}
                        ;;

                        "host")
                                
				${f_hostweb_nginx} && printf "${GREEN}weserver is up and running${EC}\n"; printf "webserver root path:\t${default_nginx_path}/app_data\nwebserver running on:\t${GREEN}Host${EC}\n"
				;;
                        "--help")
                                printf "$0 start container  : starts webserver on docker"
				printf "$0 start host       : starts webserver on host system"
                                
                        ;;
                        *)
                                echo -e "available options [ \e[33mcontainer, host\e[0m ]"
                esac
	;;

	"install")
		case "$2" in
			"container")
				echo "starting preparation for web server in docker"
				echo ""
				mkdir logs &> /dev/null
				${f_build_container}
				docker images | grep webserver:latest
			;;
			"host")
				mkdir logs &> /dev/null
				${f_hostweb_nginx}
			;;
			"--help")
				printf "$0 install container  : starts webserver on docker"
				printf "$0 install host       : starts webserver on host system"
			;;
			*)
				echo -e "available options [ \e[33mcontainer, host\e[0m ]"
		esac


	;;
	"status")
		echo "
<Requirements>			<state>		 	<status>
		     "
		sleep 0.032
		$(cat docker-compose.yml 2> /dev/null | grep nginx:alpine &> /dev/null) ; $(cat Dockerfile | grep nginx:alpine &> /dev/null) \
        		&& echo -e "Docker requirement files:\t\e[32mOK\e[0m" || echo -e "Docker requirement files:\t\e[31mFailed\e[0m\t\t[ verify docker-compose.yml file in $(pwd) ]"
		sleep 0.032
		$(cat conf/default.conf 2> /dev/null | grep root &> /dev/null) \
        		&& echo -e "Nginx defult conf files:\t\e[32mOK\e[0m" \
        		|| echo -e "Nginx defult conf files:\t\e[31mFailed\e[0m"
		sleep 0.032
                $(cat conf/default.conf 2> /dev/null | grep root &> /dev/null) \
                        && echo -e "nginx.conf files:\t\t\e[32mOK\e[0m" \
                        || echo -e "nginx.conf files:\t\t\e[31mFailed\e[0m"
		sleep 0.032
                $(which docker &> /dev/null) \
                        && echo -e "Docker installed:\t\t\e[32mOK\e[0m\t\t\t[ Docker version: $(docker version | grep Version | head -1 | cut -d ':' -f2 | xargs) ]" \
                        || echo -e "Docker installed:\t\t\e[31mFailed\e[0m\t\t\t[ try <$0 docker> ]"

		sleep 0.032
		$(systemctl status docker &> /dev/null) \
			&& echo -e "Docker status:\t\t\t\e[32mRunning\e[0m\t\t\t[ \e[32mOk\e[0m ]" \
        		|| echo -e "Docker status:\t\t\t\e[31mNot running\e[0m\t\t\t[ \e[32mFailed\e[0m ]"
		sleep 0.032
		$(systemctl status nginx.service &> /dev/null) \
			&& echo -e "Host nginx :\t\t\t\e[32mRunning\e[0m" \
                        || echo -e "Host nginx :\t\t\t\e[33mNot running\e[0m\t\t[ try <$0 nginx> ]"
		sleep 0.032
                
		if [[ $(lsb_release -a 2> /dev/null| xargs | grep -i ubuntu &> /dev/null && echo $?) = '0' ]]
		then
			echo -e "Supported Os:\t\t\t\e[32mOK\e[0m\t\t\t[ $(lsb_release -a 2> /dev/null | grep Description | cut -d ':' -f2 | xargs) ]"
		else
			echo -e "Supported Os:\t\t\e[33mFailed\e[0m\t\t[ try <cat /etc/os_release> ]"
		fi		
		
		printf "\n"
	;;
	"nginx")
		sleep 0.032
		which nginx &> /dev/null && echo "nginx already installed"
		which nginx &> /dev/null || echo "nginx not installed" && ${f_install_nginx}
	;;
        "docker")
                sleep 0.032
		#which docker &> /dev/null  && echo "docker already installed" ; exit 0
		which docker &> /dev/null || echo "docker is not installed" && ${f_install_docker}
        ;;
	# subcommand for halt
	"halt")
                case "$2" in
                        "container")
                                ${f_down_container}
                        ;;
                        "host")
                                ${f_hostweb}
                        ;;
                        "--help")
                                printf "$0 start container  : starts webserver on docker"
                                printf "$0 start host       : starts webserver on host system"

                        ;;
                        *)
                                echo -e "available options [ \e[33mcontainer, host\e[0m ]"
                esac
        ;;
	"version")
                printf "\t${YELLOW}${tool_name}\tversion:${s_version}${EC}\n"
		printf "\t${YELLOW}code owner: ${code_owner}${EC}\n"
        ;;
*)
	printf "${RED}invalid command,${EC}" && sleep 1
	printf "\there is the help!\n"
	$0 help
esac

