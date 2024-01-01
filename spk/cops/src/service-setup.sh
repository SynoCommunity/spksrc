
# Package
PACKAGE="cops"
DNAME="COPS"
SC_PKG_PREFIX="com-synocommunity-packages-"
PACKAGE_NAME="${SC_PKG_PREFIX}${PACKAGE}"

# Others
SYNOSVC="/usr/syno/sbin/synoservice"
WEB_DIR="/var/services/web_packages"
# for backwards compatability
if [ $SYNOPKG_DSM_VERSION_MAJOR -lt 7 ];then
    WEB_DIR="/var/services/web"
fi
WEB_ROOT="${WEB_DIR}/${PACKAGE}"

validate_preinst ()
{
    # Check for modification to PHP template defaults on DSM 6
    if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 7 ]; then
        WS_TMPL_PATH="/var/packages/WebStation/target/misc"
        WS_TMPL_FILE="php74_fpm.mustache"
        FULL_WS_TMPL_FILE="${WS_TMPL_PATH}/${WS_TMPL_FILE}"
        # Check for PHP template defaults
        if ! grep -q -E '^user = http$' "${FULL_WS_TMPL_FILE}" || ! grep -q -E '^listen\.owner = http$' "${FULL_WS_TMPL_FILE}"; then
            echo "PHP template defaults have been modified. Installation is not supported."
            exit 1
            fi
    fi
}

service_postinst ()
{
    # Web interface setup for DSM 6 -- used by INSTALL and UPGRADE
    if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 7 ]; then
        # Install the web interface
        echo "Installing web interface"
        ${MKDIR} ${WEB_ROOT}
        rsync -aX ${SYNOPKG_PKGDEST}/share/${PACKAGE}/ ${WEB_ROOT} 2>&1

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
        WS_BACKEND="$(jq -r '.default.backend' ${WS_CFG_PATH})"
        WS_PHP="$(jq -r '.default.php' ${WS_CFG_PATH})"
        RESTART_APACHE="no"
        RSYNC_ARCH_ARGS="--backup --suffix=.bak --remove-source-files"
        # Check if Apache is the selected back-end
        if [ ! "$WS_BACKEND" = "2" ]; then
            echo "Set Apache as the back-end server"
            jq '.default.backend = 2' ${WS_CFG_PATH} > ${TMP_WS_CFG_PATH}
            rsync -aX ${RSYNC_ARCH_ARGS} ${TMP_WS_CFG_PATH} ${WS_CFG_DIR}/ 2>&1
            RESTART_APACHE="yes"
        fi
        # Check if default PHP profile is selected
        if [ -z "$WS_PHP" ] || [ "$WS_PHP" = "null" ]; then
            echo "Enable default PHP profile"
            # Locate default PHP profile
            PHP_PROF_ID="$(jq -r '. | to_entries[] | select(.value | type == "object" and .profile_desc == "'"$PHP_PROF_NAME"'") | .key' "${PHP_CFG_PATH}")"
            jq ".default.php = \"$PHP_PROF_ID\"" "${WS_CFG_PATH}" > ${TMP_WS_CFG_PATH}
            rsync -aX ${RSYNC_ARCH_ARGS} ${TMP_WS_CFG_PATH} ${WS_CFG_DIR}/ 2>&1
            RESTART_APACHE="yes"
        fi
        # Check for PHP profile
        if ! jq -e ".[\"${PACKAGE_NAME}\"]" "${PHP_CFG_PATH}" >/dev/null; then
            echo "Add PHP profile for ${DNAME}"
            jq --slurpfile ocNode ${SYNOPKG_PKGDEST}/web/${PACKAGE}.json '.["'"${PACKAGE_NAME}"'"] = $ocNode[0]' ${PHP_CFG_PATH} > ${TMP_PHP_CFG_PATH}
            rsync -aX ${RSYNC_ARCH_ARGS} ${TMP_PHP_CFG_PATH} ${WS_CFG_DIR}/ 2>&1
            RESTART_APACHE="yes"
        fi
        # Check for Apache config
        if [ ! -f "/usr/local/etc/apache24/sites-enabled/${PACKAGE}.conf" ]; then
            echo "Add Apache config for ${DNAME}"
            rsync -aX ${SYNOPKG_PKGDEST}/web/${PACKAGE}.conf /usr/local/etc/apache24/sites-enabled/ 2>&1
            RESTART_APACHE="yes"
        fi
        # Restart Apache if configs have changed
        if [ "$RESTART_APACHE" = "yes" ]; then
            if jq -e 'to_entries | map(select((.key | startswith("'"${SC_PKG_PREFIX}"'")) and .key != "'"${PACKAGE_NAME}"'")) | length > 0' "${PHP_CFG_PATH}" >/dev/null; then
                echo " [WARNING] Multiple PHP profiles detected, will require restart of DSM to load new configs"
            else
                echo "Restart Apache to load new configs"
                ${SYNOSVC} --restart pkgctl-Apache2.4
            fi
        fi
        # Clean-up temporary files
        ${RM} ${TEMPDIR}
    fi
    # Initialize or update configuration file based on user preferences.
    if [ "${SYNOPKG_PKG_STATUS}" = "INSTALL" ]; then
        CFG_FILE="${WEB_ROOT}/config_local.php"
        DEFAULT_CFG_FILE="${SYNOPKG_PKGDEST}/web/config_local.php.synology"
        # Create a default configuration file
        if [ ! -f "${CFG_FILE}" ]; then
            cp "${DEFAULT_CFG_FILE}" "${CFG_FILE}"
            url_rewriting=$([ "${wizard_use_url_rewriting}" = "true" ] && echo "1" || echo "0")
            sed -i -e "s|@calibre_dir@|${SHARE_PATH:=/volume1/calibre}/|g" ${CFG_FILE}
            sed -i -e "s|@cops_title@|${wizard_cops_title:=COPS}|g" ${CFG_FILE}
            sed -i -e "s|@use_url_rewriting@|${url_rewriting:=0}|g" ${CFG_FILE}
            chmod ga+w "${CFG_FILE}"
        fi
    fi
}

service_postuninst ()
{
    # Web interface removal for DSM 6 -- used by UNINSTALL and UPGRADE
    if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 7 ]; then
        # Remove the web interface
        echo "Removing web interface"
        ${RM} ${WEB_ROOT}

        # Remove web configurations
        TEMPDIR="${SYNOPKG_PKGTMP}/web"
        ${MKDIR} ${TEMPDIR}
        WS_CFG_DIR="/usr/syno/etc/packages/WebStation"
        PHP_CFG_FILE="PHPSettings.json"
        PHP_CFG_PATH="${WS_CFG_DIR}/${PHP_CFG_FILE}"
        TMP_PHP_CFG_PATH="${TEMPDIR}/${PHP_CFG_FILE}"
        RESTART_APACHE="no"
        RSYNC_ARCH_ARGS="--backup --suffix=.bak --remove-source-files"
        # Check for PHP profile
        if jq -e ".[\"${PACKAGE_NAME}\"]" "${PHP_CFG_PATH}" >/dev/null; then
            echo "Removing PHP profile for ${DNAME}"
            jq 'del(.["'"${PACKAGE_NAME}"'"])' ${PHP_CFG_PATH} > ${TMP_PHP_CFG_PATH}
            rsync -aX ${RSYNC_ARCH_ARGS} ${TMP_PHP_CFG_PATH} ${WS_CFG_DIR}/ 2>&1
            ${RM} "${WS_CFG_DIR}/php_profile/${PACKAGE_NAME}"
            RESTART_APACHE="yes"
        fi
        # Check for Apache config
        if [ -f "/usr/local/etc/apache24/sites-enabled/${PACKAGE}.conf" ]; then
            echo "Removing Apache config for ${DNAME}"
            ${RM} /usr/local/etc/apache24/sites-enabled/${PACKAGE}.conf
            RESTART_APACHE="yes"
        fi
        # Restart Apache if configs have changed
        if [ "$RESTART_APACHE" = "yes" ]; then
            if jq -e 'to_entries | map(select((.key | startswith("'"${SC_PKG_PREFIX}"'")) and .key != "'"${PACKAGE_NAME}"'")) | length > 0' "${PHP_CFG_PATH}" >/dev/null; then
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

service_save ()
{
    # Save some stuff
    [ -d ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE} ] && ${RM} ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE}
    echo "Backup existing data to ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE}"
    ${MKDIR} ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE}/web
    # Save cops configuration files
    rsync -aX ${WEB_ROOT}/config_local.php ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE}/web/ 2>&1
    rsync -aX ${WEB_ROOT}/.htaccess ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE}/web/ 2>&1
}

service_restore ()
{
    if [ -f "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE}/web/config_local.php" ]; then
        # Restore some stuff
        echo "Restore previous data from ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE}"
        # Restore cops configuration file
        rsync -aX --update -I ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE}/web/config_local.php ${WEB_ROOT}/config_local.php 2>&1
    else
        # Backup missing, re-initialise default values
        CFG_FILE="${WEB_ROOT}/config_local.php"
        DEFAULT_CFG_FILE="${SYNOPKG_PKGDEST}/web/config_local.php.synology"
        if [ ! -f "${CFG_FILE}" ]; then
            echo "Backup data missing, re-initialising default values"
            # Create a default configuration file
            cp "${DEFAULT_CFG_FILE}" "${CFG_FILE}"
            url_rewriting=$([ "${wizard_use_url_rewriting}" = "true" ] && echo "1" || echo "0")
            sed -i -e "s|@calibre_dir@|${SHARE_PATH:=/volume1/calibre}/|g" ${CFG_FILE}
            sed -i -e "s|@cops_title@|${wizard_cops_title:=COPS}|g" ${CFG_FILE}
            sed -i -e "s|@use_url_rewriting@|${url_rewriting:=0}|g" ${CFG_FILE}
            chmod ga+w "${CFG_FILE}"
        fi
    fi
    if [ -f "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE}/web/.htaccess" ]; then
        # Check if the .htaccess file has been modified
        if [ -f ${WEB_ROOT}/.htaccess ]; then
            SRC_FILE=${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE}/web/.htaccess
            DST_FILE=${WEB_ROOT}/.htaccess
            OUTPUT_FILE=${WEB_ROOT}/.htaccess.diff
            DIFFERENCES=$(diff "$SRC_FILE" "$DST_FILE")
            if [ -n "$DIFFERENCES" ]; then
                # Write the differences to the output file
                echo "$DIFFERENCES" > "$OUTPUT_FILE"
                echo "Modifications to .htaccess file detected. Details saved to $OUTPUT_FILE"
            fi
        fi
    fi

    # Remove upgrade backup files
    ${RM} ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE}
}
