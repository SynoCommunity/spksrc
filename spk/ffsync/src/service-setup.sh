PACKAGE="${SYNOPKG_PKGNAME}"

PYTHON_DIR="/usr/local/python"
PATH="${SYNOPKG_PKGDEST}/bin:${SYNOPKG_PKGDEST}/env/bin:${PYTHON_DIR}/bin:${PATH}"
HOME="${SYNOPKG_PKGDEST}/var"
VIRTUALENV="${PYTHON_DIR}/bin/virtualenv"
PYTHON="${SYNOPKG_PKGDEST}/env/bin/python"

# ffsync
PSERVE="${SYNOPKG_PKGDEST}/env/bin/pserve"
INI_FILE="${HOME}/ffsync.ini"
PID_FILE="${HOME}/ffsync.pid"
LOG_FILE="${HOME}/pserve.log"

LEGACY_GROUP="nobody"

SERVICE_COMMAND="${PSERVE} ${INI_FILE} --daemon --pid-file=${PID_FILE} --log-file=${LOG_FILE}"

# mock wizard vars which are used right now
#wizard_mysql_root_password=""
#wizard_password_ffsync="ffsync"
#wizard_ffsync_public_url=""

# mysql vars
#@TODO: Will be filled from wizard
MYSQL_PORT="3306"
MYSQL_ROOT_USER="root"
MYSQL_FFSYNC_DB="ffsync"
MYSQL_FFSYNC_USER="ffsync"

# set mysql_bin
MYSQL_BIN_ERROR=""
MYSQL_BIN="$(which mysql)"
MYSQL_CMD=""
if [ -z "$MYSQL_BIN" ] || [ "${BUILDNUMBER}" -lt "7321" ]; then
    MYSQL_BIN_ERROR="The mysql binary could not be found."
else
    MYSQL_CMD="${MYSQL_BIN} --user=${MYSQL_ROOT_USER} --password='${wizard_mysql_root_password}' --port=${MYSQL_PORT} --skip-column-names --batch --verbose"
fi

# set mysqldump binary
MYSQLDUMP_BIN_ERROR=""
MYSQLDUMP_BIN="$(which mysqldump)"
if [ -z "$MYSQLDUMP_BIN" ] || [ "${BUILDNUMBER}" -lt "7321" ]; then
    MYSQLDUMP_BIN_ERROR="The mysqldump binary could not be found."
else
    MYSQLDUMP_CMD="${MYSQLDUMP_BIN} --user=${MYSQL_ROOT_USER} --password='${wizard_mysql_root_password}' --port=${MYSQL_PORT}"
fi

service_preinst ()
{
    return
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then

        # check if the mysql binary has been found
        if [ -z "$MYSQL_BIN" ]; then
            echo $MYSQL_BIN_ERROR
            exit 1
        fi

        # check if we can connect to the database as root
        CMD=$($MYSQL_CMD --execute=quit 2>&1)
        if [ $? -ne 0 ]; then
            echo "Can't connect to database: ${CMD}"
            exit 1
        fi

        # check if the user already exists
        CMD=$(${MYSQL_CMD} --execute="SELECT EXISTS(SELECT 1 FROM mysql.user WHERE user = '${MYSQL_FFSYNC_USER}')")
        if [ "$CMD" = 1 ]; then
            echo "MySQL user ${MYSQL_FFSYNC_USER} already exists"
            exit 1
        fi

        # check if the database already exists
        if ${MYSQL_CMD} --execute="SHOW DATABASES" | grep ^${MYSQL_FFSYNC_DB}$ > /dev/null 2>&1; then
            echo "MySQL database ${MYSQL_FFSYNC_DB} already exists"
            exit 1
        fi
    fi
}

service_postinst ()
{
    MYSQL_FFSYNC_PASS = "${wizard_password_ffsync:=ffsync}"
    # Edit the configuration according to the wizard
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        ${MYSQL_CMD} -e "CREATE DATABASE ${PACKAGE}; GRANT ALL PRIVILEGES ON ${PACKAGE}.* TO '${MYSQL_FFSYNC_USER}'@'localhost' IDENTIFIED BY '${MYSQL_FFSYNC_PASS}';" >> ${INST_LOG} 2>&1
        sed -i -e "s|@mysql_password@|${MYSQL_FFSYNC_PASS}|g" \
               -e "s|^#secret.*|secret = `openssl rand -base64 20`|g" \
               -e "s|http://0.0.0.0:8132|${wizard_ffsync_public_url}|g" \
               ${INI_FILE}
    fi

    # Create a Python virtualenv
    ${VIRTUALENV} --system-site-packages ${SYNOPKG_PKGDEST}/env >> ${INST_LOG} 2>&1

    # Install the wheels
    ${SYNOPKG_PKGDEST}/env/bin/pip install --no-deps --no-index -U --force-reinstall -f ${SYNOPKG_PKGDEST}/share/wheelhouse ${SYNOPKG_PKGDEST}/share/wheelhouse/*.whl >> ${INST_LOG} 2>&1

    # If necessary, add user also to the old group before removing it
    syno_user_add_to_legacy_group "${EFF_USER}" "${USER}" "${LEGACY_GROUP}"

    # Remove legacy user
    # Commands of busybox from spk/python
    delgroup "${USER}" "users" >> ${INST_LOG}
    deluser "${USER}" >> ${INST_LOG}
}

service_preuninst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" == "UNINSTALL" ]; then
        # check if the mysql binary has been found
        if [ -z "$MYSQL_BIN" ]; then
            echo $MYSQL_BIN_ERROR
            exit 1
        fi

        # check if we can connect to the database as root
        CMD=$($MYSQL_CMD --execute="quit" 2>&1)
        if [ $? -ne 0 ]; then
            echo "Can't connect to database: ${CMD}"
            exit 1
        fi

        # Check database export location
        if [ "${SYNOPKG_PKG_STATUS}" == "UNINSTALL" -a -n "${wizard_dbexport_path}" ]; then
            if [ -f "${wizard_dbexport_path}" -o -e "${wizard_dbexport_path}/${PACKAGE}.sql" ]; then
                echo "File ${wizard_dbexport_path}/${PACKAGE}.sql already exists. Please remove or choose a different location"
                exit 1
            fi
        fi
    fi
}

service_postuninst ()
{
    # Remove link
    rm -f ${INSTALL_DIR}

    # Export and remove database
    if [ "${SYNOPKG_PKG_STATUS}" == "UNINSTALL" ]; then
        if [ -n "${wizard_dbexport_path}" ]; then
            mkdir -p ${wizard_dbexport_path}
            ${MYSQLDUMP_CMD} ${PACKAGE} > "${wizard_dbexport_path}/${PACKAGE}.sql"
        fi
        ${MYSQL_CMD} --execute="DROP DATABASE ${PACKAGE}; DROP USER '${MYSQL_FFSYNC_USER}'@'localhost';"
    fi

    exit 0
}
