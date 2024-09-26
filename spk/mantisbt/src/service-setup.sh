
# Package
SC_DNAME="MantisBT"
SC_PKG_PREFIX="com-synocommunity-packages-"
SC_PKG_NAME="${SC_PKG_PREFIX}${SYNOPKG_PKGNAME}"

# Others
MYSQL="/usr/local/mariadb10/bin/mysql"
MYSQLDUMP="/usr/local/mariadb10/bin/mysqldump"
MYSQL_USER="${SYNOPKG_PKGNAME}"
MYSQL_DATABASE="${SYNOPKG_PKGNAME}"
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
CFG_FILE="${WEB_ROOT}/config/config_inc.php"

exec_php ()
{
    PHP="/usr/local/bin/php74"
    # Define the resource file
    RESOURCE_FILE="${SYNOPKG_PKGDEST}/web/mantisbt.json"
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
        /bin/su "$WEB_USER" -s /bin/sh -c "${COMMAND}"
    else
        $COMMAND
    fi
    return $?
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
            echo "Incorrect MySQL 'root' password"
            exit 1
        fi
        if ${MYSQL} -u root -p"${wizard_mysql_password_root}" mysql -e "SELECT User FROM user" | grep ^${MYSQL_USER}$ > /dev/null 2>&1; then
            echo "MySQL user '${MYSQL_USER}' already exists"
            exit 1
        fi
        if ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e "SHOW DATABASES" | grep ^${MYSQL_DATABASE}$ > /dev/null 2>&1; then
            echo "MySQL database '${MYSQL_DATABASE}' already exists"
            exit 1
        fi

        # Check for valid backup to restore
        if [ "${wizard_mantisbt_restore}" = "true" ] && [ -n "${wizard_backup_file}" ]; then
            if [ ! -f "${wizard_backup_file}" ]; then
                echo "The backup file path specified is incorrect or not accessible"
                exit 1
            fi
            # Check backup file prefix
            filename=$(basename "${wizard_backup_file}")
            expected_prefix="${SYNOPKG_PKGNAME}_backup_v"

            if [ "${filename#"$expected_prefix"}" = "$filename" ]; then
                echo "The backup filename does not start with the expected prefix"
                exit 1
            fi
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
        chown -R ${WEB_USER}:${WEB_GROUP} ${WEB_ROOT} 2>/dev/null
    fi

    if [ "${SYNOPKG_PKG_STATUS}" = "INSTALL" ]; then
        # Check restore action
        if [ "${wizard_mantisbt_restore}" = "true" ]; then
            echo "The backup file is valid, performing restore"
            # Extract archive to temp folder
            TEMPDIR="${SYNOPKG_PKGTMP}/${SYNOPKG_PKGNAME}"
            ${MKDIR} "${TEMPDIR}"
            tar -xzf "${wizard_backup_file}" -C "${TEMPDIR}" 2>&1
            # Fix file ownership
            if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 7 ]; then
                chown -R ${WEB_USER}:${WEB_GROUP} ${TEMPDIR} 2>/dev/null
            fi

            # Restore configuration
            echo "Restoring configuration to ${WEB_DIR}/config"
            # Restore the configuration file
            rsync -aX -I ${TEMPDIR}/config/config_inc.php ${WEB_ROOT}/config/ 2>&1
            # Restore custom files
            for file in "${TEMPDIR}"/config/custom*
            do
                if [ -f "$file" ]; then
                    rsync -aX -I $file ${WEB_ROOT}/config/ 2>&1
                fi
            done

            # Update database password
            MARIADB_PASSWORD_ESCAPED=$(printf '%s' "${wizard_mysql_password_mantisbt}" | sed 's/[&/\]/\\&/g')
            sed -i "s|\(\$g_db_password[ \t]*=[ \t]*'\)[^']*\(';\)|\1${MARIADB_PASSWORD_ESCAPED}\2|" "${CFG_FILE}"

            # Restore the Database
            echo "Restoring database to ${MYSQL_DATABASE}"
            ${MYSQL} -u root -p"${wizard_mysql_password_root}" ${MYSQL_DATABASE} < ${TEMPDIR}/database/${MYSQL_DATABASE}-dbbackup.sql 2>&1

            # Run update scripts
            sed -i -e "s/gpc_get_int( 'install', 0 );/gpc_get_int( 'install', 2 );/g" ${WEB_ROOT}/admin/install.php
            exec_php ${WEB_ROOT}/admin/install.php > /dev/null

            # Remove admin directory
            ${RM} "${WEB_ROOT}/admin"

            # Clean-up temporary files
            ${RM} "${TEMPDIR}"
        else
            # Install config file
            rsync -aX -I "${SYNOPKG_PKGDEST}/web/config_inc.php" "${CFG_FILE}" 2>&1

            # Setup configuration file
            MARIADB_PASSWORD_ESCAPED=$(printf '%s' "${wizard_mysql_password_mantisbt}" | sed 's/[&/\]/\\&/g')
            sed -i -e "s/@password@/${MARIADB_PASSWORD_ESCAPED:=mantisbt}/g" ${CFG_FILE}
            RAND_STR=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 64)
            sed -i -e "s/@rand_str@/${RAND_STR}/g" ${CFG_FILE}
            sed -i -e "s#@web_url@#${wizard_install_url}#g" ${CFG_FILE}
            
            # Install/upgrade database
            echo "Run ${SC_DNAME} installer"
            sed -i -e "s/gpc_get_int( 'install', 0 );/gpc_get_int( 'install', 2 );/g" ${WEB_ROOT}/admin/install.php
            exec_php ${WEB_ROOT}/admin/install.php > /dev/null

            # Remove admin directory
            ${RM} "${WEB_ROOT}/admin"
        fi
    fi
}

validate_preuninst ()
{
    # Check database
    if [ "${SYNOPKG_PKG_STATUS}" = "UNINSTALL" ] && ! ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e quit > /dev/null 2>&1; then
        echo "Incorrect MySQL 'root' password"
        exit 1
    fi
    # Check export directory
    if [ "${SYNOPKG_PKG_STATUS}" = "UNINSTALL" ] && [ -n "${wizard_export_path}" ]; then
        if [ ! -d "${wizard_export_path}" ]; then
            # If the export path directory does not exist, create it
            ${MKDIR} "${wizard_export_path}" || {
                # If mkdir fails, print an error message and exit
                echo "Error: Unable to create directory ${wizard_export_path}. Check permissions."
                exit 1
            }
        elif [ ! -w "${wizard_export_path}" ]; then
            # If the export path directory is not writable, print an error message and exit
            echo "Error: Unable to write to directory ${wizard_export_path}. Check permissions."
            exit 1
        fi
    fi
}

service_preuninst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" = "UNINSTALL" ] && [ -n "${wizard_export_path}" ]; then
        # Prepare archive structure
        if [ -f "${WEB_ROOT}/core/constant_inc.php" ]; then
            MANTIS_VER=$(sed -n "s|define[ \t]*([ \t]*'MANTIS_VERSION'[ \t]*,[ \t]*'\(.*\)'[ \t]*);|\1|p" ${WEB_ROOT}/core/constant_inc.php | xargs)
        fi
        TEMPDIR="${SYNOPKG_PKGTMP}/${SYNOPKG_PKGNAME}_backup_v${MANTIS_VER}_$(date +"%Y%m%d")"
        ${MKDIR} "${TEMPDIR}"

        # Backup the configuration file
        echo "Copying previous configuration and data from ${WEB_ROOT}/config"
        ${MKDIR} "${TEMPDIR}/config"
        rsync -aX ${WEB_ROOT}/config/config_inc.php "${TEMPDIR}/config/" 2>&1

        # Backup custom files
        for file in "${WEB_ROOT}/config"/custom*
        do
            if [ -f "$file" ]; then
                rsync -aX $file "${TEMPDIR}/config/" 2>&1
            fi
        done

        # Backup the Database
        echo "Copying previous database from ${MYSQL_DATABASE}"
        ${MKDIR} "${TEMPDIR}/database"
        ${MYSQLDUMP} -u root -p"${wizard_mysql_password_root}" ${MYSQL_DATABASE} > ${TEMPDIR}/database/${MYSQL_DATABASE}-dbbackup.sql 2>&1

        # Create backup archive
        archive_name="$(basename "$TEMPDIR").tar.gz"
        echo "Creating compressed archive of ${SC_DNAME} data in file $archive_name"
        tar -C "$TEMPDIR" -czf "${SYNOPKG_PKGTMP}/$archive_name" . 2>&1

        # Move archive to export directory
        RSYNC_BAK_ARGS="--backup --suffix=.bak"
        rsync -aX ${RSYNC_BAK_ARGS} "${SYNOPKG_PKGTMP}/$archive_name" "${wizard_export_path}/" 2>&1
        echo "Backup file copied successfully to ${wizard_export_path}"

        # Clean-up temporary files
        ${RM} "${TEMPDIR}"
        ${RM} "${SYNOPKG_PKGTMP}/$archive_name"
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
    # Prepare temp folder
    [ -d ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME} ] && ${RM} ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}
    ${MKDIR} ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}
    
    # Save the configuration file
    rsync -aX ${WEB_ROOT}/config/config_inc.php ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/ 2>&1

    # Save custom files
    for file in "${WEB_ROOT}/config"/custom*
    do
        if [ -f "$file" ]; then
            rsync -aX $file ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/ 2>&1
        fi
    done
}

service_restore ()
{
    # Restore the configuration file
    rsync -aX -I ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/config_inc.php ${WEB_ROOT}/config/ 2>&1

    # Restore custom files
    for file in "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}"/custom*
    do
        if [ -f "$file" ]; then
            rsync -aX -I $file ${WEB_ROOT}/config/ 2>&1
        fi
    done

    # Remove admin directory
    if [ -d "${WEB_ROOT}/admin" ]; then
        ${RM} "${WEB_ROOT}/admin"
    fi

    ${RM} ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}
}
