
# ownCloud service setup
SC_DNAME="ownCloud"
SC_PKG_PREFIX="com-synocommunity-packages-"
SC_PKG_NAME="${SC_PKG_PREFIX}${SYNOPKG_PKGNAME}"

WEB_DIR="/var/services/web_packages"
# for backwards compatability
if [ $SYNOPKG_DSM_VERSION_MAJOR -lt 7 ];then
    WEB_DIR="/var/services/web"
fi
if [ -z "${SYNOPKG_PKGTMP}" ]; then
    SYNOPKG_PKGTMP="${SYNOPKG_PKGDEST_VOL}/@tmp"
fi

# Others
MYSQL="/usr/local/mariadb10/bin/mysql"
MYSQLDUMP="/usr/local/mariadb10/bin/mysqldump"
MYSQL_DATABASE="${SYNOPKG_PKGNAME}"
MYSQL_USER="oc_${wizard_owncloud_admin_username}"
WEB_ROOT="${WEB_DIR}/${SYNOPKG_PKGNAME}"
SYNOSVC="/usr/syno/sbin/synoservice"

if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 7 ]; then
    WEB_USER="http"
    WEB_GROUP="http"
fi

# Function to compare two version numbers
version_greater_equal() {
    v1=$(echo "$1" | awk -F. '{ printf "%d%03d%03d\n", $1, $2, $3 }')
    v2=$(echo "$2" | awk -F. '{ printf "%d%03d%03d\n", $1, $2, $3 }')
    [ "$v1" -ge "$v2" ]
}

set_owncloud_permissions ()
{
    if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 7 ]; then
        DIRAPP=$1
        DIRDATA=$2
        echo "Setting the correct ownership and permissions of the files and folders in ${DIRAPP}"
        # Set the ownership for all files and folders to http:http
        find -L ${DIRAPP} -type d -print0 | xargs -0 chown ${WEB_USER}:${WEB_GROUP} 2>/dev/null
        find -L ${DIRAPP} -type f -print0 | xargs -0 chown ${WEB_USER}:${WEB_GROUP} 2>/dev/null
        # Use chmod on files and directories with different permissions
        # For all files use 0640
        find -L ${DIRAPP} -type f -print0 | xargs -0 chmod 640 2>/dev/null
        # For all directories use 0750
        find -L ${DIRAPP} -type d -print0 | xargs -0 chmod 750 2>/dev/null
        # For external data directory
        if [ -n "${DIRDATA}" ] && [ -d "${DIRDATA}" ]; then
            chown -R ${WEB_USER}:${WEB_GROUP} ${DIRDATA} 2>/dev/null
            find -L ${DIRDATA} -type f -print0 | xargs -0 chmod 640 2>/dev/null
            find -L ${DIRDATA} -type d -print0 | xargs -0 chmod 750 2>/dev/null
        fi
        # Set the occ command to executable
        chmod +x ${DIRAPP}/occ 2>/dev/null
    else
        echo "Notice: set_owncloud_permissions() is no longer required on DSM 7."
    fi
}

exec_occ() {
    PHP="/usr/local/bin/php74"
    OCC="${WEB_ROOT}/occ"
    COMMAND="${PHP} ${OCC} $*"
    if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 7 ]; then
        # Escape backslashes for DSM 6
        ESCAPED_COMMAND=$(echo "$COMMAND" | sed 's/\\/\\\\/g')
        /bin/su "$WEB_USER" -s /bin/sh -c "$ESCAPED_COMMAND"
    else
        $COMMAND
    fi
    return $?
}

setup_owncloud_instance()
{
    if [ "${SYNOPKG_PKG_STATUS}" = "INSTALL" ]; then
        # Setup database
        ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e "CREATE DATABASE ${MYSQL_DATABASE}; GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'localhost' IDENTIFIED BY '${wizard_mysql_password_owncloud}';"

        # Setup configuration file
        exec_occ maintenance:install \
        --database "mysql" \
        --database-name "${MYSQL_DATABASE}" \
        --database-host "localhost:/run/mysqld/mysqld10.sock" \
        --database-user "${MYSQL_USER}" \
        --database-pass "${wizard_mysql_password_owncloud}" \
        --admin-user "${wizard_owncloud_admin_username}" \
        --admin-pass "${wizard_owncloud_admin_password}" \
        --data-dir "${DATA_DIR}" 2>&1

        # Get the trusted domains
        DOMAINS="$(exec_occ config:system:get trusted_domains)"

        # Fix trusted domains array
        line_number=0
        echo "${DOMAINS}" | while read -r line; do
            if echo "$line" | grep -qE ':5000|:5001'; then
                # Remove ":5000" or ":5001" from the line and update the trusted_domains array
                new_line=$(echo "$line" | sed -E 's/(:5000|:5001)//')
                exec_occ config:system:set trusted_domains $line_number --value="$new_line"
            fi
            line_number=$((line_number + 1))
        done

        # Refresh the trusted domains
        DOMAINS="$(exec_occ config:system:get trusted_domains)"

        # Add user-specified trusted domains
        line_number=$(echo "$DOMAINS" | wc -l)
        for var in wizard_owncloud_trusted_domain_1 wizard_owncloud_trusted_domain_2 wizard_owncloud_trusted_domain_3; do
            eval val=\$$var
            if [ -n "$val" ]; then
                # Check if the domain is already in the trusted domains
                if ! echo "$DOMAINS" | grep -qx "$val"; then
                    exec_occ config:system:set trusted_domains $line_number --value="$val"
                    line_number=$((line_number + 1))
                fi
            fi
        done

        APACHE_CONF="${WEB_ROOT}/.htaccess"
        # Configure HTTP to HTTPS redirect
        if [ -f "${APACHE_CONF}" ]; then
            {
                echo "RewriteEngine On"
                echo "RewriteCond %{HTTPS} off"
                echo "RewriteRule ^(.*)$ https://%{HTTP_HOST}%{REQUEST_URI} [L,R=301]"
            } >> "${APACHE_CONF}"
        fi

        # Configure HTTP Strict Transport Security
        if [ -f "${APACHE_CONF}" ]; then
            {
                echo "<IfModule mod_headers.c>"
                echo "Header always set Strict-Transport-Security \"max-age=15552000; includeSubDomains\""
                echo "</IfModule>"
            } >> "${APACHE_CONF}"
        fi

        # Configure background jobs
        exec_occ system:cron

        # Configure memory caching
        MEMCACHE_LOCAL_VAL="\\OC\\Memcache\\APCu"
        exec_occ config:system:set memcache.local --value="$MEMCACHE_LOCAL_VAL"

        # Configure file locking
        MEMCACHE_LOCKING_VAL="\\OC\\Memcache\\Redis"
        exec_occ config:system:set memcache.locking --value="$MEMCACHE_LOCKING_VAL"
        exec_occ config:system:set filelocking.enabled --value="true"
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

    if [ "${SYNOPKG_PKG_STATUS}" = "INSTALL" ]; then
        # Check database
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
        if [ "${wizard_owncloud_restore}" = "true" ] && [ -n "${wizard_backup_file}" ]; then
            if [ ! -f "${wizard_backup_file}" ]; then
                echo "The backup file path specified is incorrect or not accessible."
                exit 1
            fi
            # Check backup file prefix
            filename=$(basename "${wizard_backup_file}")
            expected_prefix="${SYNOPKG_PKGNAME}_backup_v"
            
            if [ "${filename#"$expected_prefix"}" = "$filename" ]; then
                echo "The backup filename does not start with the expected prefix."
                exit 1
            fi
            # Check the minimum required version
            backup_version=$(echo "$filename" | sed -n "s/${expected_prefix}\([0-9]\+\.[0-9]\+\.[0-9]\+\).*/\1/p")
            min_version="10.15.0"
            if ! version_greater_equal "$backup_version" "$min_version"; then
                echo "The backup version is too old. Minimum required version is $min_version."
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
        set_owncloud_permissions ${WEB_ROOT}
    fi

    if [ "${SYNOPKG_PKG_STATUS}" = "INSTALL" ]; then
        # Parse data directory
        DATA_DIR="${SHARE_PATH}/data"
        # Create data directory
        ${MKDIR} "${DATA_DIR}"
        # Fix permissions
        if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 7 ]; then
            chown -R ${WEB_USER}:${WEB_GROUP} ${DATA_DIR} 2>/dev/null
        fi

        # Check restore action
        if [ "${wizard_owncloud_restore}" = "true" ]; then
            echo "The backup file is valid, performing restore."
            # Extract archive to temp folder
            TEMPDIR="${SYNOPKG_PKGTMP}/${SYNOPKG_PKGNAME}"
            ${MKDIR} "${TEMPDIR}"
            tar -xzf "${wizard_backup_file}" -C "${TEMPDIR}" 2>&1
            # Fix file ownership
            if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 7 ]; then
                chown -R ${WEB_USER}:${WEB_GROUP} ${TEMPDIR} 2>/dev/null
            fi

            # Restore configuration files and directories
            rsync -aX -I "${TEMPDIR}/configs/root/.user.ini" "${TEMPDIR}/configs/root/.htaccess" "${WEB_ROOT}/" 2>&1
            rsync -aX -I "${TEMPDIR}/configs/config" "${TEMPDIR}/configs/apps" "${TEMPDIR}/configs/apps-external" "${WEB_ROOT}/" 2>&1

            # Restore user data
            echo "Restoring user data to ${DATA_DIR}"
            rsync -aX -I "${TEMPDIR}/data" "${SHARE_PATH}/" 2>&1

            # Restore the Database
            db_user=$(grep "'dbuser'" "${WEB_ROOT}/config/config.php" | sed -n "s/.*'dbuser' => '\(.*\)'.*/\1/p")
            db_password=$(grep "'dbpassword'" "${WEB_ROOT}/config/config.php" | sed -n "s/.*'dbpassword' => '\(.*\)'.*/\1/p")

            echo "Creating database ${MYSQL_DATABASE} and access"
            ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e "CREATE DATABASE ${MYSQL_DATABASE}; GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${db_user}'@'localhost' IDENTIFIED BY '${db_password}';" 2>&1

            echo "Restoring database ${MYSQL_DATABASE} from backup"
            ${MYSQL} -u root -p"${wizard_mysql_password_root}" ${MYSQL_DATABASE} < ${TEMPDIR}/database/${MYSQL_DATABASE}-dbbackup.sql 2>&1

            # Update the systems data-fingerprint after a backup is restored
            exec_occ maintenance:data-fingerprint -n

            # Disable maintenance mode
            exec_occ maintenance:mode --off

            # Set backup filename and expected prefix
            filename=$(basename "${wizard_backup_file}")
            expected_prefix="${SYNOPKG_PKGNAME}_backup_v"
            # Extract the version number using awk and cut
            file_version=$(echo "$filename" | awk -F "${expected_prefix}" '{print $2}' | cut -d '_' -f 1)
            package_version=$(echo "${SYNOPKG_PKGVER}" | cut -d '-' -f 1)
            # Compare the extracted version with package_version using the version_greater_equal function
            if [ -n "$file_version" ]; then
                if ! version_greater_equal "$file_version" "$package_version"; then
                    echo "The archive version ($file_version) is older than the package version ($package_version). Triggering upgrade."
                    exec_occ upgrade
                fi
            fi

            # Configure background jobs
            exec_occ system:cron

            # Clean-up temporary files
            ${RM} "${TEMPDIR}"
        else
            echo "Run ${SC_DNAME} installer"
            setup_owncloud_instance
        fi

        # Fix permissions
        if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 7 ]; then
            set_owncloud_permissions ${WEB_ROOT} ${DATA_DIR}
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
        # Get data directory
        DATADIR="$(exec_occ config:system:get datadirectory)"
        # Data directory fail-safe
        if [ ! -d "$DATADIR" ]; then
            echo "Invalid data directory '$DATADIR'. Using the default data directory instead."
            DATADIR="${WEB_ROOT}/data"
        fi

        # Prepare archive structure
        OCC_VER=$(exec_occ -V | cut -d ' ' -f 2)
        TEMPDIR="${SYNOPKG_PKGTMP}/${SYNOPKG_PKGNAME}_backup_v${OCC_VER}_$(date +"%Y%m%d")"
        ${MKDIR} "${TEMPDIR}"

        # Place server in maintenance mode
        exec_occ maintenance:mode --on

        # Backup the Database
        echo "Copying previous database from ${MYSQL_DATABASE}"
        ${MKDIR} "${TEMPDIR}/database"
        ${MYSQLDUMP} -u root -p"${wizard_mysql_password_root}" ${MYSQL_DATABASE} > ${TEMPDIR}/database/${MYSQL_DATABASE}-dbbackup.sql 2>&1

        # Backup Directories
        echo "Copying previous configuration from ${WEB_ROOT}"
        ${MKDIR} "${TEMPDIR}/configs/root"
        rsync -aX "${WEB_ROOT}/.user.ini" "${WEB_ROOT}/.htaccess" "${TEMPDIR}/configs/root/" 2>&1
        rsync -aX "${WEB_ROOT}/config" "${WEB_ROOT}/apps" "${WEB_ROOT}/apps-external" "${TEMPDIR}/configs/" 2>&1

        # Backup user data
        echo "Copying previous user data from ${DATADIR}"
        rsync -aX "${DATADIR}" "${TEMPDIR}/" 2>&1

        # Disable maintenance mode
        exec_occ maintenance:mode --off

        # Create backup archive
        archive_name="$(basename "$TEMPDIR").tar.gz"
        echo "Creating compressed archive of ${SC_DNAME} data in file $archive_name"
        tar -C "$TEMPDIR" -czf "${SYNOPKG_PKGTMP}/$archive_name" . 2>&1

        # Move archive to export directory
        RSYNC_BAK_ARGS="--backup --suffix=.bak"
        rsync -aX ${RSYNC_BAK_ARGS} "${SYNOPKG_PKGTMP}/$archive_name" "${wizard_export_path}/" 2>&1
        echo "Backup file copied successfully to ${wizard_export_path}."

        # Clean-up temporary files
        ${RM} "${TEMPDIR}"
        ${RM} "${SYNOPKG_PKGTMP}/$archive_name"
    fi

    # Remove database
    if [ "${SYNOPKG_PKG_STATUS}" = "UNINSTALL" ]; then
        MYSQL_USER="$(exec_occ config:system:get dbuser)"

        echo "Dropping database: ${MYSQL_DATABASE}"
        ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e "DROP DATABASE ${MYSQL_DATABASE};"
        
        # Fetch users matching MYSQL_USER and drop them
        ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e "SELECT User, Host FROM mysql.user;" | grep "${MYSQL_USER}" | while read -r user host; do
            # Construct the DROP USER command
            drop_command="DROP USER '${user}'@'${host}';"
            echo "Dropping user: ${user}@${host}"
            ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e "$drop_command"
        done
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

validate_preupgrade ()
{
    # ownCloud upgrades only possible from 8.2.11, 9.0.9, 9.1.X, or 10.X.Y
    is_upgrade_possible="no"
    previous=$(echo "${SYNOPKG_OLD_PKGVER}" | cut -d '-' -f 1)
    
    # Check against valid versions
    for version in "8.2.11" "9.0.9" "9.1." "10."; do
        if echo "$previous" | grep -q "^$version"; then
            is_upgrade_possible="yes"
            break
        fi
    done

    # No matching upgrade paths found
    if [ "$is_upgrade_possible" = "no" ]; then
        echo "Please uninstall previous version, no update possible from v${SYNOPKG_OLD_PKGVER}.<br/>Remember to save your ${WEB_ROOT}/data files before uninstalling."
        exit 1
    fi

    # ownCloud upgrades only possible from mySQL instances
    DATABASE_TYPE="$(exec_occ config:system:get dbtype)"
    if [ "$DATABASE_TYPE" != "mysql" ]; then
        echo "Please migrate your previous database from ${DATABASE_TYPE} to mysql before performing upgrade."
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
        DATADIR="${WEB_ROOT}/data"
    fi
    # Check if data directory inside owncloud directory and flag for restore if true
    DATADIR_REAL=$(realpath "$DATADIR")
    WEBROOT_REAL=$(realpath "${WEB_ROOT}")
    if echo "$DATADIR_REAL" | grep -q "^$WEBROOT_REAL"; then
        echo "${DATADIR_REAL#"$WEBROOT_REAL/"}" > "${SYNOPKG_TEMP_UPGRADE_FOLDER}/.datadirectory"
    fi

    # Backup configuration and data
    [ -d ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME} ] && ${RM} ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}
    echo "Backup existing distribution to ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}"
    ${MKDIR} ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}
    rsync -aX ${WEB_ROOT}/ ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME} 2>&1
}

service_restore ()
{
    # Validate data directory for restore
    if [ -f ${SYNOPKG_TEMP_UPGRADE_FOLDER}/.datadirectory ]; then
        DATAPATH=$(cat ${SYNOPKG_TEMP_UPGRADE_FOLDER}/.datadirectory)
        # Data directory inside owncloud directory and needs to be restored
        echo "Restore previous data directory from ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/${DATAPATH}"
        rsync -aX -I ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/${DATAPATH} ${WEB_ROOT}/ 2>&1
        ${RM} ${SYNOPKG_TEMP_UPGRADE_FOLDER}/.datadirectory
    fi

    # Restore the configuration files
    echo "Restore previous configuration from ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}"
    source="${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/config"
    patterns="*config.php *.json"
    target="${WEB_ROOT}/config"
    
    # Process each pattern of files in the source directory
    for pattern in $patterns; do
        files=$(find "$source" -type f -name "$pattern")
        if [ -n "$files" ]; then
            for file in $files; do
                rsync -aX -I "$file" "$target/" 2>&1
            done
        fi
    done
    
    if [ -f ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/.user.ini ]; then
        rsync -aX -I ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/.user.ini ${WEB_ROOT}/ 2>&1
    fi
    if [ -f ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/.htaccess ]; then
        rsync -aX -I ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/.htaccess ${WEB_ROOT}/ 2>&1
    fi

    echo "Restore manually installed apps from ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}"
    # Migrate manually installed apps from source to destination directories
    dirs="${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/apps ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/apps-external"
    dest="${WEB_ROOT}"
    
    # Process the subdirectories in each of the source directories
    for dir in $dirs; do
        dir_name=$(basename "$dir")
        sub_dirs=$(find "$dir" -mindepth 1 -maxdepth 1 -type d)
        
        if [ ! -d "$dest/$dir_name" ]; then
            rsync -aX "$dir" "$dest/" 2>&1
        elif [ -n "$sub_dirs" ]; then
            for sub_dir in $sub_dirs; do
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
        set_owncloud_permissions ${WEB_ROOT}
    fi

    # Disable maintenance mode
    exec_occ maintenance:mode --off

    # Finalize upgrade
    exec_occ upgrade

    DATADIR=$(exec_occ config:system:get datadirectory)
    # Data directory fail-safe
    if [ ! -d "$DATADIR" ]; then
        echo "Invalid data directory '$DATADIR'. Using the default data directory instead."
        DATADIR="${WEB_ROOT}/data"
    fi
    
    # Remove upgrade backup files
    ${RM} ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}
}
