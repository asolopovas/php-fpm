FROM surnet/alpine-wkhtmltopdf:3.10-0.12.6-small as wkhtmltopdf
FROM php:8.1.6-fpm-alpine3.15

# Copy wkhtmltopdf files from docker-wkhtmltopdf image
COPY --from=wkhtmltopdf /bin/wkhtmltopdf /bin/wkhtmltopdf
COPY --from=wkhtmltopdf /bin/libwkhtmltox* /bin/

# Install production dependencies
RUN apk add --no-cache \
    shadow \
    freetype-dev \
    g++ \
    gcc \
    git \
    imagemagick \
    libc-dev \
    libstdc++ \
    libx11 \
    libxrender \
    libxext \
    libssl1.1 \
    make \
    oniguruma-dev \
    openssh-client \
    postgresql-libs \
    redis \
    fontconfig \
    freetype \
    ttf-dejavu \
    ttf-droid \
    ttf-freefont \
    ttf-liberation \
    zlib-dev

# Install workspace dependencies
RUN apk add --no-cache --virtual .build-deps \
    $PHPIZE_DEPS \
    freetype-dev \
    icu-dev \
    imagemagick-dev \
    libjpeg-turbo-dev \
    libpng-dev \
    libwebp-dev \
    libmcrypt-dev \
	libzip-dev \
    libtool \
    libxml2-dev \
    postgresql-dev \
    sqlite-dev

# Configure php extensions
RUN docker-php-ext-configure gd \
    --with-freetype \
    --with-jpeg \
    --with-webp
RUN docker-php-ext-install gd

# Install PECL and PEAR extensions
RUN pecl install \
    imagick \
    redis \
    xdebug \
    rm -r /tmp/pear

# Enable PECL and PEAR extensions
RUN docker-php-ext-enable \
    imagick \
    redis

# Install php extensions
RUN docker-php-ext-install \
    bcmath \
    calendar \
    exif \
    mbstring \
    pdo \
    pdo_mysql \
    pdo_pgsql \
    pdo_sqlite \
    mysqli \
    pcntl \
    xml \
    zip

# Cleanup workspace dependencies
RUN apk del -f .build-deps; \
    rm -rf /tmp/*

# www-data group/userid 1000
RUN  set -ex; usermod -u 1000 www-data; groupmod -g 1000 www-data; \
     chown -R 1000:1000 /var/www /home/www-data;

# # Fix iconv alpinerror still pops up
# RUN apk add --no-cache \
#     --repository https://dl-cdn.alpinelinux.org/alpine/v3.15/community/ \
#     --allow-untrusted \
#     gnu-libiconv
# ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php

RUN apk add --no-cache \
    bash \
    gifsicle \
    jpegoptim \
    libstdc++ \
    libwebp-tools \
    msmtp \
    neovim \
    optipng \
    php8-zip \
    pngquant \
    sudo \
    su-exec \
    zsh-vcs

RUN docker-php-ext-enable xdebug opcache

RUN ln -sf /usr/bin/msmtp /usr/sbin/sendmail;
RUN ln -sf $(which nvim) /usr/bin/vim
