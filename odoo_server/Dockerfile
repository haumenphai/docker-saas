FROM haumenphai/ubuntu-full-dotd:20.04
SHELL ["/bin/bash", "-xo", "pipefail", "-c"]
ENV LANG C.UTF-8

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
# $ docker build -t haumenphai/odoo_server:20.04 .
# $ docker run -itd --privileged --name test1 -h test1.foo.baz haumenphai/odoo_server:20.04 /usr/sbin/init && docker exec -it test1 bash
# root@test1:~# /bin/bash setup.sh

# push image to dockerhub
# $ docker login
# $ docker push haumenphai/odoo_server:20.04
