FROM <whatever ubuntu image>
ENV DEBIAN_FRONTEND noninteractive

## install required packages

RUN apt-get update
RUN apt-get install -yf \
    git \
    apache2 \
    php5 \
    supervisor

# setup Apache

RUN mkdir -p /var/lock/apache2 /var/run/apache2 /var/log/supervisor
COPY apache2.conf /etc/apache2/conf.d/apache2.conf 

# Add your custom supervisor script
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN git config --global user.name ""
RUN git config --global user.email ""

RUN apt-get install ca-certificates


# Get the dashboard files

RUN git clone https://<your html files>.git /var/www/html/

# Get rid of the default HTML
COPY index.html /var/www/html/index.html

# Add our custom HTML and image
ADD <non get tracked files> /var/www/html/



# Get most recent dashboard files because Docker will see the clone was run already and caches the files. The pull will get the actual files
# when Jenkins runs

WORKDIR /var/www/html/dashboards
RUN git pull https://<your html files in git>.git

# Execute

# Apache starts with apt-get so we have to stop it.
RUN /etc/init.d/apache2 stop
# checking contents of /var/www/html
# RUN ls -al /var/www/html/

EXPOSE 80
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

