
# Kavita service setup
KAVITA="${SYNOPKG_PKGDEST}/share/Kavita"

# Kavita uses custom Config and PID directories
HOME_DIR="${SYNOPKG_PKGVAR}"
CONFIG_DIR="${HOME_DIR}/config"
PID_FILE="${CONFIG_DIR}/kavita.pid"

if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 7 ]; then
    SERVICE_COMMAND="env HOME=${HOME_DIR} LD_LIBRARY_PATH=${SYNOPKG_PKGDEST}/lib ${KAVITA}"
else
    SERVICE_COMMAND="env HOME=${HOME_DIR} ${KAVITA}"
fi

SVC_BACKGROUND=y
SVC_WAIT_TIMEOUT=90

service_postinst ()
{
    echo "Setup config directory"
    # Remove default config directory and link to var
    ${RM} "${SYNOPKG_PKGDEST}/share/config"
    ${LN} "${CONFIG_DIR}" "${SYNOPKG_PKGDEST}/share/config"

    if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 7 ]; then
        set_unix_permissions "${CONFIG_DIR}"
    fi
}
