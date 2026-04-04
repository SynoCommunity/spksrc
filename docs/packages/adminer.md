# Adminer

Adminer (formerly phpMinAdmin) is a full-featured database management tool written in PHP.

## Install Dependencies

Adminer requires Apache 2.2 to run properly, and any version of PHP 5 or PHP 7. Select your PHP version according to requirements from your other running PHP applications.

Enable the required PHP Extensions in the default profile according to the database products you want to access (mysql, sqlite, pgsql).

## PostgreSQL Configuration

Synology uses UNIX sockets for PostgreSQL (`TYPE=local`). Here is the default `pg_hba.conf` from DSM:

```
# TYPE  DATABASE        USER            ADDRESS                 METHOD
local   all             postgres                                peer map=pg_root
local   all             all                                     peer
```

There is no need to modify the `pg_hba.conf` file to access PostgreSQL databases. Unix sockets are faster than tcp/ip sockets and more efficient on small NASes.

PostgreSQL uses the client user name (defined in `/etc/passwd`) to authenticate the user (`METHOD=peer`).

More information about `pg_hba.conf` can be found in the [PostgreSQL documentation](https://www.postgresql.org/docs/9.3/static/auth-pg-hba-conf.html).

### Connecting to PostgreSQL

The `postgres` user account has all privileges on PostgreSQL. Use the following to connect:

```bash
sudo -i
su - postgres
psql
```

### PostgreSQL and Web Station

As PHP scripts are executed with the user `http` in Web Station, proper privileges must be set:

```sql
CREATE DATABASE "my_db";
CREATE TABLE "my_table" (id SERIAL PRIMARY KEY, my_field VARCHAR(64) NOT NULL DEFAULT '');
GRANT CONNECT ON DATABASE "my_db" TO http;
\connect "my_db"
GRANT SELECT,INSERT,UPDATE,DELETE ON TABLE "my_table" TO http;
```

Use the following PHP code to connect to your database:

```php
try {
    $pdo = new PDO('pgsql:dbname=my_db');
    // Do your stuff
} catch (\Exception $e) {
    var_dump($e);
}
```
