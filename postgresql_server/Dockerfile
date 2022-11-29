FROM haumenphai/ubuntu-full-dotd:20.04
SHELL ["/bin/bash", "-xo", "pipefail", "-c"]

RUN apt-get update && \
    apt-get install -y postgresql postgresql-contrib

RUN echo "listen_addresses = '*'" >> /etc/postgresql/12/main/postgresql.conf
RUN service postgresql start && \
    sudo -u postgres psql -c "CREATE USER saas_master WITH LOGIN SUPERUSER CREATEDB CREATEROLE INHERIT REPLICATION CONNECTION LIMIT -1;" && \
    sudo -u postgres psql -c "\connect template1" -c "CREATE EXTENSION IF NOT EXISTS unaccent;"

WORKDIR /~
COPY ./setup.sh /~
COPY ./pg_hba.conf /etc/postgresql/12/main/pg_hba.conf
RUN chmod +x /~/setup.sh

#========================================================================
# how to use:
# $ docker build -t haumenphai/psql:20.04 .
# $ docker run -itd --privileged --name test1 -h test1.foo.baz haumenphai/psql:20.04 /usr/sbin/init && docker exec -it test1 bash
# root@test1:~# /bin/bash setup.sh

# push image to dockerhub
# $ docker login
# $ docker push haumenphai/psql:20.04
