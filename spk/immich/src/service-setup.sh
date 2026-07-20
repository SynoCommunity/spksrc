# Configuration paths
IMMICH_CONF="/var/packages/immich/etc/immich.conf"
IMMICH_BUILD_DATA="${SYNOPKG_PKGDEST}/share/immich"

# External dependencies
NODE="/var/packages/Node.js_v22/target/usr/local/bin/node"
FFMPEG_DIR="/var/packages/ffmpeg8/target/bin"

# PostgreSQL connection
PG_HOST="localhost"
PG_PORT="5433"
PG_ADMIN_USER="${wizard_pg_username_admin}"
PG_ADMIN_PASS="${wizard_pg_password_admin}"
PG_USER="immich"
PG_DATABASE="immich"
PG_PSQL="/usr/local/bin/psql"
PG_PGDUMP="/usr/local/bin/pg_dump"

# Redis connection
REDIS_HOSTNAME="localhost"

# Service launchers
SERVER_LAUNCHER="${SYNOPKG_PKGDEST}/bin/server-launcher.js"
MLLAUNCHER="${SYNOPKG_PKGDEST}/bin/immich-ml-launcher.sh"
ML_VENV="${SYNOPKG_PKGDEST}/env-ml"

SVC_BACKGROUND=y
SVC_WRITE_PID=y

SERVICE_COMMAND=""

service_prestart()
{
    if [ -f "${IMMICH_CONF}" ]; then
        set -a; . "${IMMICH_CONF}"; set +a
    fi
    export PATH="${FFMPEG_DIR}:${PATH}"

    SERVICE_COMMAND="${NODE} ${SERVER_LAUNCHER}"

    if [ "${IMMICH_MACHINE_LEARNING_ENABLED}" = "true" ]; then
        SERVICE_COMMAND="${SERVICE_COMMAND}
${MLLAUNCHER}"
    fi
}

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

validate_preuninst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" = "UNINSTALL" ]; then
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

        if [ -n "${wizard_dbexport_path}" ]; then
            PGPASSWORD="${wizard_pg_password_immich}" ${PG_PSQL} -h "${PG_HOST}" -p "${PG_PORT}" -U "${PG_USER}" -d "${PG_DATABASE}" -c "SELECT 1" >/dev/null 2>&1
            PG_RESULT=$?
            if [ ${PG_RESULT} -ne 0 ]; then
                echo "Immich database authentication failed. Please check your database user password."
                exit 1
            fi

            parent_dir="$(dirname "${wizard_dbexport_path}")"
            if [ ! -w "${parent_dir}" ]; then
                echo "Cannot write to ${parent_dir}. Please check permissions."
                exit 1
            fi
        fi
    fi
}

service_preuninst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" = "UNINSTALL" ] && [ -n "${wizard_dbexport_path}" ]; then
        mkdir -p "${wizard_dbexport_path}"
        PG_VERSION=$("${PG_PGDUMP}" --version 2>/dev/null | sed 's/.* \([0-9]*\)\..*/\1/' || echo "17")
        TIMESTAMP=$(date +%Y%m%dT%H%M%S)
        IMMICH_VERSION="${SYNOPKG_PKGVER%-*}"
        FILENAME="immich-db-backup-${TIMESTAMP}-v${IMMICH_VERSION}-pg${PG_VERSION}.sql.gz"
        PGPASSWORD="${wizard_pg_password_immich}" ${PG_PGDUMP} -h "${PG_HOST}" -p "${PG_PORT}" -U "${PG_USER}" -d "${PG_DATABASE}" | gzip > "${wizard_dbexport_path}/${FILENAME}"
    fi
}

install_immich_config()
{
    mkdir -p "$(dirname "${IMMICH_CONF}")"
    cp "${SYNOPKG_PKGDEST}/etc/immich.conf" "${IMMICH_CONF}"
    sed -i -e "s|@immich_build_data@|${IMMICH_BUILD_DATA}|g" \
           -e "s|@media_path@|${MEDIA_PATH}|g" \
           -e "s|@ml_url@|${ML_URL}|g" \
           -e "s|@ml_enabled@|${ML_ENABLED}|g" \
           -e "s|@db_password@|${DB_PASSWORD}|g" \
           -e "s|@db_hostname@|${PG_HOST}|g" \
           -e "s|@db_port@|${PG_PORT}|g" \
           -e "s|@db_username@|${PG_USER}|g" \
           -e "s|@redis_hostname@|${REDIS_HOSTNAME}|g" \
           "${IMMICH_CONF}"
    chmod 600 "${IMMICH_CONF}"
}

service_postinst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" = "INSTALL" ]; then
        MEDIA_PATH="${SHARE_PATH}"
        for folder in encoded-video library upload profile thumbs backups; do
            mkdir -p "${MEDIA_PATH}/${folder}"
            touch "${MEDIA_PATH}/${folder}/.immich"
        done
        ML_URL=""; ML_ENABLED="false"
        if [ "${wizard_enable_ml}" = "true" ]; then
            ML_URL="http://127.0.0.1:3003"
            ML_ENABLED="true"
        fi
        DB_PASSWORD="${wizard_pg_password_immich}"
        install_immich_config

        PGPASSWORD="${PG_ADMIN_PASS}" ${PG_PSQL} -h "${PG_HOST}" -p "${PG_PORT}" -U "${PG_ADMIN_USER}" -d postgres -c "CREATE USER ${PG_USER} WITH PASSWORD '${wizard_pg_password_immich}' SUPERUSER;" 2>/dev/null || true
        PGPASSWORD="${PG_ADMIN_PASS}" ${PG_PSQL} -h "${PG_HOST}" -p "${PG_PORT}" -U "${PG_ADMIN_USER}" -d postgres -c "CREATE DATABASE ${PG_DATABASE} OWNER ${PG_USER};" 2>/dev/null || true
        for ext in vector unaccent cube earthdistance pg_trgm uuid-ossp; do
            PGPASSWORD="${PG_ADMIN_PASS}" ${PG_PSQL} -h "${PG_HOST}" -p "${PG_PORT}" -U "${PG_ADMIN_USER}" -d "${PG_DATABASE}" -c "CREATE EXTENSION IF NOT EXISTS \"${ext}\";" 2>/dev/null || true
        done
        if [ "${wizard_enable_ml}" = "true" ]; then
            /var/packages/python314/target/bin/python3 -m venv "${ML_VENV}" 2>&1 || true
            "${ML_VENV}/bin/pip3" install --no-cache-dir \
                onnxruntime opencv-python-headless insightface \
                huggingface-hub numpy orjson pillow tokenizers \
                fastapi uvicorn gunicorn pydantic pydantic-settings \
                python-multipart rich aiocache rapidocr 2>&1 || true
            # insightface pulls in opencv-python (GUI); force back to headless
            "${ML_VENV}/bin/pip3" install --force-reinstall --no-cache-dir opencv-python-headless 2>&1 || true
        fi
    fi
}

service_save ()
{
    # Preserve ML virtualenv across upgrade (target dir is replaced)
    [ -d "${ML_VENV}" ] && cp -a "${ML_VENV}" "${SYNOPKG_TEMP_UPGRADE_FOLDER}/env-ml"
}

service_restore ()
{
    # Restore ML virtualenv after upgrade
    if [ -d "${SYNOPKG_TEMP_UPGRADE_FOLDER}/env-ml" ] && [ ! -d "${ML_VENV}" ]; then
        cp -a "${SYNOPKG_TEMP_UPGRADE_FOLDER}/env-ml" "${ML_VENV}"
        rm -rf "${SYNOPKG_TEMP_UPGRADE_FOLDER}/env-ml"
    fi
}

service_postupgrade ()
{
    if [ ! -f "${IMMICH_CONF}" ]; then
        DB_PASSWORD=""
        [ -f "${SYNOPKG_PKGVAR}/db_password" ] && DB_PASSWORD="$(cat "${SYNOPKG_PKGVAR}/db_password")"
        ML_URL=""; ML_ENABLED="false"
        [ -x "${ML_VENV}/bin/python3" ] && ML_URL="http://127.0.0.1:3003" && ML_ENABLED="true"
        MEDIA_PATH=""
        for SHARE in "/var/packages/${SYNOPKG_PKGNAME}/shares/"*/; do
            [ -d "${SHARE}" ] && MEDIA_PATH="$(realpath "${SHARE}")" && break
        done
        install_immich_config
        rm -f "${SYNOPKG_PKGVAR}/db_password"
    fi

    # Upgrade ML wheels if ML is installed
    if [ -x "${ML_VENV}/bin/python3" ]; then
        "${ML_VENV}/bin/pip3" install --upgrade --no-cache-dir \
            onnxruntime opencv-python-headless insightface \
            huggingface-hub numpy orjson pillow tokenizers \
            fastapi uvicorn gunicorn pydantic pydantic-settings \
            python-multipart rich aiocache rapidocr 2>&1 || true
        "${ML_VENV}/bin/pip3" install --force-reinstall --no-cache-dir opencv-python-headless 2>&1 || true
    fi
}

service_postuninst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" = "UNINSTALL" ]; then
        PGPASSWORD="${PG_ADMIN_PASS}" ${PG_PSQL} -h "${PG_HOST}" -p "${PG_PORT}" -U "${PG_ADMIN_USER}" -d postgres -c "DROP DATABASE IF EXISTS ${PG_DATABASE};" 2>/dev/null || true
        PGPASSWORD="${PG_ADMIN_PASS}" ${PG_PSQL} -h "${PG_HOST}" -p "${PG_PORT}" -U "${PG_ADMIN_USER}" -d postgres -c "DROP USER IF EXISTS ${PG_USER};" 2>/dev/null || true
        rm -f "${IMMICH_CONF}"
        rm -rf "${ML_VENV}" 2>/dev/null || true
    fi
}
