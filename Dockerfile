FROM 
ENV DEBIAN_FRONTEND noninteractive

## install required packages

RUN apt-get update
RUN apt-get install -yf \
    git \
    apache2 \
    php5 \
    php-http \
    php-pear \
    php5-dev \
    make \
    libcurl3-openssl-dev \
    supervisor

RUN mkdir -p /var/lock/apache2 /var/run/apache2 /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
RUN pecl install timezonedb
RUN pecl install pecl_http-1.7.6

RUN apt-get install ca-certificates

RUN ln -s /var/www/html html 

# Get the dashboard files

# Get rid of the default HTML
COPY index.html /var/www/html/index.html

# Add our custom HTML and image

# Add php file
COPY php.ini /etc/php5/apache2/php.ini


# Execute

# Apache starts with apt-get so we have to stop it.
RUN /etc/init.d/apache2 stop

EXPOSE 80
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

ADD dashboards /var/www/html/dashboards
