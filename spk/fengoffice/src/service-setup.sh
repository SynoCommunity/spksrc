
# Package
SC_DNAME="Feng Office"
SC_PKG_PREFIX="com-synocommunity-packages-"
SC_PKG_NAME="${SC_PKG_PREFIX}${SYNOPKG_PKGNAME}"
SVC_KEEP_LOG=y
SVC_BACKGROUND=y
SVC_WRITE_PID=y

# Others
MYSQL="/usr/local/mariadb10/bin/mysql"
MYSQLDUMP="/usr/local/mariadb10/bin/mysqldump"
MYSQL_USER="fengoffice"
MYSQL_DATABASE="fengoffice"
if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -ge 7 ]; then
    WEB_DIR="/var/services/web_packages"
else
    WEB_DIR="/var/services/web"
    # DSM 6 file and process ownership
    WEB_USER="http"
    WEB_GROUP="http"
fi
WEB_ROOT="${WEB_DIR}/${SYNOPKG_PKGNAME}"
SYNOSVC="/usr/syno/sbin/synoservice"

exec_php() {
    PHP="/usr/local/bin/php74"
    # Define the resource file
    RESOURCE_FILE="${SYNOPKG_PKGDEST}/web/fengoffice.json"
    # Extract extensions and assign to variable
    if [ -f "$RESOURCE_FILE" ]; then
        PHP_SETTINGS=$(jq -r '.extensions | map("-d extension=" + . + ".so") | join(" ")' "$RESOURCE_FILE")
    else
        PHP_SETTINGS=""
    fi
    # Fix for mysqli default socket on DSM 6
    if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 7 ]; then
        PHP_SETTINGS="${PHP_SETTINGS} -d mysqli.default_socket=/run/mysqld/mysqld10.sock"
    fi
    COMMAND="${PHP} ${PHP_SETTINGS} $*"
    if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 7 ]; then
        /bin/su "$WEB_USER" -s /bin/sh -c "${COMMAND}" >> ${LOG_FILE} 2>&1
    else
        $COMMAND >> ${LOG_FILE} 2>&1
    fi
    return $?
}

service_prestart ()
{
    FENGOFFICE="${WEB_ROOT}/cron.php"
    SLEEP_TIME="600"
    # Main loop
    while true; do
        # Update
        echo "Updating..."
        exec_php "${FENGOFFICE}"
        # Wait
        echo "Waiting ${SLEEP_TIME} seconds..."
        sleep ${SLEEP_TIME}
    done &
    echo "$!" > "${PID_FILE}"
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

    if [ "${SYNOPKG_PKG_STATUS}" = "INSTALL" ]; then
        if ! ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e quit > /dev/null 2>&1; then
            echo "Incorrect MySQL root password"
            exit 1
        fi
        if ${MYSQL} -u root -p"${wizard_mysql_password_root}" mysql -e "SELECT User FROM user" | grep ^${MYSQL_USER}$ > /dev/null 2>&1; then
            echo "MySQL user ${MYSQL_USER} already exists"
            exit 1
        fi
        if ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e "SHOW DATABASES" | grep ^${MYSQL_DATABASE}$ > /dev/null 2>&1; then
            echo "MySQL database ${MYSQL_DATABASE} already exists"
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
        rsync -aX ${SYNOPKG_PKGDEST}/share/${SYNOPKG_PKGNAME}/ ${WEB_ROOT} 2>&1

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
        if ! jq -e ".[\"${SC_PKG_NAME}\"]" "${PHP_CFG_PATH}" >/dev/null; then
            echo "Add PHP profile for ${SC_DNAME}"
            jq --slurpfile newProfile ${SYNOPKG_PKGDEST}/web/${SYNOPKG_PKGNAME}.json '.["'"${SC_PKG_NAME}"'"] = $newProfile[0]' ${PHP_CFG_PATH} > ${TMP_PHP_CFG_PATH}
            rsync -aX ${RSYNC_ARCH_ARGS} ${TMP_PHP_CFG_PATH} ${WS_CFG_DIR}/ 2>&1
            RESTART_APACHE="yes"
        fi
        # Check for Apache config
        if [ ! -f "/usr/local/etc/apache24/sites-enabled/${SYNOPKG_PKGNAME}.conf" ]; then
            echo "Add Apache config for ${SC_DNAME}"
            rsync -aX ${SYNOPKG_PKGDEST}/web/${SYNOPKG_PKGNAME}.conf /usr/local/etc/apache24/sites-enabled/ 2>&1
            RESTART_APACHE="yes"
        fi
        # Restart Apache if configs have changed
        if [ "$RESTART_APACHE" = "yes" ]; then
            if jq -e 'to_entries | map(select((.key | startswith("'"${SC_PKG_PREFIX}"'")) and .key != "'"${SC_PKG_NAME}"'")) | length > 0' "${PHP_CFG_PATH}" >/dev/null; then
                echo " [WARNING] Multiple PHP profiles detected, will require restart of DSM to load new configs"
            else
                echo "Restart Apache to load new configs"
                ${SYNOSVC} --restart pkgctl-Apache2.4
            fi
        fi
        # Clean-up temporary files
        ${RM} ${TEMPDIR}
    fi

    # Fix permissions
    if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 7 ]; then
        chown -R ${WEB_USER}:${WEB_GROUP} ${WEB_ROOT}
    fi

    # Run installer
    if [ "${SYNOPKG_PKG_STATUS}" = "INSTALL" ]; then
        # Setup parameters for installation script
        QUERY_STRING="\
script_installer_storage[database_type]=mysqli\
&script_installer_storage[database_host]=localhost\
&script_installer_storage[database_user]=${MYSQL_USER}\
&script_installer_storage[database_pass]=${wizard_mysql_password_fengoffice:=fengoffice}\
&script_installer_storage[database_name]=${MYSQL_DATABASE}\
&script_installer_storage[database_prefix]=fo_\
&script_installer_storage[database_engine]=InnoDB\
&script_installer_storage[absolute_url]=http://${wizard_domain_name:=$(hostname)}/${SYNOPKG_PKGNAME}\
&script_installer_storage[plugins][]=core_dimensions\
&script_installer_storage[plugins][]=mail\
&script_installer_storage[plugins][]=workspaces\
&submited=submited"
        # Prepare environment
        cd ${WEB_ROOT}/public/install/ || exit 1
        # Execute based on DSM version
        echo "Run ${SC_DNAME} installer"
        exec_php "install_helper.php"
    fi
}

service_preuninst ()
{
    # Check database
    if [ "${SYNOPKG_PKG_STATUS}" = "UNINSTALL" ] && ! ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e quit > /dev/null 2>&1; then
        echo "Incorrect MySQL root password"
        exit 1
    fi

    if [ "${SYNOPKG_PKG_STATUS}" = "UNINSTALL" ]; then
        # Check export directory
        if [ -n "${wizard_dbexport_path}" ]; then
            if [ ! -d "${wizard_dbexport_path}" ]; then
                # If the export path directory does not exist, create it
                ${MKDIR} "${wizard_dbexport_path}" || {
                    # If mkdir fails, print an error message and exit
                    echo "Error: Unable to create directory ${wizard_dbexport_path}. Check permissions."
                    exit 1
                }
            elif [ ! -w "${wizard_dbexport_path}" ]; then
                # If the export path directory is not writable, print an error message and exit
                echo "Error: Unable to write to directory ${wizard_dbexport_path}. Check permissions."
                exit 1
            elif [ -e "${wizard_dbexport_path}/${MYSQL_DATABASE}.sql" ]; then
                echo "File ${wizard_dbexport_path}/${MYSQL_DATABASE}.sql already exists. Please remove or choose a different location"
                exit 1
            fi
            # Export database
            ${MYSQLDUMP} -u root -p"${wizard_mysql_password_root}" ${MYSQL_DATABASE} > ${wizard_dbexport_path}/${MYSQL_DATABASE}.sql
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
        if jq -e ".[\"${SC_PKG_NAME}\"]" "${PHP_CFG_PATH}" >/dev/null; then
            echo "Removing PHP profile for ${SC_DNAME}"
            jq 'del(.["'"${SC_PKG_NAME}"'"])' ${PHP_CFG_PATH} > ${TMP_PHP_CFG_PATH}
            rsync -aX ${RSYNC_ARCH_ARGS} ${TMP_PHP_CFG_PATH} ${WS_CFG_DIR}/ 2>&1
            ${RM} "${WS_CFG_DIR}/php_profile/${SC_PKG_NAME}"
            RESTART_APACHE="yes"
        fi
        # Check for Apache config
        if [ -f "/usr/local/etc/apache24/sites-enabled/${SYNOPKG_PKGNAME}.conf" ]; then
            echo "Removing Apache config for ${SC_DNAME}"
            ${RM} /usr/local/etc/apache24/sites-enabled/${SYNOPKG_PKGNAME}.conf
            RESTART_APACHE="yes"
        fi
        # Restart Apache if configs have changed
        if [ "$RESTART_APACHE" = "yes" ]; then
            if jq -e 'to_entries | map(select((.key | startswith("'"${SC_PKG_PREFIX}"'")) and .key != "'"${SC_PKG_NAME}"'")) | length > 0' "${PHP_CFG_PATH}" >/dev/null; then
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
    # Save configuration and files
    [ -d ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME} ] && ${RM} ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}
    mkdir -p ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}
    mv ${WEB_ROOT}/config/config.php ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/
    mv ${WEB_ROOT}/config/installed_version.php ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/
    mkdir ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/upload/
    cp -r ${WEB_ROOT}/upload/*/ ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/upload/
}

service_restore ()
{
    # Detect package version
    PACKAGE_VERSION=$(echo ${SYNOPKG_PKGVER} | cut -d '-' -f 1)
    # Detect old version
    INSTALLED_VERSION=$(sed -n "s|return '\(.*\)';|\1|p" ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/installed_version.php | xargs)

    # Restore configuration
    mv ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/config.php ${WEB_ROOT}/config/
    cp -r ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/upload/*/ ${WEB_ROOT}/upload/
    ${RM} ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}

    # Fix permissions
    if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 7 ]; then
        chown -R ${WEB_USER}:${WEB_GROUP} ${WEB_ROOT}/upload
    fi

    # Run update scripts
    exec_php "${WEB_ROOT}/public/upgrade/console.php" "${INSTALLED_VERSION}" "${PACKAGE_VERSION}"
    exec_php "${WEB_ROOT}/public/install/plugin-console.php" "update_all"
}
