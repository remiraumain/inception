#!/bin/bash
set -e

sleep 10

cd /var/www/wordpress

if [ ! -f "wp-config.php" ]; then
    wp core download --allow-root

    wp config create \
        --dbname=$MYSQL_DATABASE \
        --dbuser=$MYSQL_USER \
        --dbpass=$MYSQL_PASSWORD \
        --dbhost=$MYSQL_HOST \
        --allow-root
    
    wp core install \
        --url=$DOMAIN_NAME \
        --title=$SITE_TITLE \
        --admin_user=$ADMIN_USER \
        --admin_password=$ADMIN_PASSWORD \
        --admin_email=$ADMIN_EMAIL \
        --allow-root

    wp user create $USER_LOGIN $USER_EMAIL \
        --role=author \
        --user_pass=$USER_PASSWORD \
        --allow-root
fi

chown -R www-data:www-data /var/www/wordpress

exec php-fpm7.4 -F