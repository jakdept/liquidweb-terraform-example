#!/bin/bash

yum install -y epel-release
yum install -y http://rpms.remirepo.net/enterprise/remi-release-8.rpm


yum install -y wget curl nginx mysql mysql-common mysql-server
yum install -y php82-php-fpm php82-php-mysqlnd php82-php-mbstring


mkdir -p /var/www/html/site
cd /var/www/html/site

curl --silent https://wordpress.org/latest.tar.gz| tar xfz - wordpress/* --strip-components=1

chown -R nginx. /var/www/html/site

systemctl enable nginx.service php82-php-fpm.service mysqld.service
systemctl start nginx.service php82-php-fpm.service mysqld.service

firewall-cmd --zone public --permanent --add-port 80/tcp
firewall-cmd --zone public --permanent --add-port 443/tcp
firewall-cmd --reload