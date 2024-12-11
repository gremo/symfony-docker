ARG FRANKENPHP_TAG=latest

# Franken base stage
###############################################################################
FROM dunglas/frankenphp:$FRANKENPHP_TAG AS frankenphp_base
SHELL ["/bin/bash", "-euxo", "pipefail", "-c"]

ARG NODE_VERSION=
ENV COMPOSER_ALLOW_SUPERUSER=1

RUN \
    # Install OS packages
    apt-get update; \
    apt-get -y --no-install-recommends install \
        acl \
        git \
        libnss3-tools \
        openssh-client \
        supervisor \
        unzip \
    ; \
    # Configure OS
    sed -i '/\[supervisord\]/a user=root' /etc/supervisor/supervisord.conf; \
    sed -i '/\[supervisord\]/a nodaemon=true' /etc/supervisor/supervisord.conf; \
    sed -i '/^exec "\$@"/i if [ "$1" = "frankenphp" ] && [ "$APP_ENV" = "prod" ] && php bin/console --raw | grep -q "^doctrine:migrations:migrate"; then\n	php bin/console doctrine:migrations:migrate --allow-no-migration --no-interaction --no-ansi\nfi\n' /usr/local/bin/docker-php-entrypoint; \
    # Install PHP extensions
    install-php-extensions \
        @composer \
        apcu \
        gd \
        intl \
        opcache \
        pdo_mysql \
        xsl \
        zip \
    ; \
    # Configure PHP
    { \
        echo apc.enable_cli = 1; \
        echo memory_limit = 256M; \
        echo opcache.interned_strings_buffer = 16; \
        echo opcache.max_accelerated_files = 20000; \
        echo opcache.memory_consumption = 256; \
        echo realpath_cache_ttl = 600; \
        echo session.use_strict_mode = 1; \
        echo zend.detect_unicode = 0; \
    } >> "$PHP_INI_DIR/conf.d/10-php.ini"; \
    # Install Node.js
    if [ -n "$NODE_VERSION" ]; then \
        curl -fsSL "https://deb.nodesource.com/setup_$NODE_VERSION.x" | bash -; \
        apt-get install -y --no-install-recommends nodejs; \
        npm install -g yarn; \
    fi; \
    # Cleanup
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*

# Franken dev stage
###############################################################################
FROM frankenphp_base AS frankenphp_dev
SHELL ["/bin/bash", "-euxo", "pipefail", "-c"]

RUN \
    cp "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"; \
    { \
        echo xdebug.client_host = host.docker.internal; \
    } >> "$PHP_INI_DIR/conf.d/10-php.ini"

# Franken prod stage
###############################################################################
FROM frankenphp_base AS frankenphp_prod
SHELL ["/bin/bash", "-euxo", "pipefail", "-c"]

ENV APP_ENV=prod
ENV APP_RUNTIME=Runtime\\FrankenPhpSymfony\\Runtime
ENV FRANKENPHP_CONFIG="worker ./public/index.php"

RUN \
    cp "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"; \
    { \
        echo expose_php = 0; \
        echo opcache.preload = /app/config/preload.php; \
        echo opcache.preload_user = root; \
    } >> "$PHP_INI_DIR/conf.d/10-php.ini"

COPY --link config/docker/php.ini $PHP_INI_DIR/conf.d/20-php.ini
COPY --link config/docker/php.prod.ini $PHP_INI_DIR/conf.d/30-php.ini
COPY --link config/docker/supervisor.conf /etc/supervisor/conf.d/app.conf
COPY --link composer.* symfony.* ./

RUN composer install --no-cache --prefer-dist --no-dev --no-autoloader --no-scripts --no-progress

COPY --link . /app

RUN \
    mkdir -p var/cache var/log; \
    chmod +x bin/console; \
    composer dump-autoload --classmap-authoritative --no-dev; \
    composer dump-env prod; \
    bin/console cache:clear; \
    if [ -f package.json ]; then \
        if [ -f yarn.lock ]; then \
            yarn install --no-progress --frozen-lockfile; \
        elif [ -f package-lock.json ]; then \
            npm ci --no-progress; \
        else \
            npm install --no-progress; \
        fi; \
        npm run build; \
    fi; \
    sync
