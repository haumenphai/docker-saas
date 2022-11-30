# docker-saas-server

Docker images for odoo* development environment.
---------------------------------------------------

How to use:
----------
*Prepare*:
- Install docker Engine: https://docs.docker.com/engine/install/


**1. Get ubuntu server (haumenphai/ubuntu-full-dotd:20.04)**

Create new container [ubuntu 20.04] (replace 'test1' with the container name you want). <br>
```
$ docker run -itd --privileged --name test1 -h test1.foo.baz haumenphai/ubuntu-full-dotd:20.04 /usr/sbin/init && docker exec -it test1 bash
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
$ docker run -itd --privileged --name nginx -h nginx.foo.baz haumenphai/nginx-page-speed-1.22.0:20.04 /usr/sbin/init && docker exec -it nginx bash
```

**3. Get DNS Server (haumenphai/dns:20.04)**
```
$ docker run -itd --privileged --name dns -h dns.foo.baz haumenphai/dns:20.04 /usr/sbin/init && docker exec -it test1 dns bash
```

**4. Get Postgresql Server (haumenphai/psql:20.04)**
```
$ docker run -itd --privileged --name psql -h psql.foo.baz haumenphai/psql:20.04 /usr/sbin/init && docker exec -it psql bash
```

**5. Get Odoo Server (haumenphai/odoo_server:20.04)**
```
$ docker run -itd --privileged --name odoo -h odoo.foo.baz haumenphai/odoo_server:20.04 /usr/sbin/init && docker exec -it odoo bash
```

**6. Get Mail Server (haumenphai/mail_server:20.04)**
```
$ docker run -itd --privileged --name mail_server -h mail-server.foo.baz haumenphai/mail_server:20.04 /usr/sbin/init && docker exec -it mail_server bash
```

**7. Get Server Mix [postgres, nginx, odoo] (haumenphai/sv3_mix:20.04)**
```
$ docker run -itd --privileged --name sv3 -h sv3.foo.baz haumenphai/sv3_mix:20.04 /usr/sbin/init && docker exec -it sv3 bash
```
