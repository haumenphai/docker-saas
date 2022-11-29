FROM haumenphai/ubuntu-full-dotd:20.04
SHELL ["/bin/bash", "-xo", "pipefail", "-c"]

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


WORKDIR /~
COPY ./setup.sh /~
COPY ./nginx.conf /etc/nginx/nginx.conf
RUN chmod +x /~/setup.sh

#========================================================================
# how to use:
# $ docker build -t haumenphai/nginx-page-speed-1.22.0:20.04 .
# $ docker run -itd --privileged --name test1 -h test1.foo.baz haumenphai/nginx-page-speed-1.22.0:20.04 /usr/sbin/init && docker exec -it test1 bash
# root@test1:~# /bin/bash setup.sh

# push image to dockerhub
# $ docker login
# $ docker push haumenphai/nginx-page-speed-1.22.0:20.04
