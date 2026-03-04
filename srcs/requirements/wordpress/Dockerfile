FROM debian:bullseye

RUN apt update && \
    apt install -y \
    php-fpm \
    php-mysql \
    wget \
    curl && \
    mkdir -p /run/php

COPY tools/init.sh /init.sh
RUN chmod +x /init.sh

EXPOSE 9000

CMD ["/init.sh"]

RUN sed -i 's|listen = .*|listen = 0.0.0.0:9000|' \
/etc/php/7.4/fpm/pool.d/www.conf