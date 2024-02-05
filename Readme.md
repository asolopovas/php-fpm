
# Dockerfile for PHP with wkhtmltopdf

This Dockerfile creates a Docker image based on `php:8.3.2-fpm-alpine3.19` with `wkhtmltopdf` installed, along with various PHP extensions and tools necessary for development and production environments.

## Prerequisites

- Docker installed on your machine. Visit [Docker's official website](https://docs.docker.com/get-docker/) for installation instructions.
- Basic knowledge of Docker and containerization.

## How to Download

To download the Dockerfile, you can clone this repository using the command below:

```
git clone https://github.com/asolopovas/php-fpm.git
```

## Build Instructions

Navigate to the directory containing the Dockerfile and run the following command to build the Docker image:

```
docker build -t php-wkhtmltopdf .
```

This will create an image named `php-wkhtmltopdf` containing PHP 8.3.2 with wkhtmltopdf and necessary extensions.

## Using Docker Hub

The Docker image is also available on Docker Hub. You can pull a specific tag of the image using the following command:

```
docker pull asolopovas/php-fpm:[tag]
```

Replace `[tag]` with the actual tag you wish to pull. You can find the list of available tags on the Docker Hub page: [asolopovas/php-fpm](https://hub.docker.com/repository/docker/asolopovas/php-fpm/general).

## Configuration

The Dockerfile includes the installation of wkhtmltopdf from `surnet/alpine-wkhtmltopdf:3.18.0-0.12.6-small` and installs various PHP extensions and tools like GD, Imagick, Redis, Xdebug, and more. Additionally, it configures the environment to support web development tasks efficiently.

## Usage

Once the image is built or pulled from Docker Hub, you can run a container using the following command:

```
docker run -d --name php-container php-wkhtmltopdf
```

This command starts a container named `php-container` based on the `php-wkhtmltopdf` image. You can then use Docker commands to interact with your container, execute PHP scripts, or configure it further to suit your development needs.

## Customization

You can customize the Dockerfile to include more PHP extensions, configure PHP settings, or include additional services based on your project requirements.
