# Icinga Web 2 service setup

# Director daemon (job runner) configuration
export ICINGAWEB_CONFIGDIR="${SYNOPKG_PKGVAR}/etc/icingaweb2"
export ICINGAWEB_LIBDIR="${SYNOPKG_PKGDEST}/share/icinga-php"
export ICINGAWEB2_STORAGE_DIR="${SYNOPKG_PKGVAR}/storage"
SERVICE_COMMAND="${SYNOPKG_PKGDEST}/share/icingaweb2/bin/icingacli director daemon run"
SVC_BACKGROUND=y
SVC_WRITE_PID=y

# PHP binary (DSM 7.0+ only)
if [ "${SYNOPKG_DSM_VERSION_MINOR}" -ge 2 ]; then
    PHP="/usr/local/bin/php82"
else
    PHP="/usr/local/bin/php80"
fi

# MariaDB paths
MYSQL="/usr/local/mariadb10/bin/mysql"

# Database configuration
DB_NAME="icingaweb2"
DB_USER="icingaweb2"

ICINGA2_API_USER_FILE="/var/packages/icinga2/var/etc/icingaweb2/api-credentials.txt"
ICINGA2_IDO_CRED_FILE="/var/packages/icinga2/var/etc/icingaweb2/ido-credentials.txt"
CONF_TEMPLATES="${SYNOPKG_PKGDEST}/share/templates"

# Helper: extract field value from credential file (e.g., "Username: foo" -> "foo")
get_credential()
{
    file=$1 field=$2
    grep "^${field}:" "${file}" 2>/dev/null | cut -d: -f2 | tr -d ' '
}

# Helper: copy template file and optionally substitute placeholder variables
# Usage: copy_config "source" "dest" "@var1@" "value1" "@var2@" "value2"
copy_config()
{
    src=$1 dest=$2
    shift 2
    cp "${src}" "${dest}"
    while [ $# -gt 0 ]; do
        sed -i "s|$1|g" "${dest}"
        shift
    done
}

# Verify MariaDB root password and check for existing database/user
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

# Verify MariaDB root password before uninstall
validate_preuninst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" = "UNINSTALL" ]; then
        if [ -n "${wizard_mysql_password_root}" ]; then
            if ! ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e quit > /dev/null 2>&1; then
                echo "Incorrect MariaDB root password"
                exit 1
            fi
        fi
    fi
}

# Remove database and user on package uninstall
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

# Create icingaweb2 database and dedicated MariaDB user
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

# Import Icinga Web 2 database schema from package
import_icingaweb2_schema ()
{
    echo "Importing Icinga Web 2 database schema"
    SCHEMA_FILE="${SYNOPKG_PKGDEST}/share/icingaweb2/schema/mysql.schema.sql"
    if [ -f "${SCHEMA_FILE}" ]; then
        ${MYSQL} -u "${DB_USER}" -p"${DB_PASS}" "${DB_NAME}" < "${SCHEMA_FILE}"
    fi
}

# Create Icinga Web admin user via PHP script
create_admin_user ()
{
    echo "Creating administrator user '${wizard_admin_user}'"
    ${PHP} "${SYNOPKG_PKGDEST}/share/create-admin.php" "${wizard_admin_user}" "${wizard_admin_pass}"
    exit_code=$?
    echo "create-admin.php exit code: $exit_code"
    if [ $exit_code -ne 0 ]; then
        echo "WARNING: create-admin.php exited with code $exit_code"
    fi
}

# Post-installation: create directories and configure Icinga Web 2
service_postinst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" = "INSTALL" ]; then
        DB_PASS="${wizard_db_pass}"
        setup_icingaweb2_database
        import_icingaweb2_schema
        if [ -n "${wizard_admin_user}" ] && [ -n "${wizard_admin_pass}" ]; then
            create_admin_user
        fi

        # Create directories for storage and configuration
        mkdir -p "${ICINGAWEB2_STORAGE_DIR}"
        mkdir -p "${ICINGAWEB_CONFIGDIR}/modules/monitoring"
        mkdir -p "${ICINGAWEB_CONFIGDIR}/enabledModules"

        # Retrieve credentials from icinga2 package (API and IDO database)
        IDO_DB_NAME=$(get_credential "${ICINGA2_IDO_CRED_FILE}" "Database")
        IDO_DB_USER=$(get_credential "${ICINGA2_IDO_CRED_FILE}" "Username")
        IDO_DB_PASS=$(get_credential "${ICINGA2_IDO_CRED_FILE}" "Password")
        API_USER=$(get_credential "${ICINGA2_API_USER_FILE}" "Username")
        API_PASS=$(get_credential "${ICINGA2_API_USER_FILE}" "Password")
        API_HOST=$(hostname)

        # Copy base config files (resources.ini requires placeholder substitution)
        copy_config "${CONF_TEMPLATES}/resources.ini" "${ICINGAWEB_CONFIGDIR}/resources.ini" \
            "@db_name@" "${DB_NAME}" "@db_user@" "${DB_USER}" "@db_pass@" "${DB_PASS}" \
            "@ido_db_name@" "${IDO_DB_NAME}" "@ido_db_user@" "${IDO_DB_USER}" "@ido_db_pass@" "${IDO_DB_PASS}" \
            "@api_host@" "${API_HOST}" "@api_user@" "${API_USER}" "@api_pass@" "${API_PASS}"

        copy_config "${CONF_TEMPLATES}/config.ini" "${ICINGAWEB_CONFIGDIR}/config.ini"
        copy_config "${CONF_TEMPLATES}/authentication.ini" "${ICINGAWEB_CONFIGDIR}/authentication.ini"
        copy_config "${CONF_TEMPLATES}/groups.ini" "${ICINGAWEB_CONFIGDIR}/groups.ini"

        # Copy roles.ini and substitute admin user from wizard
        copy_config "${CONF_TEMPLATES}/roles.ini" "${ICINGAWEB_CONFIGDIR}/roles.ini"
        if [ -n "${wizard_admin_user}" ]; then
            sed -i "s/users = \"admin\"/users = \"${wizard_admin_user}\"/" "${ICINGAWEB_CONFIGDIR}/roles.ini"
        fi

        # Enable Icinga Web 2 modules (monitoring, incubator, director)
        for module in monitoring incubator director; do
            ln -sf "/var/packages/icingaweb2/target/share/icingaweb2/modules/${module}" \
                "${ICINGAWEB_CONFIGDIR}/enabledModules/${module}"
        done

        # Configure Director module (config, kickstart, jobs)
        mkdir -p "${ICINGAWEB_CONFIGDIR}/modules/director"
        copy_config "${CONF_TEMPLATES}/modules/director/config.ini" "${ICINGAWEB_CONFIGDIR}/modules/director/config.ini"
        copy_config "${CONF_TEMPLATES}/modules/director/kickstart.ini" "${ICINGAWEB_CONFIGDIR}/modules/director/kickstart.ini" \
            "@api_host@" "${API_HOST}" "@api_user@" "${API_USER}" "@api_pass@" "${API_PASS}"
        copy_config "${CONF_TEMPLATES}/modules/director/jobs.ini" "${ICINGAWEB_CONFIGDIR}/modules/director/jobs.ini"

        # Configure monitoring module (config, backends, command transports)
        copy_config "${CONF_TEMPLATES}/modules/monitoring/config.ini" "${ICINGAWEB_CONFIGDIR}/modules/monitoring/config.ini"
        copy_config "${CONF_TEMPLATES}/modules/monitoring/backends.ini" "${ICINGAWEB_CONFIGDIR}/modules/monitoring/backends.ini"
        copy_config "${CONF_TEMPLATES}/modules/monitoring/commandtransports.ini" "${ICINGAWEB_CONFIGDIR}/modules/monitoring/commandtransports.ini" \
            "@api_user@" "${API_USER}" "@api_pass@" "${API_PASS}"

        # Create symlink so package share points to config directory (needed for STARTABLE=no)
        ICINGAWEB2_SHARE="/var/packages/icingaweb2/target/share/icingaweb2"
        if [ -d "${ICINGAWEB2_SHARE}" ] && [ ! -L "${ICINGAWEB2_SHARE}/config" ]; then
            rm -rf "${ICINGAWEB2_SHARE}/config" 2>/dev/null
            ln -sf "${ICINGAWEB_CONFIGDIR}" "${ICINGAWEB2_SHARE}/config"
        fi

        # Set ownership and permissions on config and storage directories
        find "${ICINGAWEB_CONFIGDIR}" -type f -exec chmod 640 {} \;
        find "${ICINGAWEB_CONFIGDIR}" -type d -exec chmod 750 {} \;
        chmod 750 "${ICINGAWEB2_STORAGE_DIR}"
        if id sc-icingaweb2 >/dev/null 2>&1; then
            chown -R sc-icingaweb2:http "${ICINGAWEB_CONFIGDIR}"
            chown sc-icingaweb2:http "${ICINGAWEB2_STORAGE_DIR}"
        fi

        # Run Director database migration, kickstart API sync, and agent template setup
        if [ -f "${ICINGAWEB_CONFIGDIR}/modules/director/kickstart.ini" ]; then
            "${SYNOPKG_PKGDEST}/share/icingaweb2/bin/icingacli" director migration run 2>/dev/null || true
            "${SYNOPKG_PKGDEST}/share/icingaweb2/bin/icingacli" director kickstart run 2>/dev/null || true
            "${PHP}" "${SYNOPKG_PKGDEST}/share/setup-director-template.php" "agent-template" 2>/dev/null || true
            "${SYNOPKG_PKGDEST}/share/icingaweb2/bin/icingacli" director config deploy 2>/dev/null || true
        fi
    fi
}
