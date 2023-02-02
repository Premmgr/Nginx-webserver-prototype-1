#!/usr/bin/env bash




# subcommand section

case "$1" in
	"install")
		if [ "$(id -u)" = "0" ]; then

                        #docker installation
                        if ! which docker > /dev/null 2>&1; then
				echo "Docker is not installed, installing docker..."
				$(apt update && apt install apt-transport-https ca-certificates curl software-properties-common -y)
				$(curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg -y)
                                echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
				$(apt update -y)
				$(apt install docker-ce -y)
				$(systemctl enable docker &> /dev/null && systemct start docker &> /dev/null)
				$(systemctl status docker)
                                printf "\e[32mdocker installed\e[0m\n"
                        else
                                # if docker is already installed on the sytstem
				$(systemctl status docker &> /dev/null) || printf "\e[32mdocker installed but not running\e[0m\n" && $(systemctl enable docker && systemctl start docker)
				$(systemctl status docker &> /dev/null) && printf "\e[32mdocker up and running\e[0m\n"
				sleep 0.032
                        fi

			#nginx installation
                        if ! which nginx > /dev/null 2>&1; then
                                echo "Nginx is not installed, installing nginx..."
                                apt update && apt install nginx -y && printf "\e[32mnginx installed\e[0m\n"
                        else
                                # if nginx is alreayd installed on the sytstem
                                $(systemctl is-active nginx.service &> /dev/null) || printf "\e[33mnginx installed but not running\e[0m\n"
				$(systemctl is-active nginx.service &> /dev/null) && printf "\e[32mnginx up and running\e[0m\n"
                                sleep 0.032
                                printf "moving original nginx.conf >>> nginx.conf.bak\n"

                                # copies the host-nginx.conf in as nginx.conf in /etc/nginx/ directory
                                if [ -e host-nginx.conf ]; then
                                        mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak
                                        sleep 0.032
                                        cp host-nginx.conf /etc/nginx/nginx.conf
                                        sleep 0.032
                                        systemctl restart nginx.service
                                else
                                        printf "\e[31mError\e[0m, host-nginx.conf required!\n"
                                fi

                        fi




                else
                        printf "\e[31mError\e[0m, root permission required!\n"


                fi


	;;
	"status")
		printf "\n\e[36m[Requirements] \t\t\t[status]\e[0m\n\n"
		sleep 0.032
		$(cat docker-compose.yml 2> /dev/null | grep nginx:alpine &> /dev/null) ; $(cat Dockerfile | grep nginx:alpine &> /dev/null) \
        		&& echo -e "Docker requirement files:\t\e[32mOK\e[0m" || echo -e "Docker requirement files:\t\e[31mFailed\e[0m\t\t[ verify docker-compose.yml file in $(pwd) ]"
		sleep 0.032
		$(cat nginx.conf 2> /dev/null | grep root &> /dev/null) \
        		&& echo -e "Nginx requirement files:\t\e[32mOK\e[0m" \
        		|| echo -e "Nginx requirement files:\t\e[31mFailed\e[0m"
		sleep 0.032
		$(systemctl status docker &> /dev/null) \
        		&& echo -e "Docker status:\t\t\t\e[32mOK\e[0m" \
        		|| echo -e "Docker status:\t\t\t\e[31mFailed\e[0m\t\t[ try <$0 install> to install docker ]"
		sleep 0.032
		$(systemctl status nginx.service &> /dev/null) \
			&& echo -e "Nginx installed:\t\t\e[32mOK\e[0m" \
                        || echo -e "Nginx installed:\t\t\e[31mFailed\e[0m\t\t[ try <$0 install> to install nginx ]"
		sleep 0.032
                $(systemctl status docker.service &> /dev/null) \
                        && echo -e "Docker installed:\t\t\e[32mOK\e[0m" \
                        || echo -e "Docker installed:\t\t\e[31mFailed\e[0m\t\t[ try <$0 install> to install docker ]"
		
		
		printf "\n"
	;;
	"host-install")
		sleep 0.032
		# shows the error if nginx binary is not found in system
		if [ "$(id -u)" = "0" ]; then
			
			#nginx installation
			if ! which nginx > /dev/null 2>&1; then
				echo "Nginx is not installed, installing nginx..."
				apt update && apt install nginx -y && printf "\e[32mnginx installed\e[0m\n"
			else
				# if nginx is alreayd installed on the sytstem
				$(systemctl is-active nginx.service &> /dev/null) && printf "\e[32mnginx up and running\e[0m\n"
				sleep 0.032
				printf "moving original nginx.conf >>> nginx.conf.bak\n"
				
				# copies the host-nginx.conf in as nginx.conf in /etc/nginx/ directory
				if [ -e host-nginx.conf ]; then
					mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak
					sleep 0.032
					cp host-nginx.conf /etc/nginx/nginx.conf
					sleep 0.032
					systemctl restart nginx.service
				else
					printf "\e[31mError\e[0m, host-nginx.conf required!\n"
				fi

			fi
			
		else
			printf "\e[31mError\e[0m, root permission required!\n"
			
    
			#check if nginx services are up
			#service nginx start
		fi

		

	;;
        "star-container")
                sleep 0.032
                # shows the error if nginx binary is not found in system
                if [ "$(id -u)" = "0" ]; then
			#docker installation
                        if ! which docker > /dev/null 2>&1; then
                                echo "Docker is not installed, installing docker..."
                                $(apt update && apt install apt-transport-https ca-certificates curl software-properties-common -y)
                                $(curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg -y)
                                echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
                                $(apt update -y)
                                $(apt install docker-ce -y)
                                $(systemctl enable docker &> /dev/null && systemct start docker &> /dev/null)
                                $(systemctl status docker)
                                printf "\e[32mdocker installed\e[0m\n"
                        else
                                # if docker is already installed on the sytstem
                                $(systemctl status docker &> /dev/null) || printf "\e[32mdocker installed but not running\e[0m\n" && $(systemctl enable docker && systemctl start docker)
                                $(systemctl status docker &> /dev/null) && printf "\e[32mdocker up and running\e[0m\n"
                                sleep 0.032
                        fi




                else
                        printf "\e[31mError\e[0m, root permission required!\n"


                fi



        ;;
*)
esac
