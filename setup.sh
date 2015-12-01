#!/bin/bash

# SETUP SOGO FOR DATABASE SERVER

sogo_dbhost=${SOGO_DB_HOST:-mysql\://sogo\:sogo@sogo-mysql\:3306}
sogo_timezone=${SOGO_TIMEZONE:-Europe/Amsterdam}

# IMAP SERVER SETUP - WILL AUTHENTICATE AGAINS IT
sogo_imaphost=${SOGO_IMAPHOST:-imap://localhost}



sed -e "s;\[\[SOGO_DB_HOST\]\];$sogo_dbhost;g" \
 -e "s;\[\[SOGO_TIMEZONE\]\];$sogo_timezone;g" \
 -e "s;\[\[SOGO_IMAP_HOST\]\];$sogo_imaphost;g" \
 /etc/sogo/sogo.conf.template > /etc/sogo/sogo.conf

