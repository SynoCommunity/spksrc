
CONFIG_FILE=${SYNOPKG_PKGVAR}/server.yml
SERVICE_COMMAND="${SYNOPKG_PKGDEST}/bin/ntfy serve --config ${CONFIG_FILE}"
SVC_BACKGROUND=y
SVC_WRITE_PID=y


service_postinst ()
{
    mkdir -p ${SYNOPKG_PKGVAR}/cache/attachments
    mkdir -p ${SYNOPKG_PKGVAR}/templates
    
    if [ "${SYNOPKG_PKG_STATUS}" = "INSTALL" ]; then
        # Edit the configuration according to the wizard
        sed -e "s|@@_base_url_@@|${wizard_base_url}|g" -i "${CONFIG_FILE}"
    fi
}
