
HTACCESS_FILE=/var/services/web_packages/adminer/.htaccess

if [ $SYNOPKG_DSM_VERSION_MAJOR -lt 7 ];then
INSTALL_DIR=${SYNOPKG_PKGDEST}/web
DSM6_WEB_DIR="/var/services/web/adminer"
HTACCESS_FILE=${INSTALL_DIR}/.htaccess
fi

service_postinst ()
{
    # Edit .htaccess according to the wizard
    sed -i -e "s|@@_wizard_htaccess_allowed_from_@@|${wizard_htaccess_allowed_from}|g" ${HTACCESS_FILE}

    if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 7 ];then
        # Install the web interface
        cp -pR ${INSTALL_DIR} ${DSM6_WEB_DIR}
    fi
}

service_postuninst ()
{
    # Remove the web interface
    if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 7 ];then
        rm -rf ${DSM6_WEB_DIR}
    fi
}

service_postupgrade ()
{
    # Edit .htaccess according to the wizard
    sed -i -e "s|@@_wizard_htaccess_allowed_from_@@|${wizard_htaccess_allowed_from}|g" ${HTACCESS_FILE}
}
