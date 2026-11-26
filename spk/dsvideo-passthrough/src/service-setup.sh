CONFIG="${SYNOPKG_PKGVAR}/config"
PORT=5080
UPSTREAM="http://127.0.0.1:5000"
if [ -r "${CONFIG}" ]; then
    . "${CONFIG}"
fi

SERVICE_COMMAND="${SYNOPKG_PKGDEST}/bin/dsvideo-passthrough --listen 0.0.0.0:${PORT} --upstream ${UPSTREAM}"
SVC_BACKGROUND=yes
SVC_WRITE_PID=yes
SVC_KEEP_LOG=yes

LOG_MAX_BYTES=5242880

service_prestart ()
{
    if [ -f "${LOG_FILE}" ]; then
        size=$(wc -c < "${LOG_FILE}")
        if [ "${size}" -gt "${LOG_MAX_BYTES}" ]; then
            mv -f "${LOG_FILE}" "${LOG_FILE}.1"
        fi
    fi
}

service_postinst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" = "INSTALL" ]; then
        printf 'PORT=%s\nUPSTREAM=%s\n' \
            "${wizard_listen_port:-5080}" \
            "${wizard_upstream:-http://127.0.0.1:5000}" \
            > "${CONFIG}"
    fi
}
