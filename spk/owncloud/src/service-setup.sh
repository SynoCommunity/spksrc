
# ownCloud service setup
WEB_DIR="/var/services/web_packages"
# for backwards compatability
if [ $SYNOPKG_DSM_VERSION_MAJOR -lt 7 ];then
    WEB_DIR="/var/services/web"
fi
if [ -z "${SYNOPKG_PKGTMP}" ]; then
    SYNOPKG_PKGTMP="${SYNOPKG_PKGDEST_VOL}/@tmp"
fi

# Others
OCROOT="${WEB_DIR}/${SYNOPKG_PKGNAME}"
SQLITE="/bin/sqlite3"
JQ="/bin/jq"
SED="/bin/sed"
SYNOSVC="/usr/syno/sbin/synoservice"

if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 7 ]; then
    GROUP="http"
fi

set_owncloud_permissions ()
{
    if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 7 ]; then
        DIRAPP=$1
        DIRDATA=$2
        echo "Setting the correct ownership and permissions of the files and folders in ${DIRAPP}"
        # Set the ownership for all files and folders to sc-owncloud:http
        find -L ${DIRAPP} -type d -print0 | xargs -0 chown ${EFF_USER}:${GROUP} 2>/dev/null
        find -L ${DIRAPP} -type f -print0 | xargs -0 chown ${EFF_USER}:${GROUP} 2>/dev/null
        # Use chmod on files and directories with different permissions
        # For all files use 0640
        find -L ${DIRAPP} -type f -print0 | xargs -0 chmod 640 2>/dev/null
        # For all directories use 0750
        find -L ${DIRAPP} -type d -print0 | xargs -0 chmod 750 2>/dev/null
        # For external data directory
        if [ -n "${DIRDATA}" ] && [ -d "${DIRDATA}" ]; then
            chown -R ${EFF_USER}:${GROUP} ${DIRDATA} 2>/dev/null
            find -L ${DIRDATA} -type f -print0 | xargs -0 chmod 640 2>/dev/null
            find -L ${DIRDATA} -type d -print0 | xargs -0 chmod 750 2>/dev/null
        fi
        # Set the occ command to executable
        chmod +x ${DIRAPP}/occ 2>/dev/null
    else
        echo "Notice: set_owncloud_permissions() is no longer required on DSM7."
    fi
}

exec_occ() {
    PHP="/usr/local/bin/php74"
    OCC="${OCROOT}/occ"
    COMMAND="${PHP} ${OCC} $*"
    if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 7 ]; then
        /bin/su "$EFF_USER" -s /bin/sh -c "$COMMAND"
    else
        $COMMAND
    fi
    return $?
}

service_prestart ()
{
    # Replace generic service startup, fork process in background
    echo "Starting owncloud-daemon at ${SYNOPKG_PKGDEST}/bin" >> ${LOG_FILE}
    COMMAND="${SYNOPKG_PKGDEST}/bin/owncloud-daemon"
    ${COMMAND} >> ${LOG_FILE} 2>&1 &
    echo "$!" > "${PID_FILE}"
}

service_postinst ()
{
    if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 7 ]; then
        # Install the web interface
        echo "Installing web interface"
        ${MKDIR} ${OCROOT}
        rsync -aX ${SYNOPKG_PKGDEST}/share/${SYNOPKG_PKGNAME}/ ${OCROOT} 2>&1

        # Install web configurations
        TEMPDIR="${SYNOPKG_PKGTMP}/web"
        ${MKDIR} ${TEMPDIR}
        WS_CFG_PATH="/usr/syno/etc/packages/WebStation"
        WS_CFG_FILE="WebStation.json"
        PHP_CFG_FILE="PHPSettings.json"
        PHP_PROF_NAME="Default PHP 7.4 Profile"
        WS_TMPL_PATH="/var/packages/WebStation/target/misc"
        WS_TMPL_FILE="php74_fpm.mustache"
        WS_BACKEND="$(${JQ} -r '.default.backend' ${WS_CFG_PATH}/${WS_CFG_FILE})"
        WS_PHP="$(${JQ} -r '.default.php' ${WS_CFG_PATH}/${WS_CFG_FILE})"
        CFG_UPDATE="no"
        # Check if Apache is the selected back-end
        if [ ! "$WS_BACKEND" = "2" ]; then
            echo "Set Apache as the back-end server"
            ${JQ} '.default.backend = 2' ${WS_CFG_PATH}/${WS_CFG_FILE} > ${TEMPDIR}/${WS_CFG_FILE}
            ${MV} ${WS_CFG_PATH}/${WS_CFG_FILE} ${WS_CFG_PATH}/${WS_CFG_FILE}.bak
            rsync -aX ${TEMPDIR}/${WS_CFG_FILE} ${WS_CFG_PATH}/ 2>&1
            ${RM} ${TEMPDIR}/${WS_CFG_FILE}
            CFG_UPDATE="yes"
        fi
        # Check if default PHP profile is selected
        if [ -z "$WS_PHP" ] || [ "$WS_PHP" = "null" ]; then
            echo "Enable default PHP profile"
            # Locate default PHP profile
            PHP_PROF_ID="$(${JQ} -r '. | to_entries[] | select(.value | type == "object" and .profile_desc == "'"$PHP_PROF_NAME"'") | .key' "${WS_CFG_PATH}/${PHP_CFG_FILE}")"
            ${JQ} ".default.php = \"$PHP_PROF_ID\"" "${WS_CFG_PATH}/${WS_CFG_FILE}" > ${TEMPDIR}/${WS_CFG_FILE}
            ${MV} ${WS_CFG_PATH}/${WS_CFG_FILE} ${WS_CFG_PATH}/${WS_CFG_FILE}.bak
            rsync -aX ${TEMPDIR}/${WS_CFG_FILE} ${WS_CFG_PATH}/ 2>&1
            ${RM} ${TEMPDIR}/${WS_CFG_FILE}
            CFG_UPDATE="yes"
        fi
        # Check for ownCloud PHP profile
        if ! ${JQ} -e '.["com-synocommunity-packages-owncloud"]' "${WS_CFG_PATH}/${PHP_CFG_FILE}" >/dev/null; then
            echo "Add PHP profile for ownCloud"
            ${JQ} --slurpfile ocNode ${SYNOPKG_PKGDEST}/web/owncloud.json '.["com-synocommunity-packages-owncloud"] = $ocNode[0]' ${WS_CFG_PATH}/${PHP_CFG_FILE} > ${TEMPDIR}/${PHP_CFG_FILE}
            ${MV} ${WS_CFG_PATH}/${PHP_CFG_FILE} ${WS_CFG_PATH}/${PHP_CFG_FILE}.bak
            rsync -aX ${TEMPDIR}/${PHP_CFG_FILE} ${WS_CFG_PATH}/ 2>&1
            ${RM} ${TEMPDIR}/${PHP_CFG_FILE}
            CFG_UPDATE="yes"
        fi
        # Check for updated PHP template
        if grep -q -E '^(user|listen\.owner) = http$' "${WS_TMPL_PATH}/${WS_TMPL_FILE}"; then
            echo "Update PHP template for ownCloud"
            rsync -aX ${WS_TMPL_PATH}/${WS_TMPL_FILE} ${TEMPDIR}/ 2>&1
            SUBST_TEXT="{{#fpm_settings.user_owncloud}}sc-owncloud{{/fpm_settings.user_owncloud}}{{^fpm_settings.user_owncloud}}http{{/fpm_settings.user_owncloud}}"
            ${SED} -i "s|^user = http$|user = ${SUBST_TEXT}|g; s|^listen.owner = http$|listen.owner = ${SUBST_TEXT}|g" "${TEMPDIR}/${WS_TMPL_FILE}"
            ${MV} ${WS_TMPL_PATH}/${WS_TMPL_FILE} ${WS_TMPL_PATH}/${WS_TMPL_FILE}.bak
            rsync -aX ${TEMPDIR}/${WS_TMPL_FILE} ${WS_TMPL_PATH}/ 2>&1
            ${RM} ${TEMPDIR}/${WS_TMPL_FILE}
            CFG_UPDATE="yes"
        fi
        # Check for ownCloud Apache config
        if [ ! -f "/usr/local/etc/apache24/sites-enabled/owncloud.conf" ]; then
            echo "Add Apache config for ownCloud"
            rsync -aX ${SYNOPKG_PKGDEST}/web/owncloud.conf /usr/local/etc/apache24/sites-enabled/ 2>&1
            CFG_UPDATE="yes"
        fi
        # Restart Apache if configs have changed
        if [ "$CFG_UPDATE" = "yes" ]; then
            echo "Restart Apache to load new configs"
            ${SYNOSVC} --restart pkgctl-Apache2.4
        fi
        # Clean-up temporary files
        ${RM} ${TEMPDIR}
    fi

    if [ "${SYNOPKG_PKG_STATUS}" = "INSTALL" ]; then
        # Parse data directory
        DATA_DIR="/volume1/${wizard_data_share}/data"
        # Create data directory
        ${MKDIR} "${DATA_DIR}"

        # Fix permissions
        if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 7 ]; then
            set_owncloud_permissions ${OCROOT} ${DATA_DIR}
        fi

        # Setup configuration file
        exec_occ maintenance:install \
        --database "sqlite" \
        --database-name "${SYNOPKG_PKGNAME}" \
        --data-dir "${DATA_DIR}" \
        --admin-user "${wizard_owncloud_admin_username}" \
        --admin-pass "${wizard_owncloud_admin_password}" 2>&1

        # Get the trusted domains
        DOMAINS="$(exec_occ config:system:get trusted_domains)"

        # Fix trusted domains array
        line_number=0
        echo "${DOMAINS}" | while read -r line; do
            if [ "$(echo "$line" | grep -cE ':5000|:5001')" -gt 0 ]; then
                # Remove ":5000" or ":5001" from the line and update the trusted_domains array
                new_line=$(echo "$line" | ${SED} -E 's/(:5000|:5001)//')
                exec_occ config:system:set trusted_domains $line_number --value="$new_line"
            fi
            line_number=$((line_number+1))
        done
        # Add user specified trusted domains
        line_number=$(( $(echo -ne "$DOMAINS" | wc -l) + 1 ))
        for var in wizard_owncloud_trusted_domain_1 wizard_owncloud_trusted_domain_2 wizard_owncloud_trusted_domain_3; do
            val="${!var}"
            if [ -n "$val" ]; then
                exec_occ config:system:set trusted_domains $line_number --value="$val"
                line_number=$((line_number+1))
            fi
        done

        # Add HTTP to HTTPS redirect to Apache configuration file
        APACHE_CONF="${OCROOT}/.htaccess"
        if [ -f "${APACHE_CONF}" ]; then
            echo "RewriteEngine On" >> ${APACHE_CONF}
            echo "RewriteCond %{HTTPS} off" >> ${APACHE_CONF}
            echo "RewriteRule ^(.*)$ https://%{HTTP_HOST}%{REQUEST_URI} [L,R=301]" >> ${APACHE_CONF}
        fi

        # Fix permissions
        if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 7 ]; then
            set_owncloud_permissions ${OCROOT} ${DATA_DIR}
        fi
    fi
}

service_preuninst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" = "UNINSTALL" ]; then
        # Check export directory
        if [ -n "${wizard_export_path}" ]; then
            # Get data directory
            DATADIR="$(exec_occ config:system:get datadirectory)"
            # Data directory fail-safe
            if [ ! -d "$DATADIR" ]; then
                echo "Invalid data directory '$DATADIR'. Using the default data directory instead."
                DATADIR="${OCROOT}/data"
            fi

            # Prepare archive structure
            TEMPDIR="${SYNOPKG_PKGTMP}/${SYNOPKG_PKGNAME}-backup_$(date +"%Y%m%d")"
            ${MKDIR} "${TEMPDIR}"

            # Check database export
            if [ "${wizard_export_database}" = "true" ]; then
                echo "Copying previous database from ${DATADIR}"
                ${MKDIR} "${TEMPDIR}/database"
                ${SQLITE} "${DATADIR}/${SYNOPKG_PKGNAME}.db" ".backup '${TEMPDIR}/database/${SYNOPKG_PKGNAME}.db'" 2>&1
            fi

            # Check configuration export
            if [ "${wizard_export_configs}" = "true" ]; then
                echo "Copying previous configuration from ${OCROOT}"
                ${MKDIR} "${TEMPDIR}/configs"
                ${CP} "${OCROOT}/.user.ini" "${TEMPDIR}/configs/"
                ${CP} "${OCROOT}/.htaccess" "${TEMPDIR}/configs/"
                ${MKDIR} "${TEMPDIR}/configs/config"
                source="${OCROOT}/config"
                patterns=(
                "*config.php"
                "*.json"
                )
                target="${TEMPDIR}/configs/config"
                # Process each pattern of files in the source directory
                for pattern in "${patterns[@]}"; do
                    files=$(find "$source" -type f -name "$pattern")
                    if [ -n "$files" ]; then
                        for file in "${files[@]}"; do
                            ${CP} "$file" "$target/"
                        done
                    fi
                done
            fi

            # Check user data export
            if [ "${wizard_export_userdata}" = "true" ]; then
                echo "Copying previous user data from ${DATADIR}"
                ${CP} "${DATADIR}" "${TEMPDIR}/"
            fi

            # Create backup archive
            archive_name="$(basename "$TEMPDIR").tar.gz"
            echo "Creating compressed archive of ownCloud data in file $archive_name"
            /bin/tar -czvf "${SYNOPKG_PKGTMP}/$archive_name" "$TEMPDIR" 2>&1

            # Move archive to export directory
            if ${RSYNC} "${SYNOPKG_PKGTMP}/$archive_name" "${wizard_export_path}/"; then
                echo "Backup file copied successfully to ${wizard_export_path}."
            else
                echo "File copy failed. Trying to copy to alternate location..."
                if ${RSYNC} "${SYNOPKG_PKGTMP}/$archive_name" "${SYNOPKG_PKGDEST_VOL}/@tmp/"; then
                    echo "Backup file copied successfully to alternate location (${SYNOPKG_PKGDEST_VOL}/@tmp)."
                else
                    echo "File copy failed. Backup of ownCloud data will not be saved."
                fi
            fi

            # Clean-up temporary files
            ${RM} "${TEMPDIR}"
            ${RM} "${SYNOPKG_PKGTMP}/$archive_name"
        fi
    fi
}

service_postuninst ()
{
    if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 7 ]; then
        # Remove the web interface
        ${RM} ${OCROOT}

        # Remove web configurations
        TEMPDIR="${SYNOPKG_PKGTMP}/web"
        ${MKDIR} ${TEMPDIR}
        WS_CFG_PATH="/usr/syno/etc/packages/WebStation"
        PHP_CFG_FILE="PHPSettings.json"
        WS_TMPL_PATH="/var/packages/WebStation/target/misc"
        WS_TMPL_FILE="php74_fpm.mustache"
        CFG_UPDATE="no"
        # Check for ownCloud PHP profile
        if ${JQ} -e '.["com-synocommunity-packages-owncloud"]' "${WS_CFG_PATH}/${PHP_CFG_FILE}" >/dev/null; then
            echo "Removing PHP profile for ownCloud"
            ${JQ} 'del(.["com-synocommunity-packages-owncloud"])' ${WS_CFG_PATH}/${PHP_CFG_FILE} > ${TEMPDIR}/${PHP_CFG_FILE}
            ${MV} ${WS_CFG_PATH}/${PHP_CFG_FILE} ${WS_CFG_PATH}/${PHP_CFG_FILE}.bak
            rsync -aX ${TEMPDIR}/${PHP_CFG_FILE} ${WS_CFG_PATH}/ 2>&1
            ${RM} ${TEMPDIR}/${PHP_CFG_FILE}
            CFG_UPDATE="yes"
        fi
        # Check for PHP template defaults
        if ! grep -q -E '^user = http$' "${WS_TMPL_PATH}/${WS_TMPL_FILE}" || ! grep -q -E '^listen\.owner = http$' "${WS_TMPL_PATH}/${WS_TMPL_FILE}"; then
            echo "Restore default PHP template"
            rsync -aX ${WS_TMPL_PATH}/${WS_TMPL_FILE} ${TEMPDIR}/ 2>&1
            SUBST_TEXT="{{#fpm_settings.user_owncloud}}sc-owncloud{{/fpm_settings.user_owncloud}}{{^fpm_settings.user_owncloud}}http{{/fpm_settings.user_owncloud}}"
            ${SED} -i "s|^user = ${SUBST_TEXT}$|user = http|g; s|^listen.owner = ${SUBST_TEXT}$|listen.owner = http|g" "${TEMPDIR}/${WS_TMPL_FILE}"
            ${MV} ${WS_TMPL_PATH}/${WS_TMPL_FILE} ${WS_TMPL_PATH}/${WS_TMPL_FILE}.bak
            rsync -aX ${TEMPDIR}/${WS_TMPL_FILE} ${WS_TMPL_PATH}/ 2>&1
            ${RM} ${TEMPDIR}/${WS_TMPL_FILE}
            CFG_UPDATE="yes"
        fi

        # Check for ownCloud Apache config
        if [ -f "/usr/local/etc/apache24/sites-enabled/owncloud.conf" ]; then
            echo "Removing Apache config for ownCloud"
            ${RM} /usr/local/etc/apache24/sites-enabled/owncloud.conf
            CFG_UPDATE="yes"
        fi
        # Restart Apache if configs have changed
        if [ "$CFG_UPDATE" = "yes" ]; then
            echo "Restart Apache to load new configs"
            ${SYNOSVC} --restart pkgctl-Apache2.4
        fi
        # Clean-up temporary files
        ${RM} ${TEMPDIR}
    fi
}

validate_preupgrade ()
{
    # ownCloud upgrades only possible from 8.2.11, 9.0.9, 9.1.X, or 10.X.Y
    is_upgrade_possible="no"
    valid_versions=("8.2.11" "9.0.9" "9.1.*" "10.*.*")
    previous=$(echo ${SYNOPKG_OLD_PKGVER} | cut -d'-' -f1)
    for version in "${valid_versions[@]}"; do
        if echo "$previous" | grep -q "$version"; then
            is_upgrade_possible="yes"
            break
        fi
    done

    # No matching ugrade paths found
    if [ "$is_upgrade_possible" = "no" ]; then
        echo "Please uninstall previous version, no update possible from v${SYNOPKG_OLD_PKGVER}.<br>Remember to save your ${OCROOT}/data files before uninstalling."
        exit 1
    fi
}

service_save ()
{
    # Place server in maintenance mode
    exec_occ maintenance:mode --on

    # Identify data directory for restore
    DATADIR="$(exec_occ config:system:get datadirectory)"
    # data directory fail-safe
    if [ ! -d "$DATADIR" ]; then
        echo "Invalid data directory '$DATADIR'. Using the default data directory instead."
        DATADIR="${OCROOT}/data"
    fi
    # Check if data directory inside owncloud directory and flag for restore if true
    DATADIR_REAL=$(realpath "$DATADIR")
    WEBROOT_REAL=$(realpath "${OCROOT}")
    if echo "$DATADIR_REAL" | grep -q "^$WEBROOT_REAL"; then
        echo "${DATADIR_REAL#"$WEBROOT_REAL/"}" > "${SYNOPKG_TEMP_UPGRADE_FOLDER}/.datadirectory"
    fi

    # Backup configuration and data
    [ -d ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME} ] && ${RM} ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}
    echo "Backup existing distribution to ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}"
    ${MKDIR} ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}
    rsync -aX ${OCROOT}/ ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME} 2>&1

    # Backup server database
    [ -d ${SYNOPKG_TEMP_UPGRADE_FOLDER}/db_backup ] && ${RM} ${SYNOPKG_TEMP_UPGRADE_FOLDER}/db_backup
    echo "Backup existing server database to ${SYNOPKG_TEMP_UPGRADE_FOLDER}/db_backup"
    ${MKDIR} ${SYNOPKG_TEMP_UPGRADE_FOLDER}/db_backup
    ${SQLITE} "${DATADIR}/${SYNOPKG_PKGNAME}.db" ".backup '${SYNOPKG_TEMP_UPGRADE_FOLDER}/db_backup/${SYNOPKG_PKGNAME}-dbbackup_$(date +"%Y%m%d").bak'" 2>&1
}

service_restore ()
{
    # Validate data directory for restore
    if [ -f ${SYNOPKG_TEMP_UPGRADE_FOLDER}/.datadirectory ]; then
        DATAPATH="$(cat ${SYNOPKG_TEMP_UPGRADE_FOLDER}/.datadirectory)"
        # Data directory inside owncloud directory and needs to be restored
        [ -d ${OCROOT}/${DATAPATH} ] && ${RM} ${OCROOT}/${DATAPATH}
        echo "Restore previous data directory from ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/${DATAPATH}"
        rsync -aX ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/${DATAPATH} ${OCROOT}/ 2>&1
        ${RM} ${SYNOPKG_TEMP_UPGRADE_FOLDER}/.datadirectory
    fi

    # Restore the configuration files
    echo "Restore previous configuration from ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}"
    source="${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/config"
    patterns=(
    "*config.php"
    "*.json"
    )
    target="${OCROOT}/config"
    # Process each pattern of files in the source directory
    for pattern in "${patterns[@]}"; do
        files=$(find "$source" -type f -name "$pattern")
        if [ -n "$files" ]; then
            for file in "${files[@]}"; do
                file_name=$(basename "$file")
                [ -f $target/$file_name ] && ${RM} $target/$file_name
                rsync -aX "$file" "$target/" 2>&1
            done
        fi
    done
    if [ -f ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/.user.ini ]; then
        [ -f ${OCROOT}/.user.ini ] && ${RM} ${OCROOT}/.user.ini
        rsync -aX ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/.user.ini ${OCROOT}/ 2>&1
    fi
    if [ -f ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/.htaccess ]; then
        [ -f ${OCROOT}/.htaccess ] && ${RM} ${OCROOT}/.htaccess
        rsync -aX ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/.htaccess ${OCROOT}/ 2>&1
    fi

    echo "Restore manually installed apps from ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}"
    # Migrate manually installed apps from source to destination directories
    dirs=(
    "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/apps"
    "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/apps-external"
    )
    dest="${OCROOT}"
    # Process the subdirectories in each of the source directories
    for dir in "${dirs[@]}"; do
        dir_name=$(basename "$dir")
        sub_dirs=()
        for item in "$dir"/*; do
            if [ -d "$item" ]; then
                sub_dirs+=("$item")
            fi
        done
        if [ ! -d "$dest/$dir_name" ]; then
            rsync -aX "$dir" "$dest/" 2>&1
        elif [ -n "$sub_dirs" ]; then
            for sub_dir in "${sub_dirs[@]}"; do
                sub_dir_name=$(basename "$sub_dir")
                # Check if the subdirectory is missing from the destination
                if [ ! -d "$dest/$dir_name/$sub_dir_name" ]; then
                    rsync -aX "$sub_dir" "$dest/$dir_name/" 2>&1
                fi
            done
        fi
    done

    # Fix permissions
    if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 7 ]; then
        set_owncloud_permissions ${OCROOT}
    fi

    # Disable maintenance mode
    exec_occ maintenance:mode --off

    # Finalize upgrade
    exec_occ upgrade

    DATADIR="$(exec_occ config:system:get datadirectory)"
    # Data directory fail-safe
    if [ ! -d "$DATADIR" ]; then
        echo "Invalid data directory '$DATADIR'. Using the default data directory instead."
        DATADIR="${OCROOT}/data"
    fi
    # Archive backup server database
    echo "Archive backup server database to ${DATADIR}"
    if [ -d ${SYNOPKG_TEMP_UPGRADE_FOLDER}/db_backup ]; then
        if [ -d ${DATADIR}/db_backup ]; then
            i=1
            while [ -d "${DATADIR}/db_backup.${i}" ]; do
                i=$((i+1))
            done
            while [ $i -gt 1 ]; do
                j=$((i-1))
                ${MV} "${DATADIR}/db_backup.${j}" "${DATADIR}/db_backup.${i}"
                i=$j
            done
            ${MV} "${DATADIR}/db_backup" "${DATADIR}/db_backup.1"
        fi
        rsync -aX ${SYNOPKG_TEMP_UPGRADE_FOLDER}/db_backup ${DATADIR}/ 2>&1
    fi

    # Remove upgrade backup files
    ${RM} ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}
    ${RM} ${SYNOPKG_TEMP_UPGRADE_FOLDER}/db_backup
}
