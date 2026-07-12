# PostgreSQL connection settings
PG_HOST="localhost"
PG_PORT="5433"
PG_ADMIN_USER="${wizard_pg_username_admin}"
PG_ADMIN_PASS="${wizard_pg_password_admin}"
PG_USER="immich"
PG_DATABASE="immich"
PG_PSQL="/usr/local/bin/psql"
PG_PGDUMP="/usr/local/bin/pg_dump"
PG_PASS_FILE="${SYNOPKG_PKGVAR}/db_password"
if [ -n "${SHARE_PATH}" ]; then
    MEDIA_PATH="${SHARE_PATH}"
else
    for SHARE_DIR in "/var/packages/${SYNOPKG_PKGNAME}/shares/"*/; do
        [ -d "${SHARE_DIR}" ] && MEDIA_PATH="${SHARE_DIR}" && break
    done
fi

NODE=/var/packages/Node.js_v22/target/usr/local/bin/node
SERVER_LAUNCHER=/var/packages/immich/target/bin/server-launcher.js
MLLAUNCHER=/var/packages/immich/target/bin/immich-ml-launcher.sh
ML_DIR=/var/packages/immich/target/share/immich/immich-ml
ML_VENV=/var/packages/immich/target/env-ml

SVC_BACKGROUND=y
SVC_WRITE_PID=y

SERVICE_COMMAND=""

service_prestart()
{
    DB_PASSWORD="$(cat /var/packages/immich/var/db_password 2>/dev/null)"
    export NODE_OPTIONS=--unhandled-rejections=warn
    export DB_PASSWORD
    export IMMICH_BUILD_DATA=/var/packages/immich/target/share/immich
    export IMMICH_MEDIA_LOCATION="${MEDIA_PATH}"
    export DB_HOSTNAME=localhost
    export DB_PORT=5433
    export DB_USERNAME=immich
    export REDIS_HOSTNAME=localhost

    SERVICE_COMMAND="${NODE} ${SERVER_LAUNCHER}"

    if [ -x "${ML_VENV}/bin/python3" ]; then
        export IMMICH_MACHINE_LEARNING_URL=http://127.0.0.1:3003
        SERVICE_COMMAND="${SERVICE_COMMAND}
${MLLAUNCHER}"
    else
        export IMMICH_MACHINE_LEARNING_ENABLED=false
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
        FILENAME="immich-db-backup-${TIMESTAMP}-v3.0.2-pg${PG_VERSION}.sql.gz"
        PGPASSWORD="${wizard_pg_password_immich}" ${PG_PGDUMP} -h "${PG_HOST}" -p "${PG_PORT}" -U "${PG_USER}" -d "${PG_DATABASE}" | gzip > "${wizard_dbexport_path}/${FILENAME}"
    fi
}

service_postinst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" = "INSTALL" ]; then
        for folder in encoded-video library upload profile thumbs backups; do
            mkdir -p "${MEDIA_PATH}/${folder}"
            touch "${MEDIA_PATH}/${folder}/.immich"
        done
        mkdir -p "${SYNOPKG_PKGVAR}/geodata"
        printf '%s' "${wizard_pg_password_immich}" > "${PG_PASS_FILE}"
    fi

    if [ "${SYNOPKG_PKG_STATUS}" = "INSTALL" ]; then
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
            "${ML_VENV}/bin/pip3" install --force-reinstall --no-cache-dir opencv-python-headless 2>&1 || true
        fi
    fi
}

service_postuninst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" = "UNINSTALL" ]; then
        PGPASSWORD="${PG_ADMIN_PASS}" ${PG_PSQL} -h "${PG_HOST}" -p "${PG_PORT}" -U "${PG_ADMIN_USER}" -d postgres -c "DROP DATABASE IF EXISTS ${PG_DATABASE};" 2>/dev/null || true
        PGPASSWORD="${PG_ADMIN_PASS}" ${PG_PSQL} -h "${PG_HOST}" -p "${PG_PORT}" -U "${PG_ADMIN_USER}" -d postgres -c "DROP USER IF EXISTS ${PG_USER};" 2>/dev/null || true
        rm -f "${PG_PASS_FILE}"
        rm -rf "${ML_VENV}" 2>/dev/null || true
    fi
}
