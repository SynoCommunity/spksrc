
# icecast service setup
CFG_FILE="${SYNOPKG_PKGVAR}/icecast.xml"
SERVICE_COMMAND="${SYNOPKG_PKGDEST}/bin/icecast -b -c ${CFG_FILE}"
SVC_WRITE_PID=y

service_postinst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then  
        # Edit the configuration according to the wizard
        sed -e "s/@username@/${wizard_ic_username:=admin}/g" \
            -e "s/@password@/${wizard_ic_password:=changepassword}/g" \
            -i ${CFG_FILE}
    fi

    if [ -f "${CFG_FILE}" ]; then
        chown "${EFF_USER}:$(id -gn "${EFF_USER}")" "${CFG_FILE}"
        chmod 600 "${CFG_FILE}"
    fi
}
