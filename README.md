## Installation

## Starting

The home directory of the sogo user is `/var/lib/sogo` so you may want to
mount it in from the host or a data volume. Make sure the permissions
are correct (user sogo).

### Mysql

Start sogo mysql:

```sh
docker run -ti -d \
	--name=sogo-mysql \
	-e MYSQL_PASS=<mysql_admin_pass> \
	-v <mysql-data-on-host>:/var/lib/mysql \
	mosaiksoftware/gentoo-mysql
```

Create sogo database:

```sh
docker exec -ti \
	sogo-mysql \
	/bin/bash -c "\
		mysql -u root -e \"CREATE DATABASE sogo CHARSET='UTF8';\" && \
		mysql -u root -e \"GRANT ALL PRIVILEGES ON sogo.* TO 'sogo'@'%' IDENTIFIED BY '<sogo-db-pw>';\" && \
		mysql -u root -D sogo -e 'CREATE TABLE sogo_users (c_uid VARCHAR(10) PRIMARY KEY, c_name VARCHAR(10), c_password VARCHAR(32), c_cn VARCHAR(128), mail VARCHAR(128));'"
```

Create a sogo user:
```sh
docker exec -ti \
	sogo-mysql \
	/bin/bash -c "\
		mysql -u root -D sogo -e \"INSERT INTO sogo_users VALUES ('paul', 'paul', MD5('zxc'), 'Paul Example', 'paul@example.com');\""
```

The password (`zxc` here) must match your IMAP password.

### Sogo

Start sogo, e.g.:
```sh
docker run -ti -d \
	--name=sogo \
	--link sogo-mysql:sogo-mysql \
	-v <host-folder>:/var/lib/sogo \
	-e SOGO_DB_HOST=mysql://sogo:<sogo-db-pw>@sogo-mysql:3306 \
	-e SOGO_IMAPHOST=imap://<imaphost> \
	-p 80:80 \
	mosaiksoftware/gentoo-sogo
```
