#!/bin/bash
set -e

MYSQL_PASSWORD=$(cat /run/secrets/db_password)
MYSQL_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)

if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "[MariaDB] Initializing data directory..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql

    echo "[MariaDB] Starting temporary instance..."
    mysqld --user=mysql --skip-networking &
    pid="$!"

    until mysqladmin --host=localhost --user=root ping --silent 2>/dev/null; do
        echo "[MariaDB] Waiting for temporary instance..."
        sleep 1
    done

    echo "[MariaDB] Creating database and users..."
    mysql --host=localhost --user=root <<-EOSQL
		ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
		CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
		CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
		GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
		FLUSH PRIVILEGES;
	EOSQL

    echo "[MariaDB] Stopping temporary instance..."
    kill "$pid"
    wait "$pid"
    echo "[MariaDB] Initialization complete."
fi

echo "[MariaDB] Starting server..."
exec mysqld --user=mysql
