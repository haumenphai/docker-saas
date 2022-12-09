#!/bin/bash
timedatectl set-timezone Asia/Ho_Chi_Minh
systemctl start ssh && systemctl enable ssh
ufw allow ssh

systemctl stop systemd-timesyncd
systemctl disable systemd-timesyncd

systemctl start postgresql && systemctl enable postgresql
systemctl start nginx && systemctl enable nginx
