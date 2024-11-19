#!/bin/bash

sudo apt update -y

sudo apt install php -y
sudo apt install mysql-client-core-8.0 -y
sudo apt install mariadb-client-core -y
sudo apt install php-mysqli -y

sudo apt install -y redis-tools
sudo apt install -y php-redis

sudo apt install apache2 -y
sudo systenctl start apache2
sudo systemctl enable apache2

sudo systemctl start php-fpm
sudo systemctl enable php-fpm

sudo usermod -a -G apache ubuntu
sudo chown -R ubuntu:apache /var/www/html
sudo chown -R apache:apache /var/www/html

sudo apt update
sudo apt install nfs-common -y

wget https://wordpress.org/latest.zip
unzip latest.zip
sudo cp -R wordpress/* /var/www/html/