ARG PHP_TAG="7.3-cli-alpine3.10"
ARG COMPOSER_TAG="1.9.0"

FROM php:${PHP_TAG} as php-base

FROM php-base as ext-builder
RUN docker-php-source extract && \
    apk add --no-cache --virtual .phpize-deps $PHPIZE_DEPS

FROM ext-builder as ext-swoole
RUN apk add --no-cache git
ARG SWOOLE_VERSION="4.4.7"
RUN git clone https://github.com/swoole/swoole-src.git --branch "v$SWOOLE_VERSION" --depth 1 && \
    cd swoole-src && \
    phpize && \
    ./configure && \
    make && \
    make install && \
    docker-php-ext-enable swoole

FROM ext-builder as ext-intl
RUN apk add --no-cache icu-dev && \
    docker-php-ext-install intl

FROM php-base as app-base
WORKDIR /usr/src/app
RUN addgroup -g 1000 -S runner && \
    adduser -u 1000 -S app -G runner && \
    chown app:runner /usr/src/app
RUN apk add --no-cache libstdc++ icu
# php -i | grep 'PHP API' | sed -e 's/PHP API => //'
ARG PHP_API_VERSION="20180731"
COPY --from=ext-intl /usr/local/lib/php/extensions/no-debug-non-zts-${PHP_API_VERSION}/intl.so /usr/local/lib/php/extensions/no-debug-non-zts-${PHP_API_VERSION}/intl.so
COPY --from=ext-intl /usr/local/etc/php/conf.d/docker-php-ext-intl.ini /usr/local/etc/php/conf.d/docker-php-ext-intl.ini
COPY --from=ext-swoole /usr/local/lib/php/extensions/no-debug-non-zts-${PHP_API_VERSION}/swoole.so /usr/local/lib/php/extensions/no-debug-non-zts-${PHP_API_VERSION}/swoole.so
COPY --from=ext-swoole /usr/local/etc/php/conf.d/docker-php-ext-swoole.ini /usr/local/etc/php/conf.d/docker-php-ext-swoole.ini

FROM composer:${COMPOSER_TAG} AS composer-bin
FROM app-base as app-installer
ENV COMPOSER_ALLOW_SUPERUSER="1"
COPY --chown=app:runner --from=composer-bin /usr/bin/composer /usr/local/bin/composer
WORKDIR /usr/src/app
RUN composer global require "hirak/prestissimo:^0.3" --prefer-dist --no-progress --no-suggest --classmap-authoritative --ansi
COPY composer.json composer.lock symfony.lock ./
RUN composer validate
ARG COMPOSER_ARGS="install"
RUN composer ${COMPOSER_ARGS} --prefer-dist --no-progress --no-suggest --no-scripts --no-autoloader --ansi
COPY . ./
RUN composer dump-autoload --classmap-authoritative --ansi

FROM app-base as App
USER app:runner
ENV HOST="0.0.0.0" \
    PORT="9501" \
    MONOLOG_MAIN_STREAM_PATH="php://stdout" \
    MONOLOG_DEPRECATIONS_STREAM_PATH="php://sterr" \
    SWOOLE_LOG_STREAM_PATH="/proc/self/fd/1"
COPY --chown=app:runner --from=app-installer /usr/src/app ./
ENTRYPOINT ["./bin/console"]
CMD ["swoole:server:run"]
