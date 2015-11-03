## Installation

```sh
docker build -t hasufell/gentoo-sogo .
docker pull hasufell/gentoo-mysql:latest
```

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
	hasufell/gentoo-mysql
```

Create sogo database:

```sh
docker exec -ti \
	sogo-mysql \
	/bin/bash -c "\
		mysql -u root -e \"CREATE DATABASE sogo CHARSET='UTF8';\" && \
		mysql -u root -e \"GRANT ALL PRIVILEGES ON sogo.* TO 'sogo'@'%' IDENTIFIED BY '<sogo-pw>';\" && \
		mysql -u root -D sogo -e 'CREATE TABLE sogo_users (c_uid VARCHAR(10) PRIMARY KEY, c_name VARCHAR(10), c_password VARCHAR(32), c_cn VARCHAR(128), mail VARCHAR(128));'"
```

Create a sogo user:
```sh
docker exec -ti \
	sogo-mysql \
	/bin/bash -c "\
		mysql -u root -D sogo -e \"INSERT INTO sogo_users VALUES ('paul', 'paul', MD5('zxc'), 'Paul Example', 'paul@example.com');\""
```

### Sogo

Start sogo:
```sh
docker run -ti -d \
	--name=sogo \
	--link sogo-mysql:sogo-mysql \
	-v <host-folder>:/var/lib/sogo \
	-p 80:80 \
	hasufell/gentoo-sogo
```

Tell sogo to use mysql:

```sh
docker exec -ti \
	sogo \
	/bin/bash -c "\
		sudo -u sogo defaults write sogod SOGoUserSources '({canAuthenticate = YES; displayName = "SOGo Users"; id = users; isAddressBook = YES; type = sql; userPasswordAlgorithm = md5; viewURL ="mysql://sogo:<sogopw>@sogo-mysql:3306/sogo/sogo_users";})'
		sudo -u sogo defaults write sogod OCSFolderInfoURL \"mysql://sogo:<sogopw>@sogo-mysql:3306/sogo/sogo_folder_info\" && \
		sudo -u sogo defaults write sogod SOGoProfileURL \"mysql://sogo:<sogopw>@sogo-mysql:3306/sogo/sogo_user_profile\" && \
		sudo -u sogo defaults write sogod OCSSessionsFolderURL \"mysql://sogo:<sogopw>@sogo-mysql:3306/sogo/sogo_sessions_folder\""
```

Configure other sogo stuff:

```sh
docker exec -ti \
	sogo \
	/bin/bash -c "sudo -u sogo defaults write sogod SOGoTimeZone \"Europe/Amsterdam\""
```

Maybe you have to restart the sogo container after these changes.
