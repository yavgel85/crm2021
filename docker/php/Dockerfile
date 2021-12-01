# Official Docker Image for PHP
# https://hub.docker.com/_/php
FROM php:8.0-fpm

# Set working directory
WORKDIR /var/www/vhost/

# Install dependencies
RUN apt-get clean && apt-get update && apt-get upgrade -y && apt-get install -y \
    git \
    libcurl4-openssl-dev \
    libonig-dev \
    libpng-dev \
    libssl-dev \
    libicu-dev \
    libxml2-dev \
    libzip-dev \
    unzip \
    wget \
    zip \
    tzdata

ARG INSTALL_PHPREDIS=false

RUN pecl install -o -f redis \
    && rm -rf /tmp/pear \
    && docker-php-ext-enable redis

RUN docker-php-ext-configure intl

# PHP Extensions
RUN docker-php-ext-install \
    bcmath \
    ctype \
    exif \
    gd \
    mbstring \
    mysqli \
    opcache \
    pdo_mysql \
    pcntl \
    tokenizer \
    xml \
    zip \
    intl

# Install Composer from Official Docker Image
# https://hub.docker.com/_/composer
# Install composer
COPY --from=composer:2.1.3 /usr/bin/composer /usr/bin/composer
