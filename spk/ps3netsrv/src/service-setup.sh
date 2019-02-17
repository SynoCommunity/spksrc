CFG_FILE="${SYNOPKG_PKGDEST}/var/ps3netsrv.conf"

export PID_FILE CFG_FILE

service_postinst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        sed -i -e "s|@wizard_dir@|${wizard_dir:=/volume1/PS3}|g" ${CFG_FILE}
    fi
}
