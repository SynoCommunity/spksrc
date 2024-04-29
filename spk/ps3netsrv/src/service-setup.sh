
# service setup
CFG_FILE="${SYNOPKG_PKGVAR}/ps3netsrv.conf"

export CFG_FILE PID_FILE SERVICE_PORT

service_postinst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        sed -i -e "s|@wizard_dir@|${wizard_data_volume}/${wizard_data_directory}|g" ${CFG_FILE}
    fi
}
