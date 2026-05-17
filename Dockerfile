# ---- Composer dependencies ----
FROM php:8.4-fpm-alpine AS composer-deps

RUN apk add --no-cache icu-dev libzip-dev && docker-php-ext-install intl zip

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

COPY composer.json composer.lock ./
# auth.json is mounted as a BuildKit secret (never stored in image layers)
RUN --mount=type=secret,id=composer_auth,target=/var/www/html/auth.json,required=false \
    composer install --no-dev --no-scripts --prefer-dist --ignore-platform-reqs

# ---- Production image ----
FROM php:8.4-fpm-alpine

ARG IMAGE_SOURCE=""
LABEL org.opencontainers.image.source=${IMAGE_SOURCE}

# ---- Configurable extensions ----
# DB_DRIVERS:  space-separated (mysql pgsql sqlite)
# EXTRA_PECL:  space-separated PECL extensions (redis imagick memcached)
# EXTRA_EXT:   space-separated PHP extensions (gmp soap sockets calendar)
ARG DB_DRIVERS="pgsql"
ARG EXTRA_PECL="redis"
ARG EXTRA_EXT=""
ARG VITE_APP_NAME="Laravel"
ARG VITE_PUSHER_APP_KEY=""
ARG VITE_PUSHER_APP_CLUSTER="mt1"
ARG VITE_PUSHER_HOST=""
ARG VITE_PUSHER_PORT="6001"
ARG VITE_PUSHER_SCHEME="http"

RUN set -eux; \
    # ---- Base packages (always needed for Laravel + Filament) ----
    RUNTIME_PKGS="nginx supervisor icu-libs libzip libpng libjpeg-turbo freetype libwebp libexif libcurl libxml2 oniguruma"; \
    BUILD_PKGS="icu-dev libzip-dev libpng-dev libjpeg-turbo-dev freetype-dev libwebp-dev curl-dev libxml2-dev oniguruma-dev linux-headers"; \
    PHP_EXTS="opcache bcmath pcntl intl zip gd exif mbstring curl xml"; \
    \
    # ---- Database drivers ----
    for driver in $DB_DRIVERS; do \
        case "$driver" in \
            mysql) \
                RUNTIME_PKGS="$RUNTIME_PKGS mariadb-connector-c mysql-client"; \
                BUILD_PKGS="$BUILD_PKGS mariadb-dev"; \
                PHP_EXTS="$PHP_EXTS pdo_mysql" ;; \
            pgsql) \
                RUNTIME_PKGS="$RUNTIME_PKGS libpq"; \
                BUILD_PKGS="$BUILD_PKGS postgresql-dev"; \
                PHP_EXTS="$PHP_EXTS pdo_pgsql" ;; \
            sqlite) \
                RUNTIME_PKGS="$RUNTIME_PKGS sqlite"; \
                BUILD_PKGS="$BUILD_PKGS sqlite-dev"; \
                PHP_EXTS="$PHP_EXTS pdo_sqlite" ;; \
            *) echo "Unknown DB driver: $driver" && exit 1 ;; \
        esac; \
    done; \
    \
    # ---- Extra PECL extensions ----
    PECL_LIST=""; \
    for ext in $EXTRA_PECL; do \
        case "$ext" in \
            redis) \
                PECL_LIST="$PECL_LIST redis" ;; \
            imagick) \
                RUNTIME_PKGS="$RUNTIME_PKGS imagemagick"; \
                BUILD_PKGS="$BUILD_PKGS imagemagick-dev"; \
                PECL_LIST="$PECL_LIST imagick" ;; \
            memcached) \
                RUNTIME_PKGS="$RUNTIME_PKGS libmemcached"; \
                BUILD_PKGS="$BUILD_PKGS libmemcached-dev zlib-dev cyrus-sasl-dev"; \
                PECL_LIST="$PECL_LIST memcached" ;; \
            mongodb) \
                BUILD_PKGS="$BUILD_PKGS openssl-dev"; \
                PECL_LIST="$PECL_LIST mongodb" ;; \
            *) echo "Unknown PECL extension: $ext" && exit 1 ;; \
        esac; \
    done; \
    \
    # ---- Extra PHP extensions ----
    for ext in $EXTRA_EXT; do \
        case "$ext" in \
            gmp) \
                RUNTIME_PKGS="$RUNTIME_PKGS gmp"; \
                BUILD_PKGS="$BUILD_PKGS gmp-dev"; \
                PHP_EXTS="$PHP_EXTS gmp" ;; \
            soap) \
                PHP_EXTS="$PHP_EXTS soap" ;; \
            sockets) \
                PHP_EXTS="$PHP_EXTS sockets" ;; \
            calendar) \
                PHP_EXTS="$PHP_EXTS calendar" ;; \
            *) echo "Unknown PHP extension: $ext" && exit 1 ;; \
        esac; \
    done; \
    \
    # ---- Install ----
    apk add --no-cache $RUNTIME_PKGS; \
    apk add --no-cache --virtual .build-deps $BUILD_PKGS $PHPIZE_DEPS; \
    \
    # PECL extensions
    for pecl_ext in $PECL_LIST; do \
        pecl install "$pecl_ext"; \
        docker-php-ext-enable "$pecl_ext"; \
    done; \
    \
    # Configure GD
    docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp; \
    \
    # PHP extensions
    docker-php-ext-install $PHP_EXTS; \
    \
    # Cleanup build deps
    apk del .build-deps

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

# Copy application code
COPY . .

# Copy vendor from composer stage (clean, no-dev)
COPY --from=composer-deps /var/www/html/vendor ./vendor

# Finish composer (generate autoload with app code present)
RUN composer dump-autoload --optimize --classmap-authoritative --no-dev \
    && composer run-script post-autoload-dump

# Set permissions
RUN chown -R www-data:www-data storage bootstrap/cache database \
    && chmod -R 775 database

# PHP config (before pre-cache so OPcache is active during build)
COPY docker/php/php-prod.ini /usr/local/etc/php/conf.d/99-prod.ini
COPY docker/php/www-prod.conf /usr/local/etc/php-fpm.d/www.conf

# Build frontend assets. Node is installed temporarily, used, and removed in
# the same layer to keep the image lean. Public Vite variables are passed in as
# build args and exported only for this step so the generated bundle matches the
# target environment without copying the full .env file into the image.
RUN set -eux; \
    export VITE_APP_NAME="$VITE_APP_NAME"; \
    export VITE_PUSHER_APP_KEY="$VITE_PUSHER_APP_KEY"; \
    export VITE_PUSHER_APP_CLUSTER="$VITE_PUSHER_APP_CLUSTER"; \
    export VITE_PUSHER_HOST="$VITE_PUSHER_HOST"; \
    export VITE_PUSHER_PORT="$VITE_PUSHER_PORT"; \
    export VITE_PUSHER_SCHEME="$VITE_PUSHER_SCHEME"; \
    apk add --no-cache --virtual .node-deps nodejs npm; \
    npm ci; \
    npm run build; \
    php artisan icons:cache; \
    php artisan filament:cache-components; \
    rm -rf node_modules /root/.npm; \
    apk del .node-deps

# Nginx config
COPY docker/nginx/nginx-prod.conf /etc/nginx/nginx.conf
COPY docker/nginx/default-prod.conf /etc/nginx/http.d/default.conf

# Supervisor config
RUN mkdir -p /etc/supervisor/conf.d
COPY docker/supervisor/supervisord-prod.conf /etc/supervisor/conf.d/supervisord.conf

# Entrypoint
COPY docker/entrypoint-prod.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 80

ENTRYPOINT ["/entrypoint.sh"]
