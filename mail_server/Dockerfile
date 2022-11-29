FROM haumenphai/ubuntu-full-dotd:20.04
LABEL "maintainer"="Trinh Duc Do <codegunpow@gmail.com>"
LABEL "github.link"="https://github.com/haumenphai"

SHELL ["/bin/bash", "-c"]
#ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y rsyslog

# 1. setup postfix
RUN echo "2\npro.max" | apt-get install -y postfix
COPY ./postfix_main.conf /etc/postfix/main.cf

# install mailutils to send mail (echo "Title test" | mail -s "Body test" test@test.com)
RUN apt-get install -y mailutils

# default ssl to enable tls
COPY ./pro_max.pem /etc/ssl/certs/pro_max.pem
COPY ./pro_max_key.pem /etc/ssl/private/pro_max_key.pem

# 2. setup dovecot, enable authencation
RUN apt-get install -y dovecot-common dovecot-pop3d dovecot-imapd
COPY ./10-mail.conf /etc/dovecot/conf.d/10-mail.conf
COPY ./dovecot.conf /etc/dovecot/dovecot.conf
COPY ./dovecot_10-master.conf /etc/dovecot/conf.d/10-master.conf

COPY ./pro_max.pem /etc/ssl/certs/dovecotcert.pem
COPY ./pro_max_key.pem /etc/ssl/private/dovecotkey.pem

# 3. Create users catchall, user1, user2, with password 1 for login
RUN useradd -m -p $(openssl passwd -1 1) catchall
RUN useradd -m -p $(openssl passwd -1 1) user1
RUN useradd -m -p $(openssl passwd -1 1) user2

# 4. Setup roundcube web mail
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y apache2
RUN apt-get install -y mariadb-server mariadb-client

RUN service mysql start && echo "CREATE database test_database;" | mysql -u root --password=1 --host=localhost
RUN service mysql start && echo "CREATE USER 'test_user'@'localhost' IDENTIFIED BY 'EXAMPLE_PASSWORD';" | mysql -u root --password=1 --host=localhost
RUN service mysql start && echo "GRANT ALL PRIVILEGES ON test_database.* TO 'test_user'@'localhost';" | mysql -u root --password=1 --host=localhost

# install php
RUN apt-get install -y php
RUN apt-get install -y php-{common,mysql,xml,xmlrpc,curl,gd,imagick,cli,dev,imap,mbstring,opcache,soap,zip,intl}
RUN service apache2 restart
RUN printf '<?php\nphpinfo();' >> /var/www/html/info.php
# access <container_ip>/database_test.php to test
COPY ./php_test_connect_db.php /var/www/html/database_test.php

# config web mail

RUN printf "<VirtualHost *:80> \n \
ServerAdmin admin@mail.pro.max \n \
ServerName mail1.pro.max \n \
Alias /mail /usr/share/roundcube   \n \
</VirtualHost>" >> /etc/apache2/sites-enabled/mail1.pro.max.conf

RUN sudo DEBIAN_FRONTEND=noninteractive apt-get install -y roundcube
COPY ./roundcube_config.inc.php /etc/roundcube/config.inc.php

# ======================================================
# setup roundcube db, not needed if install roundcube with: apt-get install -y roundcube
RUN service mysql start && echo "CREATE DATABASE roundcube /*!40101 CHARACTER SET utf8 COLLATE utf8_general_ci */;" | mysql -u root --password=1 --host=localhost
RUN service mysql start && echo "CREATE USER 'roundcube'@'localhost' IDENTIFIED BY '1';" | mysql -u root --password=1 --host=localhost
RUN service mysql start && echo "GRANT ALL PRIVILEGES ON roundcube.* to 'roundcube'@'localhost';" | mysql -u root --password=1 --host=localhost
RUN service mysql start && mysql -u root --database roundcube --password=1 < /usr/share/roundcube/SQL/mysql.initial.sql
COPY ./roundcube_debian_db.php /etc/roundcube/debian-db.php
#====================================================================

RUN service apache2 restart

WORKDIR /~
COPY ./setup.sh /~
RUN chmod +x /~/setup.sh

#========================================================================
# How to use:
# $ cd mail_server
# $ docker build -t haumenphai/mail_server:20.04 .
# $ docker run -itd --privileged --name test1 -h test1.foo.baz haumenphai/mail_server:20.04 /usr/sbin/init && docker exec -it test1 bash
# root@test1:~# /bin/bash setup.sh

# If using local dns and dns it has its own docker network, then need to build and run the container with the same docker network.
# docker build --network dockernet1234 -t haumenphai/mail_server:20.04 . && docker run -itd --privileged --name test1 -h test1.foo.baz --net dockernet1234  haumenphai/mail_server:20.04 /usr/sbin/init && docker exec -it test1 bash

# Use mail server:
# you need setup dns by adding an A record that points to the container to use roundcube.
# outgoing mail server
# smtp_host: <container_ip> [mail1.pro.max]
# smtp_port: 25
# authencation: username
# security: TLS
# user_name: catchall
# password: 1

# incomming mail server
# host: <container_ip> [mail1.pro.max]
# port: 993
# type: imap
# SSL/TLS: yes
# user_name: catchall
# password: 1

# access webmail
# http://mail1.pro.max
# user: catchall
# password: 1
# server: 127.0.0.1

# odoo smtp config
# --smtp mail1.pro.max --smtp-port 25 --smtp-user catchall --smtp-password 1

# push image to dockerhub
# $ docker login
# $ docker push haumenphai/mail_server:20.04
