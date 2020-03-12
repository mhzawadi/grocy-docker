
FROM alpine:3.11
MAINTAINER Matthew Horwood <matt@horwood.biz>

RUN apk update                             \
    &&  apk add nginx php7-fpm php7-gd php7-gmp php7-gettext php7-pcntl \
    php7-sqlite3 php7-sockets php7-ctype php7-pecl-mcrypt php7-pdo_sqlite \
    php7-session composer php7-tokenizer \
    && rm -f /var/cache/apk/* \
    && mkdir -p /var/www/html/ \
    && mkdir -p /run/nginx;

WORKDIR /var/www/html
COPY setup /config
ADD https://github.com/grocy/grocy/releases/download/v2.6.1/grocy_2.6.1.zip /var/www/html/

# run php composer.phar with -vvv for extra debug information
RUN unzip grocy_2.6.1.zip && \
    cp config-dist.php data/config.php && \
    mkdir viewcache && \
    chmod +x /config/start.sh; \
    cp /config/php.ini /etc/php7/php.ini && \
		cp /config/php_fpm_site.conf /etc/php7/php-fpm.d/www.conf; \
    chown nobody:nginx /var/www/html/* -R;

# Expose volumes
VOLUME ["/var/www/html"]

# Expose ports
EXPOSE 80

ENTRYPOINT ["/config/start.sh"]
CMD ["nginx", "-g", "daemon off;"]
