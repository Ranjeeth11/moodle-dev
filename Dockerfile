FROM php:8.2-apache

# Install system dependencies and PHP extensions
RUN apt-get update && apt-get install -y \
    git unzip libpng-dev libjpeg-dev libfreetype6-dev libxml2-dev libzip-dev zip mariadb-client \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd mysqli zip intl soap opcache

# Enable Apache modules
RUN a2enmod rewrite

# Download Moodle source
WORKDIR /var/www/html
RUN rm -rf ./* && git clone -b MOODLE_404_STABLE git://git.moodle.org/moodle.git .

# Create Moodle data directory
RUN mkdir -p /var/www/moodledata && chown -R www-data:www-data /var/www/html /var/www/moodledata

EXPOSE 80
