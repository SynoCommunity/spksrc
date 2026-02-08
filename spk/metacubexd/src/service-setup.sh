WEB_DIR="/var/services/web_packages"

if [ $SYNOPKG_DSM_VERSION_MAJOR -lt 7 ];then
    WEB_DIR="/var/services/web"
fi

if [ -z "${SYNOPKG_PKGTMP}" ]; then
    SYNOPKG_PKGTMP="${SYNOPKG_PKGDEST_VOL}/@tmp"
fi

WEB_ROOT="${WEB_DIR}/${SYNOPKG_PKGNAME}"
SYNOSVC="/usr/syno/sbin/synoservice"

if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 7 ]; then
    WEB_USER="http"
    WEB_GROUP="http"
fi

set_metacubexd_permissions ()
{
    if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 7 ]; then
        DIRAPP=$1
        echo "Setting the correct ownership and permissions of the files and folders in ${DIRAPP}"
        # Set the ownership for all files and folders to http:http
        find -L ${DIRAPP} -type d -print0 | xargs -0 chown ${WEB_USER}:${WEB_GROUP} 2>/dev/null
        find -L ${DIRAPP} -type f -print0 | xargs -0 chown ${WEB_USER}:${WEB_GROUP} 2>/dev/null
        # Use chmod on files and directories with different permissions
        # For all files use 0640
        find -L ${DIRAPP} -type f -print0 | xargs -0 chmod 640 2>/dev/null
        # For all directories use 0750
        find -L ${DIRAPP} -type d -print0 | xargs -0 chmod 750 2>/dev/null
    fi
}

service_postinst ()
{
    if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 7 ]; then
        echo "Installing web interface"
        ${MKDIR} ${WEB_ROOT}/
        rsync -aX ${SYNOPKG_PKGDEST}/web/ ${WEB_ROOT} 2>&1

        WS_CFG_DIR="/usr/syno/etc/packages/WebStation"
        WS_CFG_FILE="WebStation.json"
        WS_CFG_PATH="${WS_CFG_DIR}/${WS_CFG_FILE}"
        
        TEMPDIR="${SYNOPKG_PKGTMP}/web"
        ${MKDIR} ${TEMPDIR}
        TMP_WS_CFG_PATH="${TEMPDIR}/${WS_CFG_FILE}"

        WS_BACKEND="$(jq -r '.default.backend' ${WS_CFG_PATH})"

        RESTART_APACHE="no"

        RSYNC_ARCH_ARGS="--backup --suffix=.bak --remove-source-files"

        # Check if Apache is the selected back-end
        if [ ! "$WS_BACKEND" = "2" ]; then
            echo "Set Apache as the back-end server"
            jq '.default.backend = 2' ${WS_CFG_PATH} > ${TMP_WS_CFG_PATH}
            rsync -aX ${RSYNC_ARCH_ARGS} ${TMP_WS_CFG_PATH} ${WS_CFG_DIR}/ 2>&1
            RESTART_APACHE="yes"
        fi

        # Check for Apache config
        if [ ! -f "/usr/local/etc/apache24/sites-enabled/${SYNOPKG_PKGNAME}.conf" ]; then
            echo "Add Apache config for ${SC_DNAME}"
            rsync -aX ${SYNOPKG_PKGDEST}/apache24/${SYNOPKG_PKGNAME}.conf /usr/local/etc/apache24/sites-enabled/ 2>&1
            RESTART_APACHE="yes"
        fi

        # Restart Apache if configs have changed
        if [ "$RESTART_APACHE" = "yes" ]; then
            echo "Restart Apache to load new configs"
            ${SYNOSVC} --restart pkgctl-Apache2.4
        fi
    fi

    # Fix permissions
    if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 7 ]; then
        set_metacubexd_permissions ${WEB_ROOT}
    fi
}

service_postuninst ()
{
    if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 7 ]; then
        echo "Removing web interface"
        ${RM} ${WEB_ROOT}

        RESTART_APACHE="no"

         # Check for Apache config
        if [ -f "/usr/local/etc/apache24/sites-enabled/${SYNOPKG_PKGNAME}.conf" ]; then
            echo "Removing Apache config for ${SC_DNAME}"
            ${RM} /usr/local/etc/apache24/sites-enabled/${SYNOPKG_PKGNAME}.conf
            RESTART_APACHE="yes"
        fi

        # Restart Apache if configs have changed
        if [ "$RESTART_APACHE" = "yes" ]; then
            echo "Restart Apache to load new configs"
            ${SYNOSVC} --restart pkgctl-Apache2.4
        fi
    fi
}
