
# Dockerfile for PHP with wkhtmltopdf for Laravel and WordPress Development

This Dockerfile creates a Docker image based on `php:8.3.2-fpm-alpine3.19` with `wkhtmltopdf` installed, along with various PHP extensions and tools necessary for development and production environments, catering specifically to Laravel and WordPress development.

## Prerequisites

- Docker installed on your machine. Visit [Docker's official website](https://docs.docker.com/get-docker/) for installation instructions.
- Basic knowledge of Docker and containerization.
- Git for version control.

## How to Download

To download the Dockerfile, clone this repository using the command below:

```
git clone https://github.com/asolopovas/php-fpm.git
```

## Installed Libraries and Extensions

The Docker image includes the following PHP extensions:

```
- bcmath
- calendar
- exif
- gd (with support for freetype, jpeg, and webp)
- mbstring
- pdo
- pdo_mysql
- pdo_pgsql
- pdo_sqlite
- mysqli
- pcntl
- xml
- zip
```

### PECL Extensions:

- **Imagick:** For image manipulation.
- **Xdebug:** For debugging and development.
- **Swoole:** For asynchronous programming and coroutines.
- **Redis:** For caching and session storage.
- **Igbinary:** For more efficient serialization.

Additionally, the image is equipped with `wkhtmltopdf` for HTML to PDF conversion, various development tools like Git, ImageMagick, and utilities for image optimization and development workflows.

## Build Instructions

Navigate to the directory containing the Dockerfile and execute the following command to build the Docker image:

```
docker build -t asolopovas/php-fpm .
```

This will create an image named `php-wkhtmltopdf` containing PHP 8.3.2 with wkhtmltopdf and the necessary extensions.

## Using Docker Hub

The Docker image is also available on Docker Hub. To pull a specific tag of the image, use the command:

```
docker pull asolopovas/php-fpm:[tag]
```

Replace `[tag]` with the actual tag you wish to pull. Available tags can be found on the Docker Hub page: [asolopovas/php-fpm](https://hub.docker.com/repository/docker/asolopovas/php-fpm/general).

## Makefile Automation

The included Makefile automates the process of building the Docker image, tagging the build, and pushing it to both GitHub and Docker Hub based on the version specified in a `Version` text file. Commands:

```bash
# Build Docker Image, Push Git Tags, and Push Docker Image to Docker Hub.
make all
# Build the Docker image based on the version specified in the `Version` file.
make build
# Tags the current commit in Git with the version from the `Version` file and pushes these tags to GitHub.
make tag-push
 # Pushes the built Docker image to Docker Hub under the tag specified in the `Version` file
make docker-push
```

Ensure you have the necessary permissions for pushing to the repositories and that you're logged in to Docker Hub (`docker login`) before using the Makefile commands.
