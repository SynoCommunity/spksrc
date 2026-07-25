
INSTALL_DIR=${SYNOPKG_PKGDEST}/web

if [ $SYNOPKG_DSM_VERSION_MAJOR -lt 7 ];then
WEBSITE_ROOT="/var/services/web/element"
else
# added for reference (installed by DSM into this folder)
WEBSITE_ROOT="/var/services/web_packages/element"
fi

service_postinst ()
{
    # install config.json to var folder (this is linked into the web folder)
    if [ ! -f ${SYNOPKG_PKGVAR}/config.json ]; then
        cp -f ${INSTALL_DIR}/config.sample.json ${SYNOPKG_PKGVAR}/config.json
    fi

    if [ $SYNOPKG_DSM_VERSION_MAJOR -lt 7 ];then
        echo "Install the web interface to '${WEBSITE_ROOT}'."
        cp -vpR ${INSTALL_DIR} ${WEBSITE_ROOT}
        chown -R sc-element:http "$WEBSITE_ROOT/*"    
    fi
}

service_postuninst ()
{
    if [ $SYNOPKG_DSM_VERSION_MAJOR -lt 7 ];then
        # Remove the web interface
        echo "Remove the web interface."
        rm -rf ${WEBSITE_ROOT}
    fi
}
