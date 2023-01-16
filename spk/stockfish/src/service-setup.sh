
INSTALL_DIR=${SYNOPKG_PKGDEST}/webgui
WEB_DIR="/var/services/web/stockfish"
CONFIG_TEMPLATE=${SYNOPKG_PKGDEST}/var/webgui-config-template.php
CONFIG_FILE="${WEB_DIR}/config.php"

service_postinst ()
{
    # Install the web interface
    cp -pR ${INSTALL_DIR} ${WEB_DIR}
    # Overwrite config file from template
    cp -f ${CONFIG_TEMPLATE} ${CONFIG_FILE}

    # Edit config file according to the wizard
    sed -i -e "s|@@_wizard_security_code_@@|${wizard_security_code}|g" ${CONFIG_FILE}
    sed -i -e "s|@@_wizard_thinking_time_ms_@@|${wizard_thinking_time_ms}|g" ${CONFIG_FILE}
}


service_postuninst ()
{
    # Remove the web interface
    rm -rf ${WEB_DIR}
}

