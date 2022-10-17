FROM surnet/alpine-wkhtmltopdf:3.10-0.12.6-small as wkhtmltopdf
FROM php:8.1.6-fpm-alpine3.16

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
    swoole \
    xdebug

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
RUN apk del -f .build-deps; rm -rf /tmp/*

# www-data group/userid 1000

RUN apk add --no-cache \
    gifsicle \
    jpegoptim \
    libstdc++ \
    libwebp-tools \
    msmtp \
    optipng \
    pngquant \
    php8-zip \
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
    neovim

RUN groupadd -g 1000 www && useradd -u 1000 -ms /bin/fish -g www www
RUN docker-php-ext-enable xdebug opcache swoole
RUN chown -R www:www /var/www

RUN ln -sf /usr/bin/msmtp /usr/sbin/sendmail;
RUN ln -sf $(which nvim) /usr/bin/vim
