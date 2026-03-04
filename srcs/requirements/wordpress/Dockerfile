FROM debian:bullseye

RUN apt update && \
    apt install -y \
    php-fpm \
    php-mysql \
	mariadb-client \
    wget \
    curl && \
	curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp \
	&& sed -i 's|listen = /run/php/php7.4-fpm.sock|listen = 9000|' /etc/php/7.4/fpm/pool.d/www.conf \
	&& mkdir -p /var/run/php /var/www/wordpress

COPY tools/init.sh /init.sh
RUN chmod +x /init.sh

EXPOSE 9000

CMD ["/init.sh"]