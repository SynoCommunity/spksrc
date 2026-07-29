# ownCloud

[ownCloud](https://owncloud.com/) is a file sync and share platform.

## Default Login Credentials

After installing from SynoCommunity:

- **Username**: `admin`
- **Password**: `admin`

!!! warning
    Change these credentials immediately after logging in.

## Using the `occ` Command

The `occ` command (ownCloud console) is a powerful command-line tool for administrative tasks.

### 1. Enable SSH

Ensure SSH is enabled on your DiskStation. See [FAQ-ssh](dsm-utilities.md) for instructions.

### 2. Define Shortcuts

```bash
oc_php=/usr/local/bin/php74
```

**For DSM 6:**
```bash
oc_occ=/var/services/web/owncloud/occ
oc_usr=http
```

**For DSM 7:**
```bash
oc_occ=/var/services/web_packages/owncloud/occ
oc_usr=sc-owncloud
```

### 3. Run `occ` Commands

```bash
sudo -u $oc_usr $oc_php $oc_occ --version
```

Replace `--version` with any other `occ` command you need to run.

## Files Not in Sync

If your files are not updating correctly in the Files view after modifying them outside of the web interface (e.g., via WebDAV), ownCloud may not be detecting changes automatically.

### Fix Steps

1. Set up `occ` as described above

2. Enable maintenance mode:
```bash
sudo -u $oc_usr $oc_php $oc_occ maintenance:mode --on
```

3. Adjust filesystem change detection:
```bash
sudo -u $oc_usr $oc_php $oc_occ config:system:set --type=integer filesystem_check_changes --value 1
```

4. Disable maintenance mode:
```bash
sudo -u $oc_usr $oc_php $oc_occ maintenance:mode --off
```

## Database Migration (SQLite to MariaDB)

Starting with version 10.15.0, the ownCloud package transitions from SQLite to MariaDB back-end. This includes optimized configurations to eliminate all warnings in the settings screen.

### Prerequisites

1. Install `redis` from the SynoCommunity repository
2. Enable SSH and connect to your DiskStation

### Setup Shortcuts

```bash
oc_php=/usr/local/bin/php74
oc_sql=/usr/local/mariadb10/bin/mysql
```

**For DSM 6:**
```bash
oc_home=/var/services/web/owncloud
oc_occ=/var/services/web/owncloud/occ
oc_usr=http
```

**For DSM 7:**
```bash
oc_home=/var/services/web_packages/owncloud
oc_occ=/var/services/web_packages/owncloud/occ
oc_usr=sc-owncloud
```

### Migration Steps

1. Save your MySQL root password:
```bash
oc_rpwd=[your MySQL root password]
```

2. Set a random password for the database user:
```bash
oc_upwd=$(LC_ALL=C tr -dc 'A-Za-z0-9:@.,/+!=-' </dev/urandom | head -c 30; echo)
```

3. Enable maintenance mode:
```bash
sudo -u $oc_usr $oc_php $oc_occ maintenance:mode --on
```

4. Add HSTS to Apache configuration:
```bash
sudo tee -a $oc_home/.htaccess > /dev/null <<EOF
<IfModule mod_headers.c>
Header always set Strict-Transport-Security "max-age=15552000; includeSubDomains"
</IfModule>
EOF
sudo chown $oc_usr $oc_home/.htaccess
```

5. Prepare for migration:
```bash
sudo -u $oc_usr $oc_php $oc_occ config:system:set mysql.utf8mb4 --value=true
```

6. Open MariaDB 10 in DSM and enable the TCP/IP connection

7. Create a new MySQL database:
```bash
$oc_sql -u root -p$oc_rpwd -e "create database owncloud; grant all privileges on owncloud.* to 'oc_admin'@'localhost' identified by '$oc_upwd';"
```

8. Disable maintenance mode:
```bash
sudo -u $oc_usr $oc_php $oc_occ maintenance:mode --off
```

9. Perform the database conversion:

**For DSM 6:**
```bash
sudo -u $oc_usr $oc_php $oc_occ db:convert-type --port=3307 --password=$oc_upwd --all-apps mysql oc_admin 127.0.0.1 owncloud
```

**For DSM 7:**
```bash
sudo -u $oc_usr $oc_php $oc_occ db:convert-type --password=$oc_upwd --all-apps mysql oc_admin 127.0.0.1 owncloud
```

10. Continue with memory caching and file locking configuration:
```bash
sudo -u $oc_usr $oc_php $oc_occ config:system:set memcache.local --value="\OC\Memcache\APCu"
sudo -u $oc_usr $oc_php $oc_occ config:system:set memcache.locking --value="\OC\Memcache\Redis"
sudo -u $oc_usr $oc_php $oc_occ config:system:set filelocking.enabled --value true
```

11. Set up background jobs:
```bash
sudo -u $oc_usr $oc_php $oc_occ system:cron
```

!!! note
    After upgrading to ownCloud version 10.15.0, you may encounter login issues with messages such as "You took too long to login, please try again." To resolve this, clear your browser's cache for cookies and site data.
