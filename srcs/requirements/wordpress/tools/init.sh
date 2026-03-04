#!/bin/bash

if [ ! -f "/var/www/html/wp-config.php" ]; then
    mkdir -p /var/www/html
    cd /var/www/html

    wget https://wordpress.org/latest.tar.gz
    tar -xzf latest.tar.gz
    mv wordpress/* .
    rm -rf wordpress latest.tar.gz

    cp wp-config-sample.php wp-config.php

    sed -i "s/database_name_here/${MYSQL_DATABASE}/" wp-config.php
    sed -i "s/username_here/${MYSQL_USER}/" wp-config.php
    sed -i "s/password_here/${MYSQL_PASSWORD}/" wp-config.php
    sed -i "s/localhost/${MYSQL_HOST}/" wp-config.php

    chown -R www-data:www-data /var/www/html
fi

exec php-fpm7.4 -F