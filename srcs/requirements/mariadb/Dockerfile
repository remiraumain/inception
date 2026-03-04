FROM debian:bullseye

RUN apt update && \
	DEBIAN_FRONTEND=noninteractive apt install -y mariadb-server && \
	mkdir -p /var/run/mysqld && \
    chown -R mysql:mysql /var/run/mysqld && \
    sed -i 's/^bind-address.*/bind-address = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf

COPY tools/init.sh /init.sh
RUN chmod +x /init.sh

EXPOSE 3306

CMD ["/init.sh"]