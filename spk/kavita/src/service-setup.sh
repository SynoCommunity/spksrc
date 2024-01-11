
# Kavita service setup
KAVITA="${SYNOPKG_PKGDEST}/share/Kavita"

# Kavita uses custom Config and PID directories
HOME_DIR="${SYNOPKG_PKGDEST}/share"
CONFIG_DIR="${SYNOPKG_PKGVAR}/config"
PID_FILE="${SYNOPKG_PKGVAR}/kavita.pid"

SVC_BACKGROUND=y
SVC_WAIT_TIMEOUT=90

service_prestart ()
{
    # Replace generic service startup, fork process in background
    if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 7 ]; then
        COMMAND="env LD_LIBRARY_PATH=${SYNOPKG_PKGDEST}/lib ${KAVITA}"
    else
        COMMAND="env ${KAVITA}"
    fi
    echo "Starting Kavita at ${HOME_DIR}" >> ${LOG_FILE}
    cd ${HOME_DIR};
    ${COMMAND} >> ${LOG_FILE} 2>&1 &
    echo "$!" > "${PID_FILE}"
}

service_postinst ()
{
    echo "Setup config directory"
    # Remove default config directory and link to var
    ${RM} "${HOME_DIR}/config"
    ${LN} "${CONFIG_DIR}" "${HOME_DIR}/config"

    if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 7 ]; then
        set_unix_permissions "${CONFIG_DIR}"
    fi
}
