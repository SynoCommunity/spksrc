
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
    
    exit 0
}

service_postinst ()
{
    if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 7 ]; then
        # Install the web interface
        ${MKDIR} ${OCROOT}
        rsync -aX ${SYNOPKG_PKGDEST}/share/${SYNOPKG_PKGNAME}/ ${OCROOT} 2>&1
        # Fix permissions
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

        # Add HTTP to HTTPS redirect to Apache configuration file
        APACHE_CONF="${OCROOT}/.htaccess"
        if [ -f "${APACHE_CONF}" ]; then
            echo "RewriteEngine On" >> ${APACHE_CONF}
            echo "RewriteCond %{HTTPS} off" >> ${APACHE_CONF}
            echo "RewriteRule ^(.*)$ https://%{HTTP_HOST}%{REQUEST_URI} [L,R=301]" >> ${APACHE_CONF}
        fi
    fi

    exit 0
}

service_preuninst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" = "UNINSTALL" ]; then
        # Check database export location
        if [ -f "${wizard_dbexport_path}" ] || [ -e "${wizard_dbexport_path}/${SYNOPKG_PKGNAME}.db" ]; then
            echo "The export location already exists as a file or a directory containing a file named ${SYNOPKG_PKGNAME}.db. Please remove the file or choose a different location."
            exit 1
        fi

        # Check that the path is writable
        if [ -d "${wizard_dbexport_path}" ] && [ ! -w "${wizard_dbexport_path}" ]; then
            echo "Export directory exists but does not allow writing. Please add write permissions for the user 'sc-${SYNOPKG_PKGNAME}'."
            exit 1
        fi

        # Get data directory
        DATADIR="$(${OCC} config:system:get datadirectory)"
        # Export database
        if [ -n "${wizard_dbexport_path}" ]; then
            ${MKDIR} -p ${wizard_dbexport_path}
            ${SQLITE} "${DATADIR}/${SYNOPKG_PKGNAME}.db" ".backup '${wizard_dbexport_path}/${SYNOPKG_PKGNAME}.db'" 2>&1
        fi
    fi

    exit 0
}

service_postuninst ()
{
    if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 7 ]; then
        # Remove the web interface
        ${RM} ${OCROOT}
    fi

    exit 0
}

### NEW LOGIC TO CREATE / VALIDATE FOR UPGRADES ###

# From: https://doc.owncloud.com/server/next/admin_manual/maintenance/upgrading/manual_upgrade.html

### PREPARATION

# 1. Put your server in maintenance mode and disable Cron jobs.
#    From: https://doc.owncloud.com/server/next/admin_manual/maintenance/enable_maintenance.html
#       sudo -u www-data ./occ maintenance:mode --on
#    From: https://doc.owncloud.com/server/next/admin_manual/troubleshooting/remove_non_existent_bg_jobs.html#remove-the-background-job
#       sudo -u www-data ./occ background:queue:status
#       sudo -u www-data ./occ background:queue:delete ID
# 2. Stop your webserver to prevent users trying to access ownCloud via the web
#       sudo service apache2 stop
# 3. Backup ownCloud and the server database
#    From: https://doc.owncloud.com/server/next/admin_manual/maintenance/backup_and_restore/backup.html
#       rsync -Aax config data apps apps-external /oc-backupdir/
#       sqlite3 data/owncloud.db .dump > owncloud-dbbackup_`date +"%Y%m%d"`.bak
#       ?? sudo crontab -u www-data -l > www-data_crontab.bak
# 4. Review any installed third-party apps for compatibility with the new ownCloud release. 
#    Ensure that they are all disabled before beginning the upgrade.
#       sudo -u www-data ./occ app:list
#       sudo -u www-data ./occ app:disable <app-id>
# 5. Backup Manual Changes in .htaccess
# 6. Backup Manual Changes in .user.ini

### UPGRADE

# 7.Move Current ownCloud Directory
#       sudo mv /var/www/owncloud /var/www/backup_owncloud
# 8. Extract the New Source
#    ?? Should this automatically happen as part of the package function and put in place?
# 9. Copy the data/ Directory
#    ?? Check if the data directory is inside your owncloud/ directory. Sample code to check pre-upgrade:
#       if [[ $(realpath $potential_subdir) =~ ^$(realpath $parent_dir) ]]; then
#           echo "$potential_subdir is a subdirectory of $parent_dir"
#       else
#           echo "$potential_subdir is not a subdirectory of $parent_dir"
#       fi
#    ?? If true, move it from your old version of ownCloud to your new version
#       sudo mv /var/www/backup_owncloud/data /var/www/owncloud/data
#10. Copy Relevant config.php Content
#       sudo cp /var/www/backup_owncloud/config/*config.php \
#       /var/www/owncloud/config/
#       sudo cp /var/www/backup_owncloud/config/*.json \
#       /var/www/owncloud/config/
#11. Market and Marketplace App Upgrades
#12. Copy Old Apps
#    ?? If you are using third party applications, look in your new /var/www/owncloud/apps/
#    or /var/www/owncloud/apps-external/ directory to see if they are present.
#    If not, copy them from your old instance to your new one.
#13. Set correct ownership
#       sudo find -L /var/www/owncloud \
#           \( -path ./data -o -path ./config \) -prune -o \
#           -type f -print0 | sudo xargs -0 chown root:www-data
#14. Set correct permissions
#       sudo find -L /var/www/owncloud -type f -print0 | sudo xargs -0 chmod 640
#       sudo find -L /var/www/owncloud -type d -print0 | sudo xargs -0 chmod 750
#       sudo chmod +x /var/www/owncloud/occ

### FINALIZE

#15. Start the Upgrade
#       sudo -u www-data ./occ upgrade
#16. Reapply Manual Changes
#       ?? Manual Changes in .htaccess can be re-applied using installer logic
#       diff -y -W 70 --suppress-common-lines owncloud/.user.ini owncloud_2022-02-15-09.18.48/.user.ini
#17. Strong Permissions
#    Check that chmod with 0640 for .htaccess and .user.ini files has been applied.
#18. Disable Maintenance Mode
#       sudo -u www-data ./occ maintenance:mode --off
#19. Enable Browser Access
#       sudo service apache2 start
#20. Check the Upgrade
#    After the upgrade is complete, re-enable any third-party apps that are compatible with the new release.
#    ?? Use occ app:enable <app-id> to enable all compatible third-party apps.

service_preupgrade ()
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

    exit 0
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

    # Archive backup server database
    echo "Archive backup server database to ${OCROOT}/data"
    if [ -d ${SYNOPKG_TEMP_UPGRADE_FOLDER}/db_backup ]; then
        if [ -d ${OCROOT}/data/db_backup ]; then
            i=1
            while [ -d "${OCROOT}/data/db_backup.${i}" ]
            do
                i=$((i+1))
            done
            while [ $i -gt 1 ]; do
                j=$((i-1))
                ${MV} "${OCROOT}/data/db_backup.${j}" "${OCROOT}/data/db_backup.${i}"
                i=$j
            done
            ${MV} "${OCROOT}/data/db_backup" "${OCROOT}/data/db_backup.1"
        fi
        rsync -aX ${SYNOPKG_TEMP_UPGRADE_FOLDER}/db_backup ${OCROOT}/data/ 2>&1
    fi

    # Restore the configuration files
    echo "Restoring previous configuration from ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}"
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

    echo "Restoring manually installed apps from ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}"
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

    # Remove upgrade backup files
    ${RM} ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}

    exit 0
}

service_postupgrade ()
{
    :
    
    exit 0
}
