FROM ubuntu:20.04
LABEL "maintainer"="Trinh Duc Do <codegunpow@gmail.com>"
LABEL "github.link"="https://github.com/haumenphai"

RUN apt-get update
RUN yes | unminimize
RUN apt-get update && apt-get install -y net-tools vim man nano
RUN apt-get update && apt-get install -y psmisc zip unzip gzip dnsutils
RUN apt-get update && apt-get install -y wget tar sudo adduser curl
RUN apt-get update && apt-get install -y iputils-ping htop command-not-found
# setup systemd
RUN apt-get update && apt-get install -y init

# change password's user root to '1' and setup ssh
RUN echo '1\n1' | passwd root
RUN apt-get install -y openssh-server
RUN echo 'PasswordAuthentication yes\nPermitRootLogin yes' >> /etc/ssh/sshd_config

WORKDIR /~
COPY ./setup.sh /~
RUN chmod +x /~/setup.sh

#========================================================================
# how to use:
# $ cd ubuntu_full_20_04
# $ docker build -t haumenphai/ubuntu-full-dotd:20.04 . --network dockernet1234
# $ docker run -itd --privileged --name test1 -h test1.foo.baz haumenphai/ubuntu-full-dotd:20.04 /usr/sbin/init && docker exec -it test1 bash
# root@test1:~# /bin/bash setup.sh

# ssh
# $ docker inspect test1 | grep IP
# $ ssh root@<IP> (pass = 1)

# push image to dockerhub
# $ docker login
# $ docker push haumenphai/ubuntu-full-dotd:20.04
