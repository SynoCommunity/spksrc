
# Kavita service setup
KAVITA="${SYNOPKG_PKGDEST}/share/Kavita"
SVC_BACKGROUND=y
SVC_WRITE_PID=y
SVC_WAIT_TIMEOUT=90

# Kavita uses custom Config
HOME_DIR="${SYNOPKG_PKGDEST}/share"
CONFIG_DIR="${SYNOPKG_PKGVAR}/config"

SVC_CWD="${HOME_DIR}"
SERVICE_COMMAND="${KAVITA} >> ${LOG_FILE}"

service_postinst ()
{
    echo "Setup config directory"
    # Remove default config directory and link to var
    ${RM} "${HOME_DIR}/config"
    ${LN} "${CONFIG_DIR}" "${HOME_DIR}/config"

    if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -lt 7 ]; then
        set_unix_permissions "${CONFIG_DIR}"
    fi
}
