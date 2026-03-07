#!/bin/bash
set -e

MYSQL_PASSWORD=$(cat /run/secrets/db_password)
. /run/secrets/credentials

echo "[WordPress] Waiting for MariaDB..."
until mysql -h"$MYSQL_HOST" -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" -e "SELECT 1" &>/dev/null; do
    echo "[WordPress] MariaDB is not ready, retrying in 2s..."
    sleep 2
done
echo "[WordPress] MariaDB is reachable."

if [ ! -f "wp-config.php" ]; then
    echo "[WordPress] Downloading core files..."
    wp core download --allow-root --force

    echo "[WordPress] Creating configuration..."
    wp config create \
        --dbname="$MYSQL_DATABASE" \
        --dbuser="$MYSQL_USER" \
        --dbpass="$MYSQL_PASSWORD" \
        --dbhost="$MYSQL_HOST" \
        --allow-root

    echo "[WordPress] Running installation..."
    wp core install \
        --url="$DOMAIN_NAME" \
        --title="$SITE_TITLE" \
        --admin_user="$ADMIN_USER" \
        --admin_password="$ADMIN_PASSWORD" \
        --admin_email="$ADMIN_EMAIL" \
        --allow-root

    echo "[WordPress] Creating user '$USER_LOGIN'..."
    wp user create "$USER_LOGIN" "$USER_EMAIL" \
        --role=author \
        --user_pass="$USER_PASSWORD" \
        --allow-root

    echo "[WordPress] Installation complete."
fi

chown -R www-data:www-data /var/www/wordpress

echo "[WordPress] Starting PHP-FPM..."
exec php-fpm8.2 -F
