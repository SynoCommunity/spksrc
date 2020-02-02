CFG_FILE="${SYNOPKG_PKGDEST}/var/icecast.xml"
PATH="${SYNOPKG_PKGDEST}:${PATH}"
SERVICE_COMMAND="${SYNOPKG_PKGDEST}/bin/icecast -c ${CFG_FILE}"
SVC_BACKGROUND=y
SVC_WRITE_PID=y


service_postinst ()
{
    # Edit the configuration according to the wizard
    sed -i -e "s/@username@/${wizard_ic_username:=admin}/g" ${CFG_FILE}
    sed -i -e "s/@password@/${wizard_ic_password:=changepassword}/g" ${CFG_FILE}
}


