INFLUXD_CONFIG_PATH=${SYNOPKG_PKGVAR}/config.yml
INFLUXD=${SYNOPKG_PKGDEST}/bin/influxd

export INFLUXD_CONFIG_PATH=${INFLUXD_CONFIG_PATH}

SERVICE_COMMAND="${INFLUXD}"
SVC_BACKGROUND=yes
SVC_WRITE_PID=yes
SVC_CWD="${SYNOPKG_PKGVAR}"

service_postinst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" = "INSTALL" ]; then
        # Edit the configuration according to the wizard
        sed -e "s|@SERVICE_PORT@|${SERVICE_PORT}|g" \
            -e "s|@SYNOPKG_PKGVAR@|${SYNOPKG_PKGVAR}|g" \
            -i "${INFLUXD_CONFIG_PATH}"
    fi
}
