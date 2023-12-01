PYTHON_DIR="/var/packages/python311/target/bin"
PATH="${SYNOPKG_PKGDEST}/env/bin:${SYNOPKG_PKGDEST}/bin:${PYTHON_DIR}:${PATH}"

MARIADB_10_INSTALL_DIRECTORY="/var/packages/MariaDB10"
MARIADB_10_BIN_DIRECTORY="${MARIADB_10_INSTALL_DIRECTORY}/target/usr/local/mariadb10/bin"
MYSQL="${MARIADB_10_BIN_DIRECTORY}/mysql"

PYTHON="${SYNOPKG_PKGDEST}/env/bin/python3"
SYNCSERVER="${SYNOPKG_PKGDEST}/bin/syncserver"
DIESEL="${SYNOPKG_PKGDEST}/bin/diesel"
CFG_FILE="${SYNOPKG_PKGVAR}/local.toml"

SERVICE_COMMAND="${SYNCSERVER} --config=${CFG_FILE}"

DBUSER=ffsync

validate_preinst ()
{
    # Check MySQL database
    if [ "${SYNOPKG_PKG_STATUS}" = "INSTALL" ]; then
        if [ -n "${wizard_mysql_password_root}" ]; then
            if ! ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e quit > /dev/null 2>&1; then
                echo "Incorrect MySQL root password"
                exit 1
            fi
            if ${MYSQL} -u root -p"${wizard_mysql_password_root}" mysql -e "SELECT User FROM user" | grep ^${DBUSER}$ > /dev/null 2>&1; then
                echo "MySQL user ${DBUSER} already exists"
                exit 1
            fi
            if ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e "SHOW DATABASES" | grep -E '^(syncstorage_rs|tokenserver_rs)$' > /dev/null 2>&1; then
                echo "MySQL database(s) for ${DBUSER} already exist(s)"
                exit 1
            fi
        fi
    fi
}

service_postinst ()
{
    # Create a Python virtualenv
    install_python_virtualenv

    # Install wheels
    install_python_wheels

    if [ "${SYNOPKG_PKG_STATUS}" = "INSTALL" ]; then
        # login as root sql user using whatever creds you set up for that
        # this sets up a user for sync storage and sets up the databases
        ${MYSQL} -u root -p"${wizard_mysql_password_root}" <<EOF
CREATE USER "${DBUSER}"@"localhost" IDENTIFIED BY "${wizard_password_ffsync}";
CREATE DATABASE syncstorage_rs;
CREATE DATABASE tokenserver_rs;
GRANT ALL PRIVILEGES on syncstorage_rs.* to ${DBUSER}@localhost;
GRANT ALL PRIVILEGES on tokenserver_rs.* to ${DBUSER}@localhost;
EOF

        # Run initial database migrations
        # syncstorage db initialization
        ${DIESEL} --database-url "mysql://${DBUSER}:${wizard_password_ffsync}@localhost/syncstorage_rs" \
            migration --migration-dir syncstorage-mysql/migrations run
        # tokenserver db initialization
        ${DIESEL} --database-url "mysql://${DBUSER}:${wizard_password_ffsync}@localhost/tokenserver_rs" \
            migration --migration-dir tokenserver-db/migrations run

        # Add sync endpoint to database
        ${MYSQL} -u ${SPK_NAME} -p"${wizard_password_ffsync}" <<EOF
        ${MYSQL} -u ${DBUSER} -p"$(wizard_password_ffsync)" <<EOF
USE tokenserver_rs
INSERT INTO services (id, service, pattern) VALUES
    (1, "sync-1.5", "{node}/1.5/{uid}");
EOF

        # Add syncserver node
        # the 10 is the user capacity.
        SYNC_TOKENSERVER__DATABASE_URL="mysql://${DBUSER}:${wizard_password_ffsync}@localhost/tokenserver_rs" \
            python3 tools/tokenserver/add_node.py \
            ${wizard_ffsync_public_url} 10

        # Setup syncserver config file
        MASTER_SECRET="$(cat /dev/urandom | base32 | head -c64)"
        METRICS_HASH_SECRET="$(cat /dev/urandom | base32 | head -c64)"

        # Escape vertical bars in the replacement values
        WIZARD_PASSWORD=$(echo "${wizard_password_ffsync}" | sed 's/|/\\|/g')

        # Perform replacements using sed with | as the delimiter
        sed -e "s|{{MASTER_SECRET}}|${MASTER_SECRET}|g"             \
            -e "s|{{TCP_PORT}}|${SERVICE_PORT}|g"                   \
            -e "s|{{SQL_USER}}|${DBUSER}|g"                         \
            -e "s|{{SQL_PASS}}|${WIZARD_PASSWORD}|g"                \
            -e "s|{{METRICS_HASH_SECRET}}|${METRICS_HASH_SECRET}|g" \
            -i "${CFG_FILE}"
    fi
}
