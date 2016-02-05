FROM        mosaiksoftware/gentoo-nginx:latest
MAINTAINER  Julian Ospald <hasufell@gentoo.org>


##### PACKAGE INSTALLATION #####

# install nginx
RUN chgrp paludisbuild /dev/tty && cave resolve -c docker-sogo -x && \
	rm -rf /usr/portage/distfiles/* /srv/binhost/*

# update etc files... hope this doesn't screw up
RUN etc-update --automode -5

################################


RUN mkdir -p /var/run/sogo && chown sogo /var/run/sogo
RUN mkdir -p /var/run/memcached && chown memcached /var/run/memcached

COPY ./config/nginx.conf /etc/nginx/nginx.conf
COPY ./config/sites-enabled/sogo.conf /etc/nginx/sites-enabled/default.conf

COPY ./config/supervisord.conf /etc/supervisord.conf
COPY ./config/sogo/sogo.conf.template /etc/sogo/sogo.conf.template
COPY ./setup.sh /setup.sh

CMD /bin/bash /setup.sh && exec /usr/bin/supervisord -n -c /etc/supervisord.conf
