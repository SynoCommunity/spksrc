

# service configuration
CFG_FILE="${SYNOPKG_PKGVAR}/monitrc"
MONIT=${SYNOPKG_PKGDEST}/bin/monit

SERVICE_COMMAND="${MONIT} -c ${CFG_FILE} -l ${LOG_FILE}"

service_postinst ()
{
    # Edit the configuration according to the wizard
    sed -e "s/@control_username@/${wizard_control_username:=admin}/g" \
        -e "s/@control_password@/${wizard_control_password:=monit}/g" \
        -i ${CFG_FILE}

}
