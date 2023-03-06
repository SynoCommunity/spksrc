
# ownCloud service setup
WEB_DIR="/var/services/web_packages"
# for backwards compatability
if [ $SYNOPKG_DSM_VERSION_MAJOR -lt 7 ];then
    WEB_DIR="/var/services/web"
fi

# Others
PHP="/usr/local/bin/php74"
SQLITE="/bin/sqlite3"
OCROOT="${WEB_DIR}/${SYNOPKG_PKGNAME}"
OCC="${PHP} ${OCROOT}/occ"

if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 7 ]; then
    GROUP="http"
fi

service_prestart ()
{
    # Replace generic service startup, fork process in background
    echo "Starting owncloud-daemon at ${SYNOPKG_PKGDEST}/bin" >> ${LOG_FILE}
    COMMAND="${SYNOPKG_PKGDEST}/bin/owncloud-daemon"
    ${COMMAND} >> ${LOG_FILE} 2>&1 &
    echo "$!" > "${PID_FILE}"
}

service_preinst ()
{
    :
}

service_postinst ()
{
    if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 7 ]; then
        # Install the web interface
        ${MKDIR} ${OCROOT}
        rsync -aX ${SYNOPKG_PKGDEST}/share/${SYNOPKG_PKGNAME}/ ${OCROOT} 2>&1
        # Fix permissions
        chown -R ${SYNOPKG_USERNAME} ${OCROOT} 2>&1
        chgrp -R ${GROUP} ${OCROOT} 2>&1
        chmod -R 0755 ${OCROOT} 2>&1
    fi

    if [ "${SYNOPKG_PKG_STATUS}" = "INSTALL" ]; then
        # Create data directory
        ${MKDIR} "${wizard_owncloud_datadirectory}"

        # Setup configuration file
        ${OCC} maintenance:install \
        --database "sqlite" \
        --database-name "${SYNOPKG_PKGNAME}" \
        --data-dir "${wizard_owncloud_datadirectory}" \
        --admin-user "${wizard_owncloud_admin_username}" \
        --admin-pass "${wizard_owncloud_admin_password}" 2>&1

        # Get the trusted domains
        DOMAINS="$(${OCC} config:system:get trusted_domains)"

        # Fix trusted domains array
        line_number=0
        echo "${DOMAINS}" | while read -r line; do
            if [ "$(echo "$line" | grep -cE ':5000|:5001')" -gt 0 ]; then
                # Remove ":5000" or ":5001" from the line and update the trusted_domains array
                new_line=$(echo "$line" | sed -E 's/(:5000|:5001)//')
                ${OCC} config:system:set trusted_domains $line_number --value="$new_line"
            fi
            line_number=$((line_number+1))
        done
        # Add user specified trusted domains
        line_number=$(( $(echo -ne "$DOMAINS" | wc -l) + 1 ))
        for var in wizard_owncloud_trusted_domain_1 wizard_owncloud_trusted_domain_2 wizard_owncloud_trusted_domain_3; do
            val="${!var}"
            if [ -n "$val" ]; then
                ${OCC} config:system:set trusted_domains $line_number --value="$val"
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

        if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 7 ]; then
            # Fix permissions
            chown -R ${SYNOPKG_USERNAME} ${wizard_owncloud_datadirectory} 2>&1
            chgrp -R ${GROUP} ${wizard_owncloud_datadirectory} 2>&1
            chmod -R 0755 ${wizard_owncloud_datadirectory} 2>&1
        fi
    fi
}

service_preuninst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" = "UNINSTALL" ]; then
        # Check export directory
        if [ -n "${wizard_export_path}" ]; then
            # Get data directory
            DATADIR="$(${OCC} config:system:get datadirectory)"

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
                            file_name=$(basename "$file")
                            ${CP} "$file" "$target/"
                        done
                    fi
                done
            fi

            # Check user data export
            if [ "${wizard_export_userdata}" = "true" ]; then
                echo "Copying previous user data from ${DATADIR}"
                dir_name=$(basename "$DATADIR")
                ${MKDIR} "${TEMPDIR}/$dir_name"
                ${CP} "${DATADIR}" "${TEMPDIR}/$dir_name/"
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
        fi
    fi
}

service_postuninst ()
{
    if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 7 ]; then
        # Remove the web interface
        ${RM} ${OCROOT}
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
    ${OCC} maintenance:mode --on

    # Identify data directory for restore
    DATADIR=$(realpath "$(${OCC} config:system:get datadirectory)")
    WEBROOT=$(realpath "${OCROOT}")
    if echo "$DATADIR" | grep -q "^$WEBROOT"; then
        echo "${DATADIR#"$WEBROOT/"}" > "${SYNOPKG_TEMP_UPGRADE_FOLDER}/.datadirectory"
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
                [ -f $target/$file_name ] && ${MV} $target/$file_name $target/$file_name.bak
                rsync -aX "$file" "$target/" 2>&1
            done
        fi
    done
    if [ -f ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/.user.ini ]; then
        [ -f ${OCROOT}/.user.ini ] && ${MV} ${OCROOT}/.user.ini ${OCROOT}/.user.ini.bak
        rsync -aX ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/.user.ini ${OCROOT}/ 2>&1
    fi
    if [ -f ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/.htaccess ]; then
        [ -f ${OCROOT}/.htaccess ] && ${MV} ${OCROOT}/.htaccess ${OCROOT}/.htaccess.bak
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

    # Disable maintenance mode
    ${OCC} maintenance:mode --off

    # Finalize upgrade
    ${OCC} upgrade

    DATADIR=$(realpath "$(${OCC} config:system:get datadirectory)")
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

service_preupgrade ()
{
    :
}

service_postupgrade ()
{
    :
}
