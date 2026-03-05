FROM debian:bullseye

RUN apt-get update && \
    apt-get install -y \
        php7.4-fpm \
        php7.4-mysql \
        mariadb-client \
        curl && \
    rm -rf /var/lib/apt/lists/*

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

RUN mkdir -p /run/php /var/www/wordpress

RUN sed -i 's|listen = /run/php/php7.4-fpm.sock|listen = 9000|' /etc/php/7.4/fpm/pool.d/www.conf

COPY tools/init.sh /init.sh
RUN chmod +x /init.sh

WORKDIR /var/www/wordpress

EXPOSE 9000

CMD ["/init.sh"]
