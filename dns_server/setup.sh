#!/bin/bash
timedatectl set-timezone Asia/Ho_Chi_Minh
systemctl start ssh && systemctl enable ssh && ufw allow ssh && systemctl status ssh
systemctl start bind9 && systemctl enable bind9
systemctl status bind9
