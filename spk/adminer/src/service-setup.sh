
SOURCE_WEB_DIR=${SYNOPKG_PKGDEST}/web
HTACCESS_SOURCE_FILE=${SOURCE_WEB_DIR}/.htaccess

if [ $SYNOPKG_DSM_VERSION_MAJOR -lt 7 ];then
DSM6_WEB_DIR="/var/services/web/adminer"
else
HTACCESS_TARGET_FILE=/var/services/web_packages/adminer/.htaccess
fi

service_postinst ()
{
    # Edit .htaccess according to the wizard
    sed -e "s|@@_wizard_htaccess_allowed_from_@@|${wizard_htaccess_allowed_from}|g" -i ${HTACCESS_SOURCE_FILE}

    if [ ${SYNOPKG_DSM_VERSION_MAJOR} -ge 7 ];then
        # Edit .htaccess according to the wizard
        sed -e "s|@@_wizard_htaccess_allowed_from_@@|${wizard_htaccess_allowed_from}|g" -i ${HTACCESS_TARGET_FILE}
    else
        # Install the web interface
        cp -pR ${SOURCE_WEB_DIR} ${DSM6_WEB_DIR}
    fi
}

service_postuninst ()
{
    if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 7 ];then
        # Remove the web interface
        rm -rf ${DSM6_WEB_DIR}
    fi
}

service_postupgrade ()
{
    if [ ${SYNOPKG_DSM_VERSION_MAJOR} -ge 7 ];then
        # Update .htaccess according to the wizard
        sed -e "s|@@_wizard_htaccess_allowed_from_@@|${wizard_htaccess_allowed_from}|g" -i ${HTACCESS_TARGET_FILE}
    fi
}
