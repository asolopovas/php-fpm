FROM surnet/alpine-wkhtmltopdf:3.10-0.12.6-small as wkhtmltopdf
FROM php:8.1.22-fpm-alpine3.18

# Copy wkhtmltopdf files from docker-wkhtmltopdf image
COPY --from=wkhtmltopdf /bin/wkhtmltopdf /bin/wkhtmltopdf
COPY --from=wkhtmltopdf /bin/libwkhtmltox* /bin/

# Install production dependencies
RUN apk add --no-cache \
    zip \
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
    zlib-dev \
    libzip

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
    swoole

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

# Install xdebug
RUN apk add --update linux-headers
RUN pecl install xdebug
RUN docker-php-ext-enable xdebug

# Cleanup workspace dependencies
RUN apk del -f .build-deps; rm -rf /tmp/*

RUN apk add --no-cache \
    gifsicle \
    jpegoptim \
    libstdc++ \
    libwebp-tools \
    msmtp \
    optipng \
    pngquant

RUN docker-php-ext-enable xdebug opcache swoole

RUN ln -sf /usr/bin/msmtp /usr/sbin/sendmail;
