FROM php:8.2-fpm-alpine

RUN apk add --no-cache git unzip curl bash

RUN curl -sS https://getcomposer.org/installer -o composer-setup.php \
    && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && rm composer-setup.php

WORKDIR /var/www/symfony

COPY composer.json composer.lock ./

RUN composer install --no-interaction --no-scripts --no-progress

EXPOSE 8000

CMD ["php", "-S", "0.0.0.0:8000", "-t", "public"]