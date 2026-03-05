FROM debian:bullseye

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y nginx openssl && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/nginx/ssl && \
    openssl req -x509 -nodes -days 365 \
        -out /etc/nginx/ssl/inception.crt \
        -keyout /etc/nginx/ssl/inception.key \
        -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=rraumain.42.fr/UID=rraumain"

COPY conf/nginx.conf /etc/nginx/conf.d/default.conf

RUN rm -f /etc/nginx/sites-enabled/default && \
    mkdir -p /var/run/nginx

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
