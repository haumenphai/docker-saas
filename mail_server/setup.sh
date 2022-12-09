#!/bin/bash
timedatectl set-timezone Asia/Ho_Chi_Minh
systemctl start ssh && systemctl enable ssh
ufw allow ssh
systemctl status ssh

systemctl stop systemd-timesyncd
systemctl disable systemd-timesyncd

systemctl restart postfix
systemctl restart dovecot
