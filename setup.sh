#!/bin/bash

# SETUP SOGO FOR DATABASE SERVER

sogo_dbhost=${$SOGO_DB_HOST:-mysql\://sogo\:sogo@sogo-mysql:3306}
sogo_timezone=$($SOGO_TIMEZONE:-Europe/Amsterdam)

sed -e "s/\[\[SOGO_DB_HOST\]\]/$sogo_dbhost/g" /etc/sogo/sogo.conf.template \
 -e "s/\[\[SOGO_TIMEZONE\]\]/$sogo_timezone/g" /etc/sogo/sogo.conf.template > /etc/sogo/sogo.conf

