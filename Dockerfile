FROM php:7.3-fpm-alpine

LABEL maintainer="pratikprajapati540@gmail.com"
LABEL version="2.0"
LABEL description="This is an dockerfile for php 7.3 alpine"

# Install System Packages
RUN apk update && apk add --no-cache \
    libxml2-dev libzip-dev openssl-dev \
    git vim unzip bash \
    postgresql-dev

# Install Redis Extension
ENV PHPREDIS_VERSION 3.0.0

RUN mkdir -p /usr/src/php/ext/redis \
    && curl -L https://github.com/phpredis/phpredis/archive/$PHPREDIS_VERSION.tar.gz | tar xvz -C /usr/src/php/ext/redis --strip 1 \
    && echo 'redis' >> /usr/src/php-available-exts \
    && docker-php-ext-install redis

# Install PHP Extenstions
RUN docker-php-ext-install \
    bcmath \
    ctype \
    json \
    mbstring \
    pdo \
    pdo_pgsql \
    pdo_mysql \
    tokenizer \
    xml \
    zip \
    exif

# Install PHP Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

WORKDIR /var/www/html

ENTRYPOINT ["/docker-scripts/entrypoint.sh"]
CMD ["php-fpm"]
