FROM haumenphai/ubuntu-full-dotd:20.04
RUN apt-get update && apt-get -y install bind9

WORKDIR /~
COPY ./setup.sh /~
RUN chmod +x /~/setup.sh

#========================================================================
# how to use:
# $ docker build -t haumenphai/dns:20.04 .
# $ docker run -itd --privileged --name test1 -h test1.foo.baz haumenphai/dns:20.0 /usr/sbin/init && docker exec -it test1 bash
# root@test1:~# /bin/bash setup.sh

# push image to dockerhub
# $ docker login
# $ docker push haumenphai/dns:20.04
