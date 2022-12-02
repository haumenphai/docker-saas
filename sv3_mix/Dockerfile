FROM haumenphai/ubuntu-full-dotd:20.04
SHELL ["/bin/bash", "-xo", "pipefail", "-c"]
ENV LANG C.UTF-8

# 1. Setup Postgresql
RUN apt-get update && \
    apt-get install -y postgresql postgresql-contrib

RUN echo "listen_addresses = '*'" >> /etc/postgresql/12/main/postgresql.conf
RUN service postgresql start && \
    sudo -u postgres psql -c "CREATE USER saas_master WITH LOGIN SUPERUSER CREATEDB CREATEROLE INHERIT REPLICATION CONNECTION LIMIT -1;" && \
    sudo -u postgres psql -c "\connect template1" -c "CREATE EXTENSION IF NOT EXISTS unaccent;"

# 2. Setup Nginx
RUN apt-get update && \
    apt-get install -y build-essential libssl-dev libpcre3 \
    libpcre3-dev libxml2-dev libxslt1-dev \
    libgd-dev libgeoip-dev libperl-dev curl

RUN echo "--prefix=/usr/local/nginx  \
    --conf-path=/etc/nginx/nginx.conf \
    --error-log-path=/var/log/nginx/error.log \
    --http-client-body-temp-path=/var/lib/nginx/body  \
    --http-fastcgi-temp-path=/var/lib/nginx/fastcgi  \
    --http-log-path=/var/log/nginx/access.log  \
    --http-proxy-temp-path=/var/lib/nginx/proxy  \
    --http-scgi-temp-path=/var/lib/nginx/scgi \
    --http-uwsgi-temp-path=/var/lib/nginx/uwsgi  \
    --lock-path=/var/lock/nginx.lock --pid-path=/run/nginx.pid  \
    --user=nginx --group=nginx \
    --with-pcre-jit --with-http_ssl_module  \
    --with-http_stub_status_module \
    --with-http_realip_module  \
    --with-http_auth_request_module  \
    --with-http_addition_module \
    --with-http_dav_module \
    --with-http_geoip_module \
    --with-http_gunzip_module  \
    --with-http_gzip_static_module  \
    --with-http_image_filter_module \
    --with-http_v2_module --with-http_sub_module \
    --with-http_xslt_module \
    --with-stream --with-stream_ssl_module --with-file-aio \
    --with-mail --with-mail_ssl_module --with-threads" | bash <(curl -f -L -sS https://ngxpagespeed.com/install) --nginx-version 1.22.0
RUN adduser --system --no-create-home --group nginx
RUN mkdir -p /var/log/nginx && chown nginx:nginx /var/log/nginx
RUN mkdir -p /var/lib/nginx && chown nginx:nginx /var/lib/nginx

RUN printf "Description=The NGINX HTTP and reverse proxy server\n\
After=syslog.target network.target remote-fs.target nss-lookup.target\n\
[Service]\n\
Type=forking\n\
PIDFile=/run/nginx.pid\n\
ExecStartPre=/usr/local/nginx/sbin/nginx -t -q -g 'daemon on; master_process on;'\n\
ExecStart=/usr/local/nginx/sbin/nginx -g 'daemon on; master_process on;'\n\
ExecReload=/usr/local/nginx/sbin/nginx -g 'daemon on; master_process on;' -s reload\n\
ExecStop=-/sbin/start-stop-daemon --quiet --stop --retry QUIT/5 --pidfile /run/nginx.pid\n\
TimeoutStopSec=5\n\
KillMode=mixed\n\
[Install]\n\
WantedBy=multi-user.target\n" >> /lib/systemd/system/nginx.service
COPY ./nginx.conf /etc/nginx/nginx.conf

# 3. Setup Odoo

RUN apt-get update && apt-get install -y software-properties-common
RUN add-apt-repository ppa:deadsnakes/ppa && apt-get update

RUN apt-get install -y python3-dev libxml2-dev libxslt1-dev \
    libldap2-dev libsasl2-dev libtiff5-dev \
    libjpeg8-dev libopenjp2-7-dev zlib1g-dev \
    libfreetype6-dev liblcms2-dev libwebp-dev \
    libharfbuzz-dev libfribidi-dev libxcb1-dev \
    libpq-dev python3.7-dev python3.8-dev \
    build-essential python3-virtualenv python3.8-venv \
    python3-distutils python3-apt python3.7-distutils
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        dirmngr \
        fonts-noto-cjk \
        gnupg \
        libssl-dev \
        node-less \
        npm \
        python3-num2words \
        python3-pdfminer \
        python3-pip \
        python3-phonenumbers \
        python3-pyldap \
        python3-qrcode \
        python3-renderpm \
        python3-setuptools \
        python3-slugify \
        python3-vobject \
        python3-watchdog \
        python3-xlrd \
        python3-xlwt \
        xz-utils

RUN npm install -g rtlcss

RUN python3.7 -m virtualenv /opt/python3.7-venv/odoo13
RUN python3.8 -m venv /opt/python3.8-venv/odoo14 && \
    python3.8 -m venv /opt/python3.8-venv/odoo15 && \
    python3.8 -m venv /opt/python3.8-venv/odoo16

RUN /opt/python3.7-venv/odoo13/bin/python3.7 -m pip install setuptools wheel
RUN /opt/python3.8-venv/odoo14/bin/python3.8 -m pip install setuptools wheel
RUN /opt/python3.8-venv/odoo15/bin/python3.8 -m pip install setuptools wheel
RUN /opt/python3.8-venv/odoo16/bin/python3.8 -m pip install setuptools wheel

RUN /opt/python3.7-venv/odoo13/bin/python3.7 -m pip install -r https://raw.githubusercontent.com/Viindoo/odoo/13.0/requirements.txt
RUN /opt/python3.8-venv/odoo14/bin/python3.8 -m pip install -r https://raw.githubusercontent.com/Viindoo/odoo/14.0/requirements.txt
RUN /opt/python3.8-venv/odoo15/bin/python3.8 -m pip install -r https://raw.githubusercontent.com/odoo/odoo/15.0/requirements.txt
RUN /opt/python3.8-venv/odoo16/bin/python3.8 -m pip install -r https://raw.githubusercontent.com/Viindoo/odoo/16.0/requirements.txt

RUN echo '===================================================================================='
RUN /opt/python3.7-venv/odoo13/bin/python3.7 -m pip install -r https://raw.githubusercontent.com/Viindoo/odoo/13.0/requirements.txt
RUN /opt/python3.8-venv/odoo14/bin/python3.8 -m pip install -r https://raw.githubusercontent.com/Viindoo/odoo/14.0/requirements.txt
RUN /opt/python3.8-venv/odoo15/bin/python3.8 -m pip install -r https://raw.githubusercontent.com/odoo/odoo/15.0/requirements.txt
RUN /opt/python3.8-venv/odoo16/bin/python3.8 -m pip install -r https://raw.githubusercontent.com/Viindoo/odoo/16.0/requirements.txt

RUN adduser --system --home=/opt/odoo --disabled-login --disabled-password --group odoo


WORKDIR /~
COPY ./setup.sh /~
RUN chmod +x /~/setup.sh


#========================================================================
# how to use:
# $ docker build -t haumenphai/sv3_mix:20.04 .
# $ docker run -itd --privileged --name test1 -h test1.foo.baz haumenphai/sv3_mix:20.04 /usr/sbin/init && docker exec -it test1 bash
# root@test1:~# /bin/bash setup.sh

# push image to dockerhub
# $ docker login
# $ docker push haumenphai/sv3_mix:20.04
