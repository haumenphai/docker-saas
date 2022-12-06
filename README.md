# docker-saas-server

Docker images for odoo* development environment.
---------------------------------------------------

How to use:
----------
*Prepare*:
- Install docker Engine: https://docs.docker.com/engine/install/
- You **must** create a docker network for assign static IP to container
  + ```
    docker network create --subnet=172.1.1.1/24 dockernet1234
    ```
- Ensure no local dns server, VPN when create a container:
    In linux, edit file `/etc/resolv.conf` and add `nameserver 8.8.8.8` to the top.
    ```
    sudo nano /etc/resolv.conf
    ```

**1. Get ubuntu server (haumenphai/ubuntu-full-dotd:20.04)**

Create new container [ubuntu 20.04] (replace 'test1' with the container name you want). <br>
```
$ docker run -itd --privileged --net dockernet1234 --ip 172.1.1.2 --name test1 -h test1.foo.baz haumenphai/ubuntu-full-dotd:20.04 /usr/sbin/init && docker exec -it test1 bash
```
Run setup script
```
root@test1:~# /bin/bash setup.sh
```

SSH to container
```
$ docker inspect test1 | grep IP
```

```
$ ssh root@<IP> (pass = 1)
```

**2. Get Nginx Server (haumenphai/nginx-page-speed-1.22.0:20.04)**
```
$ docker run -itd --privileged --net dockernet1234 --ip 172.1.1.3 --name nginx -h nginx.foo.baz haumenphai/nginx-page-speed-1.22.0:20.04 /usr/sbin/init && docker exec -it nginx bash
```

**3. Get DNS Server (haumenphai/dns:20.04)**
```
$ docker run -itd --privileged --net dockernet1234 --ip 172.1.1.4 --name dns -h dns.foo.baz haumenphai/dns:20.04 /usr/sbin/init && docker exec -it test1 dns bash
```

**4. Get Postgresql Server (haumenphai/psql:20.04)**
```
$ docker run -itd --privileged --net dockernet1234 --ip 172.1.1.5 --name psql -h psql.foo.baz haumenphai/psql:20.04 /usr/sbin/init && docker exec -it psql bash
```

**5. Get Odoo Server (haumenphai/odoo_server:20.04)**
```
$ docker run -itd --privileged --net dockernet1234 --ip 172.1.1.6 --name odoo -h odoo.foo.baz haumenphai/odoo_server:20.04 /usr/sbin/init && docker exec -it odoo bash
```

**6. Get Mail Server (haumenphai/mail_server:20.04)**
```
$ docker run -itd --privileged --net dockernet1234 --ip 172.1.1.7 --name mail_server -h mail-server.foo.baz haumenphai/mail_server:20.04 /usr/sbin/init && docker exec -it mail_server bash
```

**7. Get Server Mix [postgres, nginx, odoo] (haumenphai/sv3_mix:20.04)**
```
$ docker run -itd --privileged --net dockernet1234 --ip 172.1.1.8 --name sv3 -h sv3.foo.baz haumenphai/sv3_mix:20.04 /usr/sbin/init && docker exec -it sv3 bash
```
