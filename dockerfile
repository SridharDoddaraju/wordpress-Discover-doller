FROM php:apache


ARG WORDPRESS_VERSION=5.8
ARG WORDPRESS_URL=https://wordpress.org/wordpress-${WORDPRESS_VERSION}.tar.gz
ARG WORDPRESS_SHA1=e2df6d62d9f4b731bc01f8b9a6f86c038d8c02d3


RUN set -ex; \
    curl -o wordpress.tar.gz -SL ${WORDPRESS_URL}; \
    echo "${WORDPRESS_SHA1} *wordpress.tar.gz" | sha1sum -c -; \
    tar -xzf wordpress.tar.gz -C /var/www/html --strip-components=1; \
    rm wordpress.tar.gz; \
    chown -R www-data:www-data /var/www/html

# Set the working directory to /var/www/html
WORKDIR /var/www/html

# Expose port 80 for Apache
EXPOSE 80

# Define the entrypoint
ENTRYPOINT ["docker-entrypoint.sh"]

# CMD is set by the base image to start Apache, so no need to specify it here.
