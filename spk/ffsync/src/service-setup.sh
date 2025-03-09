
# ffsync service setup
PYTHON_DIR="/var/packages/python312/target/bin"
PATH="${SYNOPKG_PKGDEST}/env/bin:${SYNOPKG_PKGDEST}/bin:${PYTHON_DIR}:${PATH}"

MARIADB_10_INSTALL_DIRECTORY="/var/packages/MariaDB10"
MARIADB_10_BIN_DIRECTORY="${MARIADB_10_INSTALL_DIRECTORY}/target/usr/local/mariadb10/bin"
MYSQL="${MARIADB_10_BIN_DIRECTORY}/mysql"
MYSQLDUMP="${MARIADB_10_BIN_DIRECTORY}/mysqldump"

PYTHON="${SYNOPKG_PKGDEST}/env/bin/python3"
SYNCSERVER="${SYNOPKG_PKGDEST}/bin/syncserver"
DIESEL="${SYNOPKG_PKGDEST}/bin/diesel"
CFG_FILE="${SYNOPKG_PKGVAR}/local.toml"

SERVICE_COMMAND="${SYNCSERVER} --config=${CFG_FILE}"
SVC_BACKGROUND=y
SVC_WRITE_PID=y

# enhance logging
export RUST_LOG=debug
export RUST_BACKTRACE=full

DBUSER=ffsync
DBSERVER="localhost"

percent_encode ()
{
    string="$1"
    result=""
    len=$(echo "$string" | awk '{print length}')
    i=1
    while [ "$i" -le "$len" ]; do
        char=$(echo "$string" | cut -c "$i")
        if echo "$char" | grep -qE '[0-9a-zA-Z]'; then
            result="$result$char"
        else
            result="$result$(printf '%%%02X' "'$char")"
        fi
        i=$((i + 1))
    done
    echo "$result"
}

validate_preinst ()
{
    # Check database
    if [ "${SYNOPKG_PKG_STATUS}" = "INSTALL" ]; then
        if [ -n "${wizard_mysql_password_root}" ]; then
            if ! ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e quit > /dev/null 2>&1; then
                echo "Incorrect MariaDB root password"
                exit 1
            fi
            if ${MYSQL} -u root -p"${wizard_mysql_password_root}" mysql -e "SELECT User FROM user" | grep ^${DBUSER}$ > /dev/null 2>&1; then
                echo "MariaDB user ${DBUSER} already exists"
                exit 1
            fi
            if ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e "SHOW DATABASES" | grep -E '^(syncstorage_rs|tokenserver_rs)$' > /dev/null 2>&1; then
                echo "MariaDB database(s) for ${DBUSER} already exist(s)"
                exit 1
            fi
        fi
    fi
}

service_postinst ()
{
    separator="===================================================="

    echo "Install Python virtual environment"
    install_python_virtualenv

    echo ${separator}
    echo "Install packages from wheelhouse"
    pip install --disable-pip-version-check --no-deps --no-input --no-index "${SYNOPKG_PKGDEST}/share/wheelhouse"/*.whl

    echo ${separator}
    echo "Install pure python packages from index"
    pip install --disable-pip-version-check --no-deps --no-input --requirement "${SYNOPKG_PKGDEST}/share/wheelhouse/requirements-pure.txt"


    if [ "${SYNOPKG_PKG_STATUS}" = "INSTALL" ]; then
        # Generate database password for database user
        DBPASS_RAW=$(tr -dc 'a-zA-Z0-9!@#$%^&*()_+{}<>?=' </dev/urandom | fold -w 10 | grep -E '[a-z]' | grep -E '[A-Z]' | grep -E '[0-9]' | grep -E '[!@#$%^&*()_+{}<>?=]' | head -n 1)
        DBPASS_ENC=$(percent_encode "$DBPASS_RAW")
    
        echo ${separator}
        echo "Set up the databases"
        # login as root sql user using whatever creds you set up for that
        # this sets up a user for sync storage and sets up the databases
        ${MYSQL} -u root -p"${wizard_mysql_password_root}" <<EOF
CREATE USER "${DBUSER}"@"localhost" IDENTIFIED BY "${DBPASS_RAW}";
CREATE DATABASE syncstorage_rs;
CREATE DATABASE tokenserver_rs;
GRANT ALL PRIVILEGES on syncstorage_rs.* to ${DBUSER}@localhost;
GRANT ALL PRIVILEGES on tokenserver_rs.* to ${DBUSER}@localhost;
EOF

        echo ${separator}
        echo "Run database migrations"

        echo "Run migrations for syncstorage_rs"
        ${DIESEL} --database-url "mysql://${DBUSER}:${DBPASS_ENC}@${DBSERVER}/syncstorage_rs" \
            migration --migration-dir "${SYNOPKG_PKGDEST}/syncstorage-mysql/migrations" run

        echo "Run migrations for tokenserver_rs"
        ${DIESEL} --database-url "mysql://${DBUSER}:${DBPASS_ENC}@${DBSERVER}/tokenserver_rs" \
            migration --migration-dir "${SYNOPKG_PKGDEST}/tokenserver-db/migrations" run

        echo ${separator}
        echo "Add sync endpoint to database"
        ${MYSQL} -u ${DBUSER} -p"${DBPASS_RAW}" <<EOF
USE tokenserver_rs
INSERT INTO services (id, service, pattern) VALUES
    (1, "sync-1.5", "{node}/1.5/{uid}");
EOF

        echo "Add syncserver node"
        ${MYSQL} -u ${DBUSER} -p"${DBPASS_RAW}" <<EOF
USE tokenserver_rs
INSERT INTO nodes (id, service, node, available, current_load, capacity, downed, backoff) VALUES
    (1, 1, "${wizard_ffsync_public_url}", 1, 0, 4, 0, 0);
EOF

        echo ${separator}
        echo "Setup syncserver config file"

        MASTER_SECRET="$(tr -dc 'A-Z0-9' < /dev/urandom | head -c64)"
        METRICS_HASH_SECRET="$(tr -dc 'A-Z0-9' < /dev/urandom | head -c64)"

        # Perform replacements using sed with | as the delimiter
        sed -e "s|{{MASTER_SECRET}}|${MASTER_SECRET}|g"             \
            -e "s|{{TCP_PORT}}|${SERVICE_PORT}|g"                   \
            -e "s|{{SQL_USER}}|${DBUSER}|g"                         \
            -e "s|{{SQL_PASS}}|${DBPASS_ENC}|g"                     \
            -e "s|{{DB_SERVER}}|${DBSERVER}|g"                      \
            -e "s|{{METRICS_HASH_SECRET}}|${METRICS_HASH_SECRET}|g" \
            -i "${CFG_FILE}"
    fi
}

validate_preuninst ()
{
    # Check database
    if [ "${SYNOPKG_PKG_STATUS}" = "UNINSTALL" ] && ! ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e quit > /dev/null 2>&1; then
        echo "Incorrect MariaDB root password"
        exit 1
    fi
    # Check if database export path is specified
    if [ "${SYNOPKG_PKG_STATUS}" = "UNINSTALL" ] && [ -n "${wizard_dbexport_path}" ]; then
        if [ ! -d "${wizard_dbexport_path}" ]; then
            # If the export path directory does not exist, create it
            mkdir -p "${wizard_dbexport_path}" || {
                # If mkdir fails, print an error message and exit
                echo "Error: Unable to create directory ${wizard_dbexport_path}. Check permissions."
                exit 1
            }
        elif [ ! -w "${wizard_dbexport_path}" ]; then
            # If the export path directory is not writable, print an error message and exit
            echo "Error: Unable to write to directory ${wizard_dbexport_path}. Check permissions."
            exit 1
        fi
        if [ -e "$wizard_dbexport_path/syncstorage_rs.sql" ] || [ -e "$wizard_dbexport_path/tokenserver_rs.sql" ]; then
            # If either syncstorage_rs.sql or tokenserver_rs.sql already exists, print an error message and exit
            echo "File syncstorage_rs.sql or tokenserver_rs.sql already exists in ${wizard_dbexport_path}. Please remove or choose a different location"
            exit 1
        fi
        # If everything is okay, perform database dumps
        ${MYSQLDUMP} -u root -p"${wizard_mysql_password_root}" syncstorage_rs > "${wizard_dbexport_path}/syncstorage_rs.sql"
        ${MYSQLDUMP} -u root -p"${wizard_mysql_password_root}" tokenserver_rs > "${wizard_dbexport_path}/tokenserver_rs.sql"
    fi
}

service_postuninst ()
{
    # Export and remove database
    if [ "${SYNOPKG_PKG_STATUS}" = "UNINSTALL" ]; then
        ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e "DROP DATABASE syncstorage_rs; DROP DATABASE tokenserver_rs; DROP USER '${DBUSER}'@'localhost';"
    fi
}
