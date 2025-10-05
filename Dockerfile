FROM php:8.2-apache

# Avoid interactive prompts during install
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies and PHP extensions
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        git unzip libpng-dev libjpeg62-turbo-dev libfreetype6-dev \
        libxml2-dev libzip-dev zip mariadb-client locales \
        && docker-php-ext-configure gd --with-freetype --with-jpeg \
        && docker-php-ext-install gd mysqli zip intl soap opcache \
        && apt-get clean && rm -rf /var/lib/apt/lists/*

# Enable Apache rewrite
RUN a2enmod rewrite
