
# Package
PACKAGE="tt-rss"
SVC_KEEP_LOG=y
SVC_BACKGROUND=y
SVC_WRITE_PID=y

WEB_DIR="/var/services/web_packages"
LOGS_DIR="${WEB_DIR}/${PACKAGE}/logs"

PHP="/usr/local/bin/php82"
TTRSS="${WEB_DIR}/${PACKAGE}/update.php"

# PostgreSQL connection settings
PG_HOST="localhost"
PG_PORT="${wizard_pg_port}"
PG_ADMIN_USER="${wizard_pg_username_admin}"
PG_ADMIN_PASS="${wizard_pg_password_admin}"
PG_USER="ttrss"
PG_DATABASE="ttrss"
PG_PSQL="/usr/local/bin/psql"
PG_PGDUMP="/usr/local/bin/pg_dump"

# Run tt-rss database schema migrations
exec_update_schema() {
    "${PHP}" "${TTRSS}" --update-schema=force-yes
}

# Create PostgreSQL user and database for tt-rss
create_pg_user_db() {
    PGPASSWORD="${PG_ADMIN_PASS}" ${PG_PSQL} -h "${PG_HOST}" -p "${PG_PORT}" -U "${PG_ADMIN_USER}" -d postgres -c "CREATE USER ${PG_USER} WITH PASSWORD '${wizard_pg_password_ttrss}';" 2>/dev/null || true
    PGPASSWORD="${PG_ADMIN_PASS}" ${PG_PSQL} -h "${PG_HOST}" -p "${PG_PORT}" -U "${PG_ADMIN_USER}" -d postgres -c "CREATE DATABASE ${PG_DATABASE} OWNER ${PG_USER};" 2>/dev/null || true
}

# Clean up old MariaDB database after migration
cleanup_mariadb() {
    echo "Cleaning up old MariaDB database..."
    MYSQL_BIN="/usr/local/mariadb10/bin/mysql"
    if [ -x "${MYSQL_BIN}" ]; then
        "${MYSQL_BIN}" -u root -p"${wizard_mysql_password_root}" -e "DROP DATABASE IF EXISTS ttrss;" && echo "MariaDB database 'ttrss' dropped."
        "${MYSQL_BIN}" -u root -p"${wizard_mysql_password_root}" -e "DROP USER IF EXISTS 'ttrss'@'localhost';" && echo "MariaDB user 'ttrss' dropped."
    fi
}

# Start tt-rss update daemon
service_prestart ()
{
    LOG_FILE="${LOGS_DIR}/daemon.log"
    "${PHP}" "${TTRSS}" --daemon >> "${LOG_FILE}" 2>&1 &
    echo "$!" > "${PID_FILE}"
}

# Post-installation tasks
service_postinst ()
{
    ${MKDIR} "${LOGS_DIR}"

    if [ "${SYNOPKG_PKG_STATUS}" = "INSTALL" ]; then
        # Create PostgreSQL user and database
        create_pg_user_db
        
        # Generate config.php from template
        single_user_mode=$([ "${wizard_single_user}" = "true" ] && echo "true" || echo "false")
        ${CP} "${WEB_DIR}/${PACKAGE}/config.php-dist" "${WEB_DIR}/${PACKAGE}/config.php"
        {
            echo "putenv('TTRSS_DB_TYPE=pgsql');"
            echo "putenv('TTRSS_DB_HOST=${PG_HOST}');"
            echo "putenv('TTRSS_DB_PORT=${PG_PORT}');"
            echo "putenv('TTRSS_DB_USER=${PG_USER}');"
            echo "putenv('TTRSS_DB_NAME=${PG_DATABASE}');"
            echo "putenv('TTRSS_DB_PASS=${wizard_pg_password_ttrss}');"
            echo "putenv('TTRSS_SINGLE_USER_MODE=${single_user_mode}');"
            echo "putenv('TTRSS_SELF_URL_PATH=http://${wizard_domain_name}/${PACKAGE}/');"
            echo "putenv('TTRSS_PHP_EXECUTABLE=${PHP}');"
        } >>"${WEB_DIR}/${PACKAGE}/config.php"
        exec_update_schema
    fi

    if [ "${SYNOPKG_PKG_STATUS}" = "UPGRADE" ]; then
        # Ensure PostgreSQL user and database exist for upgrades
        create_pg_user_db
        exec_update_schema
    fi

    return 0
}

# Validate PostgreSQL connection before installation
validate_preinst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" = "INSTALL" ]; then
        PGPASSWORD="${PG_ADMIN_PASS}" ${PG_PSQL} -h "${PG_HOST}" -p "${PG_PORT}" -U "${PG_ADMIN_USER}" -d postgres -c "SELECT 1" >/dev/null 2>&1
        PG_RESULT=$?
        if [ ${PG_RESULT} -ne 0 ]; then
            PG_ERROR=$(PGPASSWORD="${PG_ADMIN_PASS}" ${PG_PSQL} -h "${PG_HOST}" -p "${PG_PORT}" -U "${PG_ADMIN_USER}" -d postgres -c "SELECT 1" 2>&1)
            if echo "${PG_ERROR}" | grep -qi "password\|authentication\|FATAL"; then
                echo "PostgreSQL authentication failed. Please check your username and password."
            else
                echo "PostgreSQL is not running or not accessible. Please ensure PostgreSQL package is installed and running."
            fi
            exit 1
        fi
    fi
}

# Validate PostgreSQL and MariaDB connections before upgrade
validate_preupgrade ()
{
    # Only validate if upgrading from MariaDB version (rev < 21)
    SPK_REV="${SYNOPKG_OLD_PKGVER//[0-9]*-/}"
    if [ -n "$SPK_REV" ] && [ "$SPK_REV" -lt 21 ] 2>/dev/null; then
        if [ -n "${wizard_mysql_password_root}" ]; then
            MYSQL_BIN="/usr/local/mariadb10/bin/mysql"
            if [ -x "${MYSQL_BIN}" ]; then
                "${MYSQL_BIN}" -u root -p"${wizard_mysql_password_root}" -e "SELECT 1" >/dev/null 2>&1
                MYSQL_RESULT=$?
                if [ ${MYSQL_RESULT} -ne 0 ]; then
                    echo "MariaDB authentication failed. Please check your MariaDB root password."
                    exit 1
                fi
            fi
        fi

        PGPASSWORD="${PG_ADMIN_PASS}" ${PG_PSQL} -h "${PG_HOST}" -p "${PG_PORT}" -U "${PG_ADMIN_USER}" -d postgres -c "SELECT 1" >/dev/null 2>&1
        PG_RESULT=$?
        if [ ${PG_RESULT} -ne 0 ]; then
            PG_ERROR=$(PGPASSWORD="${PG_ADMIN_PASS}" ${PG_PSQL} -h "${PG_HOST}" -p "${PG_PORT}" -U "${PG_ADMIN_USER}" -d postgres -c "SELECT 1" 2>&1)
            if echo "${PG_ERROR}" | grep -qi "password\|authentication\|FATAL"; then
                echo "PostgreSQL authentication failed. Please check your username and password."
            else
                echo "PostgreSQL is not running or not accessible."
            fi
            exit 1
        fi
    fi
}

# Validate PostgreSQL connection and export path before uninstall
validate_preuninst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" = "UNINSTALL" ]; then
        # Test PostgreSQL admin connection
        PGPASSWORD="${PG_ADMIN_PASS}" ${PG_PSQL} -h "${PG_HOST}" -p "${PG_PORT}" -U "${PG_ADMIN_USER}" -d postgres -c "SELECT 1" >/dev/null 2>&1
        PG_RESULT=$?
        if [ ${PG_RESULT} -ne 0 ]; then
            PG_ERROR=$(PGPASSWORD="${PG_ADMIN_PASS}" ${PG_PSQL} -h "${PG_HOST}" -p "${PG_PORT}" -U "${PG_ADMIN_USER}" -d postgres -c "SELECT 1" 2>&1)
            if echo "${PG_ERROR}" | grep -qi "password\|authentication\|FATAL"; then
                echo "PostgreSQL admin authentication failed. Please check your username and password."
            else
                echo "PostgreSQL is not running or not accessible."
            fi
            exit 1
        fi

        # Test ttrss database connection for export (only if export path is provided)
        if [ -n "${wizard_dbexport_path}" ]; then
            PGPASSWORD="${wizard_pg_password_ttrss}" ${PG_PSQL} -h "${PG_HOST}" -p "${PG_PORT}" -U "${PG_USER}" -d "${PG_DATABASE}" -c "SELECT 1" >/dev/null 2>&1
            PG_RESULT=$?
            if [ ${PG_RESULT} -ne 0 ]; then
                echo "PostgreSQL ttrss database authentication failed. Please check your database user password."
                exit 1
            fi
        fi

        # Validate export path if provided
        if [ -n "${wizard_dbexport_path}" ]; then
            if [ -e "${wizard_dbexport_path}/${PG_DATABASE}.sql" ]; then
                echo "File ${wizard_dbexport_path}/${PG_DATABASE}.sql already exists. Please choose a different location or remove the existing file."
                exit 1
            fi

            if [ -d "${wizard_dbexport_path}" ]; then
                if [ ! -w "${wizard_dbexport_path}" ]; then
                    echo "Directory ${wizard_dbexport_path} is not writable. Please check permissions."
                    exit 1
                fi
            else
                parent_dir="$(dirname "${wizard_dbexport_path}")"
                if [ ! -w "${parent_dir}" ]; then
                    echo "Cannot create directory ${wizard_dbexport_path}. Please check permissions on ${parent_dir}."
                    exit 1
                fi
            fi
        fi
    fi
}

# Export PostgreSQL database before uninstall
service_preuninst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" = "UNINSTALL" ]; then
        if [ -n "${wizard_dbexport_path}" ]; then
            ${MKDIR} "${wizard_dbexport_path}"
            PGPASSWORD="${wizard_pg_password_ttrss}" ${PG_PGDUMP} -h "${PG_HOST}" -p "${PG_PORT}" -U "${PG_USER}" -d "${PG_DATABASE}" -f "${wizard_dbexport_path}/${PG_DATABASE}.sql"
        fi
    fi  
}

# Save app data before upgrade
service_save ()
{
    # Save config file
    ${MKDIR} "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE}"
    ${CP} "${WEB_DIR}/${PACKAGE}/config.php" "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE}/"

    # Save feed icons
    ${MKDIR} "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE}/feed-icons/"
    ${CP} "${WEB_DIR}/${PACKAGE}/feed-icons"/*.ico "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE}/feed-icons/" 2>/dev/null

    # Save plugins and themes
    ${CP} "${WEB_DIR}/${PACKAGE}/plugins.local" "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE}/" 2>/dev/null
    ${CP} "${WEB_DIR}/${PACKAGE}/themes.local" "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE}/" 2>/dev/null

    # Save feed icons cache
    ${MKDIR} "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE}/cache/feed-icons/"
    ${CP} "${WEB_DIR}/${PACKAGE}/cache/feed-icons"/* "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE}/cache/feed-icons/" 2>/dev/null

    # For MariaDB to PostgreSQL migration (rev < 21): export OPML feeds and user list
    OLD_SPK_REV=$(echo "${SYNOPKG_OLD_PKGVER}" | sed -r "s/^.*-([0-9]+)$/\1/" 2>/dev/null || echo "0")
    if [ "${OLD_SPK_REV}" -lt 21 ] 2>/dev/null; then
        if [ -f "${WEB_DIR}/${PACKAGE}/config.php" ] && [ -f "${WEB_DIR}/${PACKAGE}/update.php" ]; then
            OPML_DIR="${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE}/feeds"
            USERS_DIR="${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE}/users"
            ${MKDIR} "${OPML_DIR}"
            ${MKDIR} "${USERS_DIR}"
            # Export user list for recreation during restore
            TTRSS_USERS=$("${PHP}" "${WEB_DIR}/${PACKAGE}/update.php" --user-list 2>/dev/null | tail -n +2 | awk '{print $2}')
            echo "${TTRSS_USERS}" | tr ' ' '\n' > "${USERS_DIR}/userlist.txt"
            # Export OPML for each user
            for TTRSS_USER in ${TTRSS_USERS}; do
                OPML_FILE="${OPML_DIR}/${TTRSS_USER}.opml"
                "${PHP}" "${WEB_DIR}/${PACKAGE}/update.php" --opml-export "${TTRSS_USER}:${OPML_FILE}" 2>&1 | head -3 || true
            done
        fi
    fi

    return 0
}

# Restore app data after upgrade
service_restore ()
{
    ${CP} "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE}/config.php" "${WEB_DIR}/${PACKAGE}/config.php"
    OLD_SPK_REV=$(echo "${SYNOPKG_OLD_PKGVER}" | sed -r "s/^.*-([0-9]+)$/\1/" 2>/dev/null || echo "0")

    # Migrate MariaDB config to PostgreSQL
    if [ "${OLD_SPK_REV}" -lt 21 ]; then
        sed -i -e "s|mysql|postgres|g" \
               -e "s|putenv('TTRSS_DB_TYPE=mysql');|putenv('TTRSS_DB_TYPE=pgsql');|" \
               -e "s|putenv('TTRSS_DB_TYPE=mariadb');|putenv('TTRSS_DB_TYPE=pgsql');|" \
               -e "s|mysqld10.sock|${PG_HOST}|g" \
               -e "s|putenv('TTRSS_DB_USER=[^']*');|putenv('TTRSS_DB_USER=${PG_USER}');|" \
               -e "s|putenv('TTRSS_DB_PASS=[^']*');|putenv('TTRSS_DB_PASS=${wizard_pg_password_ttrss}');|" \
            "${WEB_DIR}/${PACKAGE}/config.php"
        if ! grep -q "TTRSS_DB_PORT" "${WEB_DIR}/${PACKAGE}/config.php"; then
            echo "putenv('TTRSS_DB_PORT=${PG_PORT}');">>"${WEB_DIR}/${PACKAGE}/config.php"
        fi
        echo "Database configuration migrated from MySQL/MariaDB to PostgreSQL."
    fi

    # Restore feed icons, plugins, and themes
    ${MV} "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE}"/feed-icons/*.ico "${WEB_DIR}/${PACKAGE}"/feed-icons/ 2>/dev/null
    ${MV} "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE}"/plugins.local/* "${WEB_DIR}/${PACKAGE}"/plugins.local/ 2>/dev/null
    ${MV} "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE}"/themes.local/* "${WEB_DIR}/${PACKAGE}"/themes.local/ 2>/dev/null

    # Restore feed icon cache
    ${MKDIR} "${WEB_DIR}/${PACKAGE}/cache/feed-icons/"
    ${MV} "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE}"/cache/feed-icons/* "${WEB_DIR}/${PACKAGE}"/cache/feed-icons/ 2>/dev/null

    # Run database schema updates
    exec_update_schema

    # Import users and OPML for MariaDB to PostgreSQL migration
    if [ "${OLD_SPK_REV}" -lt 21 ]; then
        USERS_DIR="${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE}/users"
        if [ -f "${USERS_DIR}/userlist.txt" ]; then
            echo "Creating users from migration..."
            while IFS= read -r TTRSS_USER; do
                if [ -n "${TTRSS_USER}" ] && [ "${TTRSS_USER}" != "admin" ]; then
                    # Generate random password (user must reset via web)
                    RANDOM_PASS=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 16)
                    "${PHP}" "${TTRSS}" --user-add "${TTRSS_USER}:${RANDOM_PASS}:0" && echo "Created user '${TTRSS_USER}'. Please reset password via web interface." || echo "Warning: Failed to create user '${TTRSS_USER}'."
                fi
            done < "${USERS_DIR}/userlist.txt"
        fi

        # Import OPML feeds for all users
        OPML_DIR="${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE}/feeds"
        if [ -d "${OPML_DIR}" ]; then
            for OPML_FILE in "${OPML_DIR}"/*.opml; do
                if [ -f "${OPML_FILE}" ]; then
                    USER=$(basename "${OPML_FILE}" .opml)
                    "${PHP}" "${TTRSS}" --opml-import "${USER}:${OPML_FILE}" && echo "OPML feeds imported for user '${USER}'." || echo "Warning: OPML import failed for user '${USER}'."
                fi
            done
        fi

        # Clean up old MariaDB database
        cleanup_mariadb

        # Clean up migration files from temp folder (DSM will sync remaining files to var folder)
        ${RM} "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE}/users"
        ${RM} "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE}/feeds"
    fi

    # Clean up files from temp folder to prevent sync to var folder
    ${RM} "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE}/config.php"
    ${RM} "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE}/cache"
    ${RM} "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE}/feed-icons"
    ${RM} "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE}/plugins.local"
    ${RM} "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE}/themes.local"

    return 0
}

# Drop PostgreSQL database and user on uninstall
service_postuninst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" = "UNINSTALL" ]; then
        PGPASSWORD="${PG_ADMIN_PASS}" ${PG_PSQL} -h "${PG_HOST}" -p "${PG_PORT}" -U "${PG_ADMIN_USER}" -d postgres -c "DROP DATABASE IF EXISTS ${PG_DATABASE};" 2>/dev/null || true
        PGPASSWORD="${PG_ADMIN_PASS}" ${PG_PSQL} -h "${PG_HOST}" -p "${PG_PORT}" -U "${PG_ADMIN_USER}" -d postgres -c "DROP USER IF EXISTS ${PG_USER};" 2>/dev/null || true
    fi
}
