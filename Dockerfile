FROM surnet/alpine-wkhtmltopdf:3.18.0-0.12.6-small as wkhtmltopdf
FROM php:8.2.18-fpm-alpine3.19

COPY --from=wkhtmltopdf /bin/wkhtmltopdf /bin/wkhtmltopdf
COPY --from=wkhtmltopdf /bin/libwkhtmltox* /bin/

# Install production dependencies
RUN apk update && apk add --no-cache \
    linux-headers \
    shadow \
    freetype-dev \
    g++ \
    gcc \
    git \
    imagemagick \
    libavif \
    libavif-dev \
    libc-dev \
    libstdc++ \
    libx11 \
    libxrender \
    libxext \
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
    libzip

# Install workspace dependencies
RUN apk add --no-cache --virtual .build-deps \
    $PHPIZE_DEPS \
    freetype-dev \
    imagemagick-dev \
    libjpeg-turbo-dev \
    libmemcached-dev \
    libpng-dev \
    libwebp-dev \
    libmcrypt-dev \
    libzip-dev \
    libtool \
    libxml2-dev \
    postgresql-dev \
    sqlite-dev \
    zlib-dev

# Configure php extensions
RUN docker-php-ext-configure gd \
    --with-freetype \
    --with-jpeg \
    --with-avif \
    --with-webp
RUN docker-php-ext-install gd

# Install PECL and PEAR extensions
RUN pecl install imagick
RUN pecl install xdebug
RUN pecl install swoole
RUN pecl install redis
RUN pecl install apcu
RUN pecl install igbinary

# Enable PECL and PEAR extensions
RUN docker-php-ext-enable \
    imagick \
    redis \
    xdebug

RUN docker-php-ext-enable xdebug opcache swoole apcu igbinary

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

RUN docker-php-ext-configure intl && docker-php-ext-install intl && docker-php-ext-enable intl

# Cleanup workspace dependencies

RUN apk add --no-cache \
    gifsicle \
    icu \
    icu-dev \
    jpegoptim \
    libstdc++ \
    libwebp-tools \
    msmtp \
    optipng \
    pngquant \
    python3 \
    python3-dev \
    mysql-client \
    py-pip \
    sudo \
    su-exec \
    rsync \
    bash \
    fish \
    sudo \
    fd \
    fzf \
    ripgrep \
    neovim \
    php82-zip

RUN ln -sf /usr/bin/msmtp /usr/sbin/sendmail;

RUN apk del -f .build-deps; rm -rf /tmp/*
