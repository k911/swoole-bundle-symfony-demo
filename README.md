# Swoole Bundle - Symfony Demo

Minimal hello world [Symfony](https://symfony.com/) application with [`k911/swoole-bundle`](https://github.com/k911/swoole-bundle) and [Docker](https://docs.docker.com/get-started/).

## Quick start - docker

*Requirements:*

- [composer](https://getcomposer.org/doc/00-intro.md#installation-linux-unix-macos)
- [Docker](https://docs.docker.com/install/)
- [docker-compose](https://docs.docker.com/compose/install/)

```bash
docker-compose build
docker-compose up
```

## Quick start - local

*Requirements:*

- PHP v7.2 and up
- [composer](https://getcomposer.org/doc/00-intro.md#installation-linux-unix-macos)
- [Swoole PHP Extension v4.3.0 and up](https://github.com/swoole/swoole-src)

```bash
composer install
./bin/console swoole:server:run
```