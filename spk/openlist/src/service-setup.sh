#!/bin/sh

. ${SYNOPKG_PKGDEST}/../scripts/redguard_helpers

SERVICE_COMMAND="${SYNOPKG_PKGDEST}/bin/openlist server"
SVC_BACKGROUND=yes
SVC_WRITE_PID=yes

service_prestart ()
{
    mkdir -p "${SYNOPKG_PKGDEST}/var"
    
    if [ ! -f "${SYNOPKG_PKGDEST}/var/config.json" ]; then
        cp "${SYNOPKG_PKGDEST}/../share/config.json" \
           "${SYNOPKG_PKGDEST}/var/config.json"
    fi
    
    chown -R "${EFF_USER}:${USER}" "${SYNOPKG_PKGDEST}/var"
    chmod -R 755 "${SYNOPKG_PKGDEST}/var"
    
    return 0
}

service_start()
{
    env PATH="${SYNOPKG_PKGDEST}/bin:${PATH}" \
    HOME="${SYNOPKG_PKGDEST}/var" \
    USER="${EFF_USER}" \
    ${SERVICE_BIN} server >> "${SERVICE_LOG_FILE}" 2>&1 &
    
    echo $! > "${SERVICE_PID_FILE}"
}

service_stop()
{
    if [ -f "${SERVICE_PID_FILE}" ]; then
        kill -9 $(cat "${SERVICE_PID_FILE}") >/dev/null 2>&1
        rm -f "${SERVICE_PID_FILE}"
    fi
}