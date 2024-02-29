FROM --platform=linux/arm64/v8 wordpress:6.4.3-php8.2-apache
LABEL name="wordpress-memcache"
LABEL authors="TAKANO Mitsuhiro - https://github.com/takano32"

ENV DEBIAN_FRONTEND=noninteractive
ENV DEBCONF_NOWARNINGS=yes

# Install Memcache PHP extension
RUN apt-get update
RUN apt-get install -y unzip zlib1g zlib1g-dev libssl-dev
RUN pecl install memcache
RUN docker-php-ext-enable memcache

# Install APCu and Xdebug PHP extension
RUN pecl install apcu xdebug
RUN docker-php-ext-enable apcu xdebug

# Install SSH2 PHP extension
RUN apt-get install -y libssh2-1-dev
RUN pecl install ssh2
RUN docker-php-ext-enable ssh2

# Download and install Total Cache plugin
RUN curl -o w3-total-cache.zip -L -O https://downloads.wordpress.org/plugin/w3-total-cache.2.7.0.zip && \
    unzip w3-total-cache.zip -d /usr/src/wordpress/wp-content/plugins && \
    rm w3-total-cache.zip

RUN curl -o - -OL https://elasticache-downloads.s3.amazonaws.com/ClusterClient/PHP-8.2/latest-64bit-arm-X86-openssl3 | tar zxvf - && \
    rm ./README.markdown && \
    chmod o+x ./amazon-elasticache-cluster-client.so && \
    chown root:root ./amazon-elasticache-cluster-client.so && \
    mv ./amazon-elasticache-cluster-client.so /usr/local/lib/php/extensions/no-debug-non-zts*/ && \
    echo "extension=amazon-elasticache-cluster-client.so" | tee --append /usr/local/etc/php/conf.d/50-memcached.ini
RUN cd /lib/aarch64-linux-gnu && ln -s libcrypt.so.1.1.0 libcrypt.so.2

# Copy custom .htaccess
COPY custom.htaccess /usr/src/wordpress/.htaccess

#RUN mv /usr/src/wordpress/wp-content/plugins/memcached/object-cache.php /usr/src/wordpress/wp-content/object-cache.php

RUN random_string=$(LC_ALL=C tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 50) && \
    sed -i "/* That's all, stop editing! Happy publishing. */i \define( 'WP_CACHE_KEY_SALT', '${random_string}' );" /usr/src/wordpress/wp-config-docker.php

RUN sed -i "/* That's all, stop editing! Happy publishing. */i \$memcached_servers = array('default' => array(getenv_docker('WP_MEMCACHED_ENDPOINT', '')));" /usr/src/wordpress/wp-config-docker.php
