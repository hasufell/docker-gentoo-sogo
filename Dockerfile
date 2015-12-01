FROM        hasufell/gentoo-nginx:latest
MAINTAINER  Julian Ospald <hasufell@gentoo.org>


##### PACKAGE INSTALLATION #####

# copy paludis config
COPY ./config/paludis /etc/paludis
COPY ./config/local-overlay /usr/local-overlay

# fetch jobs
RUN chgrp paludisbuild /dev/tty && cave resolve -c world -x -f
RUN chgrp paludisbuild /dev/tty && cave resolve -c tools -x -1 -f
RUN chgrp paludisbuild /dev/tty && cave resolve -c sogoset -x -1 -f

# install jobs
RUN chgrp paludisbuild /dev/tty && cave resolve -c world -x
RUN chgrp paludisbuild /dev/tty && cave resolve -c tools -x
RUN chgrp paludisbuild /dev/tty && cave resolve -c sogoset -x

# # update etc files... hope this doesn't screw up
RUN etc-update --automode -5

# ################################


RUN mkdir -p /var/run/sogo && chown sogo /var/run/sogo
RUN mkdir -p /var/run/memcached && chown memcached /var/run/memcached

COPY ./config/nginx.conf /etc/nginx/nginx.conf
COPY ./config/sites-enabled/sogo.conf /etc/nginx/sites-enabled/default.conf

COPY ./config/supervisord.conf /etc/supervisord.conf
COPY ./config/sogo/sogo.conf.template /etc/sogo/sogo.conf.template
COPY ./setup.sh /setup.sh

CMD /bin/bash /setup.sh && exec /usr/bin/supervisord -n -c /etc/supervisord.conf
