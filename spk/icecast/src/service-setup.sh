CFG_FILE="${SYNOPKG_PKGVAR}/icecast.xml"
PATH="${SYNOPKG_PKGDEST}:${PATH}"
SERVICE_COMMAND="${SYNOPKG_PKGDEST}/bin/icecast -c ${CFG_FILE}"
SVC_BACKGROUND=y
SVC_WRITE_PID=y


service_postinst ()
{
    # Edit the configuration according to the wizard
    sed -i -e "s/@username@/${wizard_ic_username:=admin}/g" ${CFG_FILE}
    sed -i -e "s/@password@/${wizard_ic_password:=changepassword}/g" ${CFG_FILE}
    if [ $SYNOPKG_DSM_VERSION_MAJOR -lt 7 ]; then
        sed -i -e "s|/var/packages/icecast/var|/var/packages/icecast/target/var|g" ${CFG_FILE}
    fi
}


service_postupgrade ()
{
    sed -i -e "s|/usr/local/icecast|/var/packages/icecast|g" ${CFG_FILE}
}

