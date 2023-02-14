#!/usr/bin/env python3

import subprocess

# colors
RED = "\033[31m"
GREEN = "\033[32m"
BLUE = "\033[33m"
EC = "\033[0m"

def check_docker():
    try:
        subprocess.check_call(['id', '-u'], stdout=subprocess.DEVNULL)
    except subprocess.CalledProcessError:
        print(f"{RED}Error{EC}, root permission required!\n")
        return

    try:
        subprocess.check_call(['which', 'docker'], stdout=subprocess.DEVNULL)
    except subprocess.CalledProcessError:
        print("Docker is not installed, installing docker...")
        subprocess.call(['apt', 'update'])
        subprocess.call(['apt', 'install', 'apt-transport-https', 'ca-certificates', 'curl', 'software-properties-common', '-y'])
        subprocess.call(['curl', '-fsSL', 'https://download.docker.com/linux/ubuntu/gpg', '|', 'sudo', 'gpg', '--dearmor', '-o', '/usr/share/keyrings/docker-archive-keyring.gpg'])
        with open("/etc/apt/sources.list.d/docker.list", "w") as f:
            f.write("deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\n")
        subprocess.call(['apt', 'update', '-y'])
        subprocess.call(['apt', 'install', 'docker-ce', '-y'])
        subprocess.call(['systemctl', 'enable', 'docker'])
        subprocess.call(['systemctl', 'start', 'docker'])
        subprocess.call(['systemctl', 'status', 'docker'])
        print(f"{GREEN}docker installed{EC}\n")
    else:
        try:
            subprocess.check_call(['systemctl', 'status', 'docker'], stdout=subprocess.DEVNULL)
        except subprocess.CalledProcessError:
            print(f"{RED}Docker is already installed.{EC}")
            print(f"{GREEN}docker installed but not running{EC}\n")
            subprocess.call(['systemctl', 'enable', 'docker'])
            subprocess.call(['systemctl', 'start', 'docker'])
            subprocess.call(['systemctl', 'status', 'docker'])
            print(f"{GREEN}docker up and running{EC}\n")
        else:
            print(f"{GREEN}Docker is already installed, up and running.{EC}")

f_check_docker = check_docker
f_check_docker()
