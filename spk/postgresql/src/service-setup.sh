# PostgreSQL service setup
# Supports DSM 6 (runs as root) and DSM 7 (runs as package user)
# EFF_USER is provided by the framework (sc-postgresql with SERVICE_USER=auto)

DATABASE_DIR="${SYNOPKG_PKGVAR}/data"
CFG_FILE="${DATABASE_DIR}/postgresql.conf"
HBA_FILE="${DATABASE_DIR}/pg_hba.conf"
PATH="${SYNOPKG_PKGDEST}/bin:${PATH}"

# Wizard variables (required - no defaults)
PG_USERNAME=${wizard_pg_username}
PG_PASSWORD=${wizard_pg_password}

# Backup variables from uninstall wizard
PG_BACKUP=${wizard_pg_dump_directory}
BACKUP_DATE=$(date +%Y-%m-%d)
PG_BACKUP_CONF_DIR="${PG_BACKUP}/config_${BACKUP_DATE}"
PG_BACKUP_DUMP_DIR="${PG_BACKUP}/databases_${BACKUP_DATE}"

# Helper function to run commands as the effective user
# On DSM 7: scripts run as package user, so run directly
# On DSM 6: scripts run as root, so use su to switch user
run_as_user()
{
    if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -ge 7 ]; then
        eval "$@"
    else
        su - ${EFF_USER} -s /bin/sh -c "$@"
    fi
}

validate_preuninst()
{
    # Validate backup directory if user requested database backup
    if [ "${wizard_pg_dump_database}" = "true" ]; then
        # Validate password by attempting to connect
        # Start server temporarily for validation
        run_as_user "${SYNOPKG_PKGDEST}/bin/pg_ctl -D ${DATABASE_DIR} -l ${LOG_FILE} start"

        export PGPASSWORD="${wizard_pg_password}"
        if ! ${SYNOPKG_PKGDEST}/bin/psql -h localhost -p ${SERVICE_PORT} -U ${EFF_USER} -d postgres -c "SELECT 1" > /dev/null 2>&1; then
            unset PGPASSWORD
            run_as_user "${SYNOPKG_PKGDEST}/bin/pg_ctl -D ${DATABASE_DIR} stop"
            echo "Incorrect PostgreSQL administrator password"
            exit 1
        fi
        unset PGPASSWORD

        # Stop server after validation
        run_as_user "${SYNOPKG_PKGDEST}/bin/pg_ctl -D ${DATABASE_DIR} stop"

        if [ -z "${PG_BACKUP}" ]; then
            echo "Error: Backup directory path is empty."
            exit 1
        fi
        # Try to create directory if it doesn't exist
        if [ ! -d "${PG_BACKUP}" ]; then
            mkdir -p "${PG_BACKUP}" 2>/dev/null || {
                echo "Error: Unable to create backup directory ${PG_BACKUP}. Check permissions."
                exit 1
            }
        fi
        # Check write permissions
        if [ ! -w "${PG_BACKUP}" ]; then
            echo "Error: Backup directory ${PG_BACKUP} is not writable. Check permissions."
            exit 1
        fi
    fi
}

service_postinst()
{
    # On DSM 6 (running as root), create data directory and set ownership
    if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -lt 7 ]; then
        mkdir -p "${DATABASE_DIR}"
        chown -R ${EFF_USER}:$(id -gn ${EFF_USER}) "${SYNOPKG_PKGVAR}"
    fi

    # Create password file for initdb (scram-sha-256 requires superuser password)
    PWFILE="${SYNOPKG_PKGVAR}/.pwfile"
    echo "${PG_PASSWORD}" > "${PWFILE}"
    chmod 600 "${PWFILE}"
    if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -lt 7 ]; then
        chown ${EFF_USER}:$(id -gn ${EFF_USER}) "${PWFILE}"
    fi

    # Initialize database with peer auth for local connections (allows setup without password)
    # scram-sha-256 for host connections from the start
    run_as_user "${SYNOPKG_PKGDEST}/bin/initdb -D ${DATABASE_DIR} --encoding=UTF8 --locale=en_US.UTF8 --auth-local=peer --auth-host=scram-sha-256 --pwfile=${PWFILE}"

    # Remove password file after initialization
    rm -f "${PWFILE}"

    # Configure postgresql.conf
    # Set port from SERVICE_PORT (avoids conflict with Synology's PostgreSQL on 5432)
    run_as_user "sed -e 's/^#port = 5432/port = ${SERVICE_PORT}/g' -i ${CFG_FILE}"
    # Move Unix socket from /tmp to package var directory for persistence and security
    run_as_user "sed -e \"s|^#unix_socket_directories = '/tmp'|unix_socket_directories = '${SYNOPKG_PKGVAR}'|g\" -i ${CFG_FILE}"
    # Listen on all interfaces
    run_as_user "sed -e \"s/^#listen_addresses = 'localhost'/listen_addresses = '*'/g\" -i ${CFG_FILE}"

    # Start server temporarily to create roles
    run_as_user "${SYNOPKG_PKGDEST}/bin/pg_ctl -D ${DATABASE_DIR} -l ${LOG_FILE} start"

    # Set password for the system user (peer auth allows connection without password via Unix socket)
    run_as_user "${SYNOPKG_PKGDEST}/bin/psql -h ${SYNOPKG_PKGVAR} -p ${SERVICE_PORT} -d postgres -c \"ALTER ROLE \\\"${EFF_USER}\\\" WITH PASSWORD '${PG_PASSWORD}';\""

    # Create administrator role from wizard (peer auth via Unix socket)
    run_as_user "${SYNOPKG_PKGDEST}/bin/psql -h ${SYNOPKG_PKGVAR} -p ${SERVICE_PORT} -d postgres -c \"CREATE ROLE ${PG_USERNAME} PASSWORD '${PG_PASSWORD}' SUPERUSER CREATEDB CREATEROLE INHERIT LOGIN REPLICATION BYPASSRLS;\""

    # Enable PostGIS extension in template1 (so new databases get it automatically)
    run_as_user "${SYNOPKG_PKGDEST}/bin/psql -h ${SYNOPKG_PKGVAR} -p ${SERVICE_PORT} -d template1 -c 'CREATE EXTENSION IF NOT EXISTS postgis;'"
    # Enable PostGIS in the default postgres database as well
    run_as_user "${SYNOPKG_PKGDEST}/bin/psql -h ${SYNOPKG_PKGVAR} -p ${SERVICE_PORT} -d postgres -c 'CREATE EXTENSION IF NOT EXISTS postgis;'"

    # Switch local authentication to scram-sha-256 for regular users
    # Keep peer auth for the system user (sc-postgresql) to allow passwordless backups
    # Order matters: first matching rule wins, so system user rule must come first
    run_as_user "sed -e 's/^local.*all.*all.*peer$/local   all             ${EFF_USER}                             peer\\nlocal   all             all                                     scram-sha-256/' -i ${HBA_FILE}"

    # Stop server (will be started by DSM)
    run_as_user "${SYNOPKG_PKGDEST}/bin/pg_ctl -D ${DATABASE_DIR} stop"
}

service_preuninst()
{
    # Backup databases on user's request
    if [ "${wizard_pg_dump_database}" = "true" ]; then
        # Start server for backup
        run_as_user "${SYNOPKG_PKGDEST}/bin/pg_ctl -D ${DATABASE_DIR} -l ${LOG_FILE} start"

        # Create backup directories (running as root has write access to shared folders)
        mkdir -p "${PG_BACKUP_CONF_DIR}"
        mkdir -p "${PG_BACKUP_DUMP_DIR}"

        # Backup configuration files
        cp "${DATABASE_DIR}/pg_hba.conf" "${PG_BACKUP_CONF_DIR}/"
        cp "${DATABASE_DIR}/pg_ident.conf" "${PG_BACKUP_CONF_DIR}/"
        cp "${DATABASE_DIR}/postgresql.auto.conf" "${PG_BACKUP_CONF_DIR}/"
        cp "${DATABASE_DIR}/postgresql.conf" "${PG_BACKUP_CONF_DIR}/"

        # Dump all databases (excluding templates)
        # Use TCP/IP connection with password (PGPASSWORD) - runs as root to write to shared folders
        export PGPASSWORD="${wizard_pg_password}"
        for database in $(${SYNOPKG_PKGDEST}/bin/psql -h localhost -p ${SERVICE_PORT} -U ${EFF_USER} -A -t -d postgres -c 'SELECT datname FROM pg_database WHERE datistemplate = false'); do
            ${SYNOPKG_PKGDEST}/bin/pg_dump -h localhost -p ${SERVICE_PORT} -U ${EFF_USER} -Fc ${database} -f "${PG_BACKUP_DUMP_DIR}/${database}.dump"
        done
        unset PGPASSWORD

        # Stop server
        run_as_user "${SYNOPKG_PKGDEST}/bin/pg_ctl -D ${DATABASE_DIR} stop"
    fi
}
