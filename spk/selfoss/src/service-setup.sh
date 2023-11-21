
# Selfoss service setup
WEB_DIR="/var/services/web_packages"
# for backwards compatability
if [ $SYNOPKG_DSM_VERSION_MAJOR -lt 7 ];then
    WEB_DIR="/var/services/web"
fi
if [ -z "${SYNOPKG_PKGTMP}" ]; then
    SYNOPKG_PKGTMP="${SYNOPKG_PKGDEST_VOL}/@tmp"
fi

# Others
SELFOSS_ROOT="${WEB_DIR}/${SYNOPKG_PKGNAME}"
JQ="/bin/jq"
SYNOSVC="/usr/syno/sbin/synoservice"

if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 7 ]; then
    WEB_USER="http"
    WEB_GROUP="http"
fi

set_selfoss_permissions ()
{
    if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 7 ]; then
        DIRAPP=$1
        echo "Setting the correct ownership and permissions of the files and folders in ${DIRAPP}"
        # Set the ownership for all files and folders to http:http
        find -L ${DIRAPP} -type d -print0 | xargs -0 chown ${WEB_USER}:${WEB_GROUP} 2>/dev/null
        find -L ${DIRAPP} -type f -print0 | xargs -0 chown ${WEB_USER}:${WEB_GROUP} 2>/dev/null
        # Use chmod on files and directories to set permissions to 0750
        find -L ${DIRAPP} -type f -print0 | xargs -0 chmod 750 2>/dev/null
        find -L ${DIRAPP} -type d -print0 | xargs -0 chmod 750 2>/dev/null
    else
        echo "Notice: set_selfoss_permissions() is no longer required on DSM 7."
    fi
}

service_postinst ()
{
    # Web interface setup for DSM 6 -- used by INSTALL and UPGRADE
    if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 7 ]; then
        # Install the web interface
        echo "Installing web interface"
        ${MKDIR} ${SELFOSS_ROOT}
        rsync -aX ${SYNOPKG_PKGDEST}/share/${SYNOPKG_PKGNAME}/ ${SELFOSS_ROOT} 2>&1

        # Install web configurations
        TEMPDIR="${SYNOPKG_PKGTMP}/web"
        ${MKDIR} ${TEMPDIR}
        WS_CFG_DIR="/usr/syno/etc/packages/WebStation"
        WS_CFG_FILE="WebStation.json"
        WS_CFG_PATH="${WS_CFG_DIR}/${WS_CFG_FILE}"
        TMP_WS_CFG_PATH="${TEMPDIR}/${WS_CFG_FILE}"
        PHP_CFG_FILE="PHPSettings.json"
        PHP_CFG_PATH="${WS_CFG_DIR}/${PHP_CFG_FILE}"
        TMP_PHP_CFG_PATH="${TEMPDIR}/${PHP_CFG_FILE}"
        PHP_PROF_NAME="Default PHP 7.4 Profile"
        WS_BACKEND="$(${JQ} -r '.default.backend' ${WS_CFG_PATH})"
        WS_PHP="$(${JQ} -r '.default.php' ${WS_CFG_PATH})"
        RESTART_APACHE="no"
        RSYNC_ARCH_ARGS="--backup --suffix=.bak --remove-source-files"
        # Check if Apache is the selected back-end
        if [ ! "$WS_BACKEND" = "2" ]; then
            echo "Set Apache as the back-end server"
            ${JQ} '.default.backend = 2' ${WS_CFG_PATH} > ${TMP_WS_CFG_PATH}
            rsync -aX ${RSYNC_ARCH_ARGS} ${TMP_WS_CFG_PATH} ${WS_CFG_DIR}/ 2>&1
            RESTART_APACHE="yes"
        fi
        # Check if default PHP profile is selected
        if [ -z "$WS_PHP" ] || [ "$WS_PHP" = "null" ]; then
            echo "Enable default PHP profile"
            # Locate default PHP profile
            PHP_PROF_ID="$(${JQ} -r '. | to_entries[] | select(.value | type == "object" and .profile_desc == "'"$PHP_PROF_NAME"'") | .key' "${PHP_CFG_PATH}")"
            ${JQ} ".default.php = \"$PHP_PROF_ID\"" "${WS_CFG_PATH}" > ${TMP_WS_CFG_PATH}
            rsync -aX ${RSYNC_ARCH_ARGS} ${TMP_WS_CFG_PATH} ${WS_CFG_DIR}/ 2>&1
            RESTART_APACHE="yes"
        fi
        # Check for Selfoss PHP profile
        if ! ${JQ} -e '.["com-synocommunity-packages-selfoss"]' "${PHP_CFG_PATH}" >/dev/null; then
            echo "Add PHP profile for Selfoss"
            ${JQ} --slurpfile ocNode ${SYNOPKG_PKGDEST}/web/selfoss.json '.["com-synocommunity-packages-selfoss"] = $ocNode[0]' ${PHP_CFG_PATH} > ${TMP_PHP_CFG_PATH}
            rsync -aX ${RSYNC_ARCH_ARGS} ${TMP_PHP_CFG_PATH} ${WS_CFG_DIR}/ 2>&1
            RESTART_APACHE="yes"
        fi
        # Check for Selfoss Apache config
        if [ ! -f "/usr/local/etc/apache24/sites-enabled/selfoss.conf" ]; then
            echo "Add Apache config for Selfoss"
            rsync -aX ${SYNOPKG_PKGDEST}/web/selfoss.conf /usr/local/etc/apache24/sites-enabled/ 2>&1
            RESTART_APACHE="yes"
        fi
        # Restart Apache if configs have changed
        if [ "$RESTART_APACHE" = "yes" ]; then
            if ${JQ} -e 'to_entries | map(select((.key | startswith("com-synocommunity-packages-")) and .key != "com-synocommunity-packages-selfoss")) | length > 0' "${PHP_CFG_PATH}" >/dev/null; then
                echo " [WARNING] Multiple PHP profiles detected, will require restart of DSM to load new configs"
            else
                echo "Restart Apache to load new configs"
                ${SYNOSVC} --restart pkgctl-Apache2.4
            fi
        fi
        # Clean-up temporary files
        ${RM} ${TEMPDIR}
    fi

    if [ "${SYNOPKG_PKG_STATUS}" = "INSTALL" ]; then
        # Fix permissions
        if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 7 ]; then
            set_selfoss_permissions ${SELFOSS_ROOT}
        fi
    fi
}

service_postuninst ()
{
    # Web interface removal for DSM 6 -- used by UNINSTALL and UPGRADE
    if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 7 ]; then
        # Remove the web interface
        echo "Removing web interface"
        ${RM} ${SELFOSS_ROOT}

        # Remove web configurations
        TEMPDIR="${SYNOPKG_PKGTMP}/web"
        ${MKDIR} ${TEMPDIR}
        WS_CFG_DIR="/usr/syno/etc/packages/WebStation"
        PHP_CFG_FILE="PHPSettings.json"
        PHP_CFG_PATH="${WS_CFG_DIR}/${PHP_CFG_FILE}"
        TMP_PHP_CFG_PATH="${TEMPDIR}/${PHP_CFG_FILE}"
        RESTART_APACHE="no"
        RSYNC_ARCH_ARGS="--backup --suffix=.bak --remove-source-files"
        # Check for Selfoss PHP profile
        if ${JQ} -e '.["com-synocommunity-packages-selfoss"]' "${PHP_CFG_PATH}" >/dev/null; then
            echo "Removing PHP profile for Selfoss"
            ${JQ} 'del(.["com-synocommunity-packages-selfoss"])' ${PHP_CFG_PATH} > ${TMP_PHP_CFG_PATH}
            rsync -aX ${RSYNC_ARCH_ARGS} ${TMP_PHP_CFG_PATH} ${WS_CFG_DIR}/ 2>&1
            ${RM} "${WS_CFG_DIR}/php_profile/com-synocommunity-packages-selfoss"
            RESTART_APACHE="yes"
        fi
        # Check for Selfoss Apache config
        if [ -f "/usr/local/etc/apache24/sites-enabled/selfoss.conf" ]; then
            echo "Removing Apache config for Selfoss"
            ${RM} /usr/local/etc/apache24/sites-enabled/selfoss.conf
            RESTART_APACHE="yes"
        fi
        # Restart Apache if configs have changed
        if [ "$RESTART_APACHE" = "yes" ]; then
            if ${JQ} -e 'to_entries | map(select((.key | startswith("com-synocommunity-packages-")) and .key != "com-synocommunity-packages-selfoss")) | length > 0' "${PHP_CFG_PATH}" >/dev/null; then
                echo " [WARNING] Multiple PHP profiles detected, will require restart of DSM to load new configs"
            else
                echo "Restart Apache to load new configs"
                ${SYNOSVC} --restart pkgctl-Apache2.4
            fi
        fi
        # Clean-up temporary files
        ${RM} ${TEMPDIR}
    fi
}

validate_preinst ()
{
    # Check for modification to PHP template defaults on DSM 6
    if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 7 ]; then
        WS_TMPL_DIR="/var/packages/WebStation/target/misc"
        WS_TMPL_FILE="php74_fpm.mustache"
        WS_TMPL_PATH="${WS_TMPL_DIR}/${WS_TMPL_FILE}"
        # Check for PHP template defaults
        if ! grep -q -E '^user = http$' "${WS_TMPL_PATH}" || ! grep -q -E '^listen\.owner = http$' "${WS_TMPL_PATH}"; then
            echo "PHP template defaults have been modified. Installation is not supported."
            exit 1
        fi
    fi
}

service_save ()
{
    # Backup configuration and data
    [ -d ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME} ] && ${RM} ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}
    echo "Backup existing distribution to ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}"
    ${MKDIR} ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}
    rsync -aX ${SELFOSS_ROOT}/ ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME} 2>&1
}

service_restore ()
{
    # Restore data directory
    echo "Restore previous data directory from ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/data"
    rsync -aX --update -I ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/data ${SELFOSS_ROOT}/ 2>&1

    # Restore the configuration file
    if [ -f ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/config.ini ]; then
        echo "Restore previous configuration from ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}"
        rsync -aX --update -I ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/config.ini ${SELFOSS_ROOT}/ 2>&1
    fi

    # Fix permissions
    if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 7 ]; then
        set_selfoss_permissions ${SELFOSS_ROOT}
    fi

    # Remove upgrade backup files
    ${RM} ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}
}
