# Icinga Web 2 service setup

# Set the install path
WEB_ROOT="/var/services/web_packages/icingaweb2"

# MariaDB paths
MYSQL="/usr/local/mariadb10/bin/mysql"

# Database configuration (hardcoded)
DB_NAME="icingaweb2"
DB_USER="icingaweb2"

# Set PHP binary based on DSM version
if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -ge 7 ]; then
    if [ "${SYNOPKG_DSM_VERSION_MINOR}" -ge 2 ]; then
        PHP="/usr/local/bin/php82"
    else
        PHP="/usr/local/bin/php80"
    fi
else
    PHP="/usr/local/bin/php74"
fi

ICINGAWEB2_CONF_DIR="${SYNOPKG_PKGVAR}/etc/icingaweb2"
ICINGA2_API_USER_FILE="/var/packages/icinga2/var/etc/icingaweb2/api-credentials.txt"
ICINGA2_IDO_CRED_FILE="/var/packages/icinga2/var/etc/icingaweb2/ido-credentials.txt"
CONF_TEMPLATES="${SYNOPKG_PKGDEST}/share/templates"

validate_preinst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" = "INSTALL" ]; then
        if ! ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e quit > /dev/null 2>&1; then
            echo "Incorrect MariaDB root password"
            exit 1
        fi
        if ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e "SHOW DATABASES" | grep -q "^${DB_NAME}$"; then
            echo "MariaDB database '${DB_NAME}' already exists"
            exit 1
        fi
        if ${MYSQL} -u root -p"${wizard_mysql_password_root}" mysql -e "SELECT User FROM user" | grep -q "^${DB_USER}$"; then
            echo "MariaDB user '${DB_USER}' already exists"
            exit 1
        fi
    fi
}

service_preuninst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" = "UNINSTALL" ]; then
        if [ -n "${wizard_mysql_password_root}" ]; then
            echo "Removing icingaweb2 database and user"
            ${MYSQL} -u root -p"${wizard_mysql_password_root}" <<EOF 2>/dev/null || true
DROP DATABASE IF EXISTS ${DB_NAME};
DROP USER IF EXISTS '${DB_USER}'@'localhost';
FLUSH PRIVILEGES;
EOF
        fi
    fi
}

setup_icingaweb2_database ()
{
    echo "Creating icingaweb2 database and user"
    ${MYSQL} -u root -p"${wizard_mysql_password_root}" <<EOF
CREATE DATABASE ${DB_NAME} CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASS}';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'localhost';
FLUSH PRIVILEGES;
EOF
}

import_icingaweb2_schema ()
{
    echo "Importing Icinga Web 2 database schema"
    local SCHEMA_FILE="${SYNOPKG_PKGDEST}/share/icingaweb2/schema/mysql.schema.sql"
    if [ -f "${SCHEMA_FILE}" ]; then
        ${MYSQL} -u "${DB_USER}" -p"${DB_PASS}" "${DB_NAME}" < "${SCHEMA_FILE}"
    fi
}

create_admin_user ()
{
    echo "Creating administrator user '${wizard_admin_user}'"
    ICINGAWEB_CONFIGDIR="${SYNOPKG_PKGVAR}/etc/icingaweb2" \
    ICINGAWEB_LIBDIR="${SYNOPKG_PKGDEST}/share/icinga-php" \
    ${PHP} "${SYNOPKG_PKGDEST}/share/create-admin.php" "${wizard_admin_user}" "${wizard_admin_pass}"
    local exit_code=$?
    echo "create-admin.php exit code: $exit_code"
    if [ $exit_code -ne 0 ]; then
        echo "WARNING: create-admin.php exited with code $exit_code"
    fi
}

service_postinst ()
{
    # Database password (from wizard) - must be set before use
    DB_PASS="${wizard_db_pass}"

    if [ "${SYNOPKG_PKG_STATUS}" = "INSTALL" ]; then
        setup_icingaweb2_database
        import_icingaweb2_schema
    fi

    # Create Icinga Web 2 storage directory
    ICINGAWEB2_STORAGE_DIR="${SYNOPKG_PKGVAR}/storage"
    mkdir -p "${ICINGAWEB2_STORAGE_DIR}"
    chmod 2770 "${ICINGAWEB2_STORAGE_DIR}"
    chown sc-icingaweb2:http "${ICINGAWEB2_STORAGE_DIR}"

    # Create configuration directory structure
    mkdir -p "${ICINGAWEB2_CONF_DIR}"
    mkdir -p "${ICINGAWEB2_CONF_DIR}/modules/monitoring"
    mkdir -p "${ICINGAWEB2_CONF_DIR}/enabledModules"

    # Create log directory
    mkdir -p "${SYNOPKG_PKGVAR}/log"

    # Get IDO database credentials from icinga2 package
    IDO_DB_NAME="icinga_ido"
    IDO_DB_USER="icinga2"
    IDO_DB_PASS=""
    if [ -f "${ICINGA2_IDO_CRED_FILE}" ]; then
        IDO_DB_NAME=$(grep "^Database:" "${ICINGA2_IDO_CRED_FILE}" | cut -d: -f2 | tr -d ' ')
        IDO_DB_USER=$(grep "^Username:" "${ICINGA2_IDO_CRED_FILE}" | cut -d: -f2 | tr -d ' ')
        IDO_DB_PASS=$(grep "^Password:" "${ICINGA2_IDO_CRED_FILE}" | cut -d: -f2 | tr -d ' ')
    fi

    # Copy and configure resources.ini
    if [ ! -f "${ICINGAWEB2_CONF_DIR}/resources.ini" ]; then
        cp "${CONF_TEMPLATES}/resources.ini" "${ICINGAWEB2_CONF_DIR}/resources.ini"
        sed -i -e "s|@db_name@|${DB_NAME}|g" \
               -e "s|@db_user@|${DB_USER}|g" \
               -e "s|@db_pass@|${DB_PASS}|g" \
               -e "s|@ido_db_name@|${IDO_DB_NAME}|g" \
               -e "s|@ido_db_user@|${IDO_DB_USER}|g" \
               -e "s|@ido_db_pass@|${IDO_DB_PASS}|g" \
             "${ICINGAWEB2_CONF_DIR}/resources.ini"
    fi

    # Create admin user
    if [ -n "${wizard_admin_user}" ] && [ -n "${wizard_admin_pass}" ]; then
        create_admin_user
    fi

    # Copy config.ini
    if [ ! -f "${ICINGAWEB2_CONF_DIR}/config.ini" ]; then
        cp "${CONF_TEMPLATES}/config.ini" "${ICINGAWEB2_CONF_DIR}/config.ini"
    fi

    # Copy authentication.ini
    if [ ! -f "${ICINGAWEB2_CONF_DIR}/authentication.ini" ]; then
        cp "${CONF_TEMPLATES}/authentication.ini" "${ICINGAWEB2_CONF_DIR}/authentication.ini"
    fi

    # Copy groups.ini
    if [ ! -f "${ICINGAWEB2_CONF_DIR}/groups.ini" ]; then
        cp "${CONF_TEMPLATES}/groups.ini" "${ICINGAWEB2_CONF_DIR}/groups.ini"
    fi

    # Copy roles.ini
    if [ ! -f "${ICINGAWEB2_CONF_DIR}/roles.ini" ]; then
        cp "${CONF_TEMPLATES}/roles.ini" "${ICINGAWEB2_CONF_DIR}/roles.ini"
        # Update roles.ini with the admin username from wizard
        if [ -n "${wizard_admin_user}" ]; then
            sed -i "s/users = \"admin\"/users = \"${wizard_admin_user}\"/" "${ICINGAWEB2_CONF_DIR}/roles.ini"
        fi
    fi

    # Enable monitoring module by default
    if [ ! -L "${ICINGAWEB2_CONF_DIR}/enabledModules/monitoring" ]; then
        ln -sf "/var/packages/icingaweb2/target/share/icingaweb2/modules/monitoring" \
            "${ICINGAWEB2_CONF_DIR}/enabledModules/monitoring"
    fi

    # Copy monitoring module config.ini
    if [ ! -f "${ICINGAWEB2_CONF_DIR}/modules/monitoring/config.ini" ]; then
        cp "${CONF_TEMPLATES}/modules/monitoring/config.ini" "${ICINGAWEB2_CONF_DIR}/modules/monitoring/config.ini"
    fi

    # Copy monitoring module backends.ini
    if [ ! -f "${ICINGAWEB2_CONF_DIR}/modules/monitoring/backends.ini" ]; then
        cp "${CONF_TEMPLATES}/modules/monitoring/backends.ini" "${ICINGAWEB2_CONF_DIR}/modules/monitoring/backends.ini"
    fi

    # Copy and configure monitoring module commandtransports.ini
    if [ ! -f "${ICINGAWEB2_CONF_DIR}/modules/monitoring/commandtransports.ini" ]; then
        API_USER="admin"
        API_PASS=""
        if [ -f "${ICINGA2_API_USER_FILE}" ]; then
            API_USER=$(grep "^Username:" "${ICINGA2_API_USER_FILE}" | cut -d: -f2 | tr -d ' ')
            API_PASS=$(grep "^Password:" "${ICINGA2_API_USER_FILE}" | cut -d: -f2 | tr -d ' ')
        fi
        cp "${CONF_TEMPLATES}/modules/monitoring/commandtransports.ini" "${ICINGAWEB2_CONF_DIR}/modules/monitoring/commandtransports.ini"
        sed -i -e "s|@api_user@|${API_USER}|g" \
               -e "s|@api_pass@|${API_PASS}|g" \
            "${ICINGAWEB2_CONF_DIR}/modules/monitoring/commandtransports.ini"
    fi

    # Create symlink for config directory (needed for STARTABLE=no)
    ICINGAWEB2_SHARE="/var/packages/icingaweb2/target/share/icingaweb2"
    if [ -d "${ICINGAWEB2_SHARE}" ] && [ ! -L "${ICINGAWEB2_SHARE}/config" ]; then
        rm -rf "${ICINGAWEB2_SHARE}/config" 2>/dev/null
        ln -sf "${ICINGAWEB2_CONF_DIR}" "${ICINGAWEB2_SHARE}/config"
    fi

    # Set permissions
    chmod -R 2770 "${ICINGAWEB2_CONF_DIR}"
    chown -R sc-icingaweb2:http "${ICINGAWEB2_CONF_DIR}"
}
