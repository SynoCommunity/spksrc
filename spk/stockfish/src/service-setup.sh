# Config file location (WebStation manages the web directory via resource file)
WEB_DIR="/var/services/web_packages/${SYNOPKG_PKGNAME}"
CONFIG_TEMPLATE=${SYNOPKG_PKGDEST}/var/webgui-config-template.php
CONFIG_FILE="${WEB_DIR}/config.php"

service_postinst ()
{
    # Overwrite config file from template
    cp -f ${CONFIG_TEMPLATE} ${CONFIG_FILE}

    # Edit config file according to the wizard
    sed -i -e "s|@@_wizard_security_code_@@|${wizard_security_code}|g" ${CONFIG_FILE}
    sed -i -e "s|@@_wizard_thinking_time_ms_@@|${wizard_thinking_time_ms}|g" ${CONFIG_FILE}
}
