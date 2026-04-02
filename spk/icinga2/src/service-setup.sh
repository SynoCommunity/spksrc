# Icinga 2 service configuration

# MariaDB paths
MYSQL="/usr/local/mariadb10/bin/mysql"

# IDO database settings
IDO_DB_NAME="icinga_ido"
IDO_DB_USER="icinga2"

# Environment variables for icinga2 paths
export ICINGA2_CONFIG_FILE="${SYNOPKG_PKGVAR}/etc/icinga2/icinga2.conf"
export ICINGA2_DATA_DIR="${SYNOPKG_PKGVAR}/lib/icinga2"
export ICINGA2_LOG_DIR="${SYNOPKG_PKGVAR}/log/icinga2"
export ICINGA2_CACHE_DIR="${SYNOPKG_PKGVAR}/cache/icinga2"
export ICINGA2_SPOOL_DIR="${SYNOPKG_PKGVAR}/spool/icinga2"
export ICINGA2_INIT_RUN_DIR="${SYNOPKG_PKGVAR}/run/icinga2"

# Template directory
TEMPLATES_DIR="${SYNOPKG_PKGDEST}/share/templates"

SERVICE_COMMAND="${SYNOPKG_PKGDEST}/sbin/icinga2 daemon -c ${SYNOPKG_PKGVAR}/etc/icinga2/icinga2.conf"
SVC_BACKGROUND=y
SVC_WRITE_PID=y

# Helper: generate random password
generate_password ()
{
    head -c 32 /dev/urandom | base64 | tr -dc 'a-zA-Z0-9' | head -c 24
}

# Helper: copy template file and substitute placeholder variables
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
        if ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e "SHOW DATABASES" | grep -q "^${IDO_DB_NAME}$"; then
            echo "MariaDB database '${IDO_DB_NAME}' already exists"
            exit 1
        fi
        if ${MYSQL} -u root -p"${wizard_mysql_password_root}" mysql -e "SELECT User FROM user" | grep -q "^${IDO_DB_USER}$"; then
            echo "MariaDB user '${IDO_DB_USER}' already exists"
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
            echo "Removing IDO database and user"
            ${MYSQL} -u root -p"${wizard_mysql_password_root}" <<EOF 2>/dev/null || true
DROP DATABASE IF EXISTS ${IDO_DB_NAME};
DROP USER IF EXISTS '${IDO_DB_USER}'@'localhost';
FLUSH PRIVILEGES;
EOF
        fi
    fi
}

# Create IDO database, user, and import schema
setup_ido_database ()
{
    echo "Creating IDO database and user"
    IDO_DB_PASS="${wizard_ido_db_password}"

    ${MYSQL} -u root -p"${wizard_mysql_password_root}" <<EOF
CREATE DATABASE ${IDO_DB_NAME} CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER '${IDO_DB_USER}'@'localhost' IDENTIFIED BY '${IDO_DB_PASS}';
GRANT ALL PRIVILEGES ON ${IDO_DB_NAME}.* TO '${IDO_DB_USER}'@'localhost';
FLUSH PRIVILEGES;
EOF

    echo "Importing IDO database schema"
    ${MYSQL} -u "${IDO_DB_USER}" -p"${IDO_DB_PASS}" "${IDO_DB_NAME}" \
        < "${SYNOPKG_PKGDEST}/share/icinga2-ido-mysql/schema/mysql.sql"

    # Save IDO credentials for Icinga Web 2
    mkdir -p "${SYNOPKG_PKGVAR}/etc/icingaweb2"
    copy_config "${TEMPLATES_DIR}/ido-credentials.txt" "${SYNOPKG_PKGVAR}/etc/icingaweb2/ido-credentials.txt" \
        "@ido_db_name@" "${IDO_DB_NAME}" "@ido_db_user@" "${IDO_DB_USER}" "@ido_db_pass@" "${IDO_DB_PASS}"
    chmod 640 "${SYNOPKG_PKGVAR}/etc/icingaweb2/ido-credentials.txt"
}

# Configure IDO-MySQL feature
configure_ido_mysql ()
{
    IDO_DB_PASS="${wizard_ido_db_password}"

    # Enable ido-mysql feature
    ln -sf ../features-available/ido-mysql.conf "${SYNOPKG_PKGVAR}/etc/icinga2/features-enabled/ido-mysql.conf"

    # Configure ido-mysql from template
    copy_config "${TEMPLATES_DIR}/ido-mysql.conf" "${SYNOPKG_PKGVAR}/etc/icinga2/features-available/ido-mysql.conf" \
        "@ido_db_name@" "${IDO_DB_NAME}" "@ido_db_user@" "${IDO_DB_USER}" "@ido_db_pass@" "${IDO_DB_PASS}"
}

service_postinst()
{
    # Create required directories
    mkdir -p "${SYNOPKG_PKGVAR}/etc/icinga2"
    mkdir -p "${SYNOPKG_PKGVAR}/log/icinga2"
    mkdir -p "${SYNOPKG_PKGVAR}/log/icinga2/crash"
    mkdir -p "${SYNOPKG_PKGVAR}/log/icinga2/compat"
    mkdir -p "${SYNOPKG_PKGVAR}/cache/icinga2"
    mkdir -p "${SYNOPKG_PKGVAR}/lib/icinga2"
    mkdir -p "${SYNOPKG_PKGVAR}/spool/icinga2"
    mkdir -p "${SYNOPKG_PKGVAR}/spool/icinga2/perfdata"
    mkdir -p "${SYNOPKG_PKGVAR}/spool/icinga2/tmp"
    mkdir -p "${SYNOPKG_PKGVAR}/run/icinga2"
    mkdir -p "${SYNOPKG_PKGVAR}/run/icinga2/cmd"

    if [ "${SYNOPKG_PKG_STATUS}" = "INSTALL" ]; then
        # Setup IDO database
        setup_ido_database

        # Copy default configuration if not present (first install)
        if [ ! -f "${SYNOPKG_PKGVAR}/etc/icinga2/icinga2.conf" ]; then
            cp -r "${SYNOPKG_PKGDEST}/etc/icinga2/"* "${SYNOPKG_PKGVAR}/etc/icinga2/"

            # Use custom constants.conf with correct plugin paths and TicketSalt
            TICKET_SALT=$(generate_password)
            sed -e "s|const TicketSalt = \"\"|const TicketSalt = \"${TICKET_SALT}\"|g" \
                "${TEMPLATES_DIR}/constants.conf" > "${SYNOPKG_PKGVAR}/etc/icinga2/constants.conf"

            # Secure config directory - only owner and group can read
            find "${SYNOPKG_PKGVAR}/etc/icinga2" -type f -exec chmod 640 {} \;
            find "${SYNOPKG_PKGVAR}/etc/icinga2" -type d -exec chmod 750 {} \;

            # Use custom hosts.conf with mail notifications disabled
            cp "${TEMPLATES_DIR}/hosts.conf" "${SYNOPKG_PKGVAR}/etc/icinga2/conf.d/hosts.conf"

            # Enable API feature
            ln -sf ../features-available/api.conf "${SYNOPKG_PKGVAR}/etc/icinga2/features-enabled/api.conf"

            # Enable IDO-MySQL feature
            configure_ido_mysql

            # Create API user configuration from template
            API_PASSWORD=$(generate_password)
            copy_config "${TEMPLATES_DIR}/api-users.conf" "${SYNOPKG_PKGVAR}/etc/icinga2/conf.d/api-users.conf" \
                "@api_password@" "${API_PASSWORD}"

            # Save API credentials for Icinga Web 2
            copy_config "${TEMPLATES_DIR}/api-credentials.txt" "${SYNOPKG_PKGVAR}/etc/icingaweb2/api-credentials.txt" \
                "@api_password@" "${API_PASSWORD}"
            chmod 640 "${SYNOPKG_PKGVAR}/etc/icingaweb2/api-credentials.txt"
        fi
    fi

    # Generate certificates for API if not present
    if [ ! -d "${SYNOPKG_PKGVAR}/lib/icinga2/certs" ]; then
        mkdir -p "${SYNOPKG_PKGVAR}/lib/icinga2/certs"
        HOSTNAME=$(hostname -f 2>/dev/null || hostname)
        # Generate CA and node certificates
        "${SYNOPKG_PKGDEST}/sbin/icinga2" pki new-ca 2>/dev/null || true
        # Generate key and CSR
        "${SYNOPKG_PKGDEST}/sbin/icinga2" pki new-cert --cn "${HOSTNAME}" \
            --key "${SYNOPKG_PKGVAR}/lib/icinga2/certs/${HOSTNAME}.key" \
            --csr "${SYNOPKG_PKGVAR}/lib/icinga2/certs/${HOSTNAME}.csr" 2>/dev/null || true
        # Sign the CSR to create the certificate
        "${SYNOPKG_PKGDEST}/sbin/icinga2" pki sign-csr \
            --csr "${SYNOPKG_PKGVAR}/lib/icinga2/certs/${HOSTNAME}.csr" \
            --cert "${SYNOPKG_PKGVAR}/lib/icinga2/certs/${HOSTNAME}.crt" 2>/dev/null || true
        # Copy CA cert
        cp "${SYNOPKG_PKGVAR}/lib/icinga2/ca/ca.crt" "${SYNOPKG_PKGVAR}/lib/icinga2/certs/ca.crt" 2>/dev/null || true
    fi
}
