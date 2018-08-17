CFG_FILE="${SYNOPKG_PKGDEST}/var/ps3netsrv.conf"
BIN_FILE="${SYNOPKG_PKGDEST}/bin/ps3netsrv"

export PID_FILE LOG_FILE CFG_FILE BIN_FILE

SERVICE_COMMAND="${SYNOPKG_PKGDEST}/ps3netsrv-starter.sh"

service_postinst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        sed -i -e "s|@wizard_dir@|${wizard_dir:=/volume1/PS3}|g" ${CFG_FILE}
    fi
}
