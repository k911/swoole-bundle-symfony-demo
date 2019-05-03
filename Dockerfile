ARG PHP_TAG="7.3-cli-alpine3.9"

FROM php:$PHP_TAG as ext-builder
RUN docker-php-source extract && \
    apk add --no-cache --virtual .phpize-deps $PHPIZE_DEPS

FROM ext-builder as ext-swoole
ARG SWOOLE_VERSION="4.3.1"
RUN pecl install swoole-${SWOOLE_VERSION} && \
    docker-php-ext-enable swoole

FROM composer:latest as app-installer
WORKDIR /usr/src/app
RUN composer global require "hirak/prestissimo:^0.3" --prefer-dist --no-progress --no-suggest --classmap-authoritative --ansi
COPY composer.json composer.lock symfony.lock ./
RUN composer validate
ARG COMPOSER_ARGS="install"
RUN composer ${COMPOSER_ARGS} --prefer-dist --ignore-platform-reqs --no-progress --no-suggest --no-scripts --no-autoloader --ansi
COPY . ./
RUN composer dump-autoload --classmap-authoritative --ansi

FROM php:$PHP_TAG as base
WORKDIR /usr/src/app
RUN addgroup -g 1000 -S runner && \
    adduser -u 1000 -S app -G runner && \
    chown app:runner /usr/src/app
RUN apk add --no-cache libstdc++
# php -i | grep 'PHP API' | sed -e 's/PHP API => //'
ARG PHP_API_VERSION="20180731"
COPY --from=ext-swoole /usr/local/lib/php/extensions/no-debug-non-zts-${PHP_API_VERSION}/swoole.so /usr/local/lib/php/extensions/no-debug-non-zts-${PHP_API_VERSION}/swoole.so
COPY --from=ext-swoole /usr/local/etc/php/conf.d/docker-php-ext-swoole.ini /usr/local/etc/php/conf.d/docker-php-ext-swoole.ini

FROM base as App
USER app:runner
ENV HOST="0.0.0.0" \
    PORT="9501" \
    MONOLOG_MAIN_STREAM_PATH="php://stdout" \
    MONOLOG_DEPRECATIONS_STREAM_PATH="php://sterr" \
    SWOOLE_LOG_STREAM_PATH="/proc/self/fd/1"
COPY --chown=app:runner --from=app-installer /usr/src/app ./
ENTRYPOINT ["./bin/console"]
CMD ["swoole:server:run"]
