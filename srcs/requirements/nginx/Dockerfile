FROM debian:bullseye

RUN apt update \
	&& DEBIAN_FRONTEND=noninteractive apt install -y nginx openssl \
	&& mkdir -p /etc/nginx/ssl \
	&& openssl req -x509 -nodes -out /etc/nginx/ssl/inception.crt -keyout /etc/nginx/ssl/inception.key \
	-subj "/C=FR/ST=IDF/L=Angoulême/O=42/OU=42/CN=rraumain.42.fr/UID=rraumain" \
	&& mkdir -p /var/run/nginx

COPY conf/nginx.conf /etc/nginx/conf.d/default.conf

RUN chmod 755 /var/www/html \
	&& chown -R www-data:www-data /var/www/html

CMD ["nginx", "-g", "daemon off;"]