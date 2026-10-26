# ownCloud service setup (DSM 7, PHP 8.3)
WEB_ROOT="/var/services/web_packages/${SYNOPKG_PKGNAME}"
if [ -z "${SYNOPKG_PKGTMP}" ]; then
    SYNOPKG_PKGTMP="${SYNOPKG_PKGDEST_VOL}/@tmp"
fi

# Others
MYSQL="/usr/local/mariadb10/bin/mysql"
MYSQLDUMP="/usr/local/mariadb10/bin/mysqldump"
MYSQL_DATABASE="${SYNOPKG_PKGNAME}"
MYSQL_USER="oc_${wizard_owncloud_admin_username}"

# Function to compare two version numbers
version_greater_equal() {
    v1=$(echo "$1" | awk -F. '{ printf "%d%03d%03d\n", $1, $2, $3 }')
    v2=$(echo "$2" | awk -F. '{ printf "%d%03d%03d\n", $1, $2, $3 }')
    [ "$v1" -ge "$v2" ]
}

# Read a scalar from config/config.php without running PHP.
config_get() {
    sed -n "s/^[[:space:]]*'$1'[[:space:]]*=>[[:space:]]*'\([^']*\)'.*/\1/p" "${WEB_ROOT}/config/config.php" 2>/dev/null | head -1
}

# Append the HTTPS redirect and HSTS rules. The integrity check ignores
# everything after the "DO NOT CHANGE ANYTHING ABOVE THIS LINE" marker, so this
# does not affect code signing.
configure_htaccess() {
    local conf="${WEB_ROOT}/.htaccess"
    [ -f "${conf}" ] || return 0
    # ownCloud writes its integrity marker and dynamic rules through occ. The
    # marker is what lets the integrity check ignore our appends.
    if ! grep -q "DO NOT CHANGE ANYTHING ABOVE THIS LINE" "${conf}" 2>/dev/null; then
        exec_occ maintenance:update:htaccess >/dev/null 2>&1 || true
    fi
    if ! grep -q "DO NOT CHANGE ANYTHING ABOVE THIS LINE" "${conf}" 2>/dev/null; then
        echo "WARNING: .htaccess has no integrity marker; not adding HTTPS/HSTS rules" >&2
        return 0
    fi
    grep -q "Strict-Transport-Security" "${conf}" 2>/dev/null && return 0
    {
        echo ""
        echo "# Added by the SynoCommunity package: HTTPS redirect and HSTS"
        echo "<IfModule mod_rewrite.c>"
        echo "RewriteEngine On"
        echo "RewriteCond %{HTTPS} off"
        echo "RewriteRule ^(.*)$ https://%{HTTP_HOST}%{REQUEST_URI} [L,R=301]"
        echo "</IfModule>"
        echo "<IfModule mod_headers.c>"
        echo "Header always set Strict-Transport-Security \"max-age=15552000; includeSubDomains\""
        echo "</IfModule>"
    } >> "${conf}"
}

# oC10 only runs on PHP 7.4 and oC11 requires PHP 8.3. Pick the interpreter
# from the deployed tree so pre-upgrade steps work on the old code and
# post-upgrade steps on the new one.
occ_php() {
    # oC10's lib/base.php refuses PHP 8; oC11 requires PHP 8.3.
    if [ -f "${WEB_ROOT}/lib/base.php" ] && grep -q "not compatible with PHP 8.0" "${WEB_ROOT}/lib/base.php" 2>/dev/null; then
        echo /usr/local/bin/php74
    else
        echo /usr/local/bin/php83
    fi
}

exec_occ() {
    local php owner current cmd
    php=$(occ_php)
    # occ must run as the user that owns config/config.php
    owner=$(ls -ld "${WEB_ROOT}/config/config.php" 2>/dev/null | awk '{print $3}')
    if [ -z "$owner" ]; then
        owner=$(ls -ld "${WEB_ROOT}" 2>/dev/null | awk '{print $3}')
    fi
    current=$(id -un 2>/dev/null)
    if [ -n "$owner" ] && [ -n "$current" ] && [ "$owner" != "$current" ] && [ "$(id -u)" -eq 0 ]; then
        cmd="${php} ${WEB_ROOT}/occ $*"
        cmd=$(printf '%s' "$cmd" | sed 's/\\/\\\\/g')
        /bin/su "$owner" -s /bin/sh -c "$cmd"
    else
        "$php" "${WEB_ROOT}/occ" "$@"
    fi
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
                exec_occ config:system:set trusted_domains "$line_number" --value="$new_line"
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
                    exec_occ config:system:set trusted_domains "$line_number" --value="$val"
                    line_number=$((line_number + 1))
                fi
            fi
        done

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
    if [ "${SYNOPKG_PKG_STATUS}" = "INSTALL" ]; then
        # Check database
        if ! ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e quit > /dev/null 2>&1; then
            echo "Incorrect MariaDB 'root' password"
            exit 1
        fi
        if ${MYSQL} -u root -p"${wizard_mysql_password_root}" mysql -e "SELECT User FROM user" | grep ^"${MYSQL_USER}"$ > /dev/null 2>&1; then
            echo "MariaDB user '${MYSQL_USER}' already exists"
            exit 1
        fi
        if ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e "SHOW DATABASES" | grep ^"${MYSQL_DATABASE}"$ > /dev/null 2>&1; then
            echo "MariaDB database '${MYSQL_DATABASE}' already exists"
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
    if [ "${SYNOPKG_PKG_STATUS}" = "INSTALL" ]; then
        # Parse data directory
        DATA_DIR="${SHARE_PATH}/data"
        # Create data directory
        ${MKDIR} "${DATA_DIR}"

        # Check restore action
        if [ "${wizard_owncloud_restore}" = "true" ]; then
            echo "The backup file is valid, performing restore."
            # Extract archive to temp folder
            TEMPDIR="${SYNOPKG_PKGTMP}/${SYNOPKG_PKGNAME}"
            ${MKDIR} "${TEMPDIR}"
            tar -xzf "${wizard_backup_file}" -C "${TEMPDIR}" 2>&1

            # Restore configuration files and directories
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
            ${MYSQL} -u root -p"${wizard_mysql_password_root}" "${MYSQL_DATABASE}" < "${TEMPDIR}/database/${MYSQL_DATABASE}-dbbackup.sql" 2>&1

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
            echo "Run ownCloud installer"
            setup_owncloud_instance
        fi

        configure_htaccess

    fi
}

validate_preuninst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" = "UNINSTALL" ]; then
        # Check database
        if ! ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e quit >/dev/null 2>&1; then
            echo "Incorrect MariaDB 'root' password"
            exit 1
        fi
        # Check export directory
        if [ -n "${wizard_export_path}" ]; then
            if [ ! -d "${wizard_export_path}" ]; then
                echo "Error: Export directory ${wizard_export_path} does not exist"
                exit 1
            fi
            if [ ! -w "${wizard_export_path}" ]; then
                echo "Error: Unable to write to directory ${wizard_export_path}. Check permissions."
                exit 1
            fi
            # Ensure the configured data directory exists before attempting a backup
            DATADIR="$(config_get datadirectory)"
            if [ -z "${DATADIR}" ] || [ ! -d "${DATADIR}" ]; then
                echo "Expected data directory missing; aborting uninstall backup"
                exit 1
            fi
        fi
    fi
}

service_preuninst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" = "UNINSTALL" ] && [ -n "${wizard_export_path}" ]; then
        # Get data directory
        DATADIR="$(config_get datadirectory)"
        # Data directory fail-safe
        if [ ! -d "$DATADIR" ]; then
            echo "Invalid data directory '$DATADIR'. Using the default data directory instead."
            DATADIR="${WEB_ROOT}/data"
        fi

        # Prepare archive structure
        OCC_VER=$(sed -n "s/.*OC_VersionString = '\([^']*\)'.*/\1/p" "${WEB_ROOT}/version.php" 2>/dev/null | head -1)
        TEMPDIR="${SYNOPKG_PKGTMP}/${SYNOPKG_PKGNAME}_backup_v${OCC_VER}_$(date +"%Y%m%d")"
        ${MKDIR} "${TEMPDIR}"

        # Place server in maintenance mode
        exec_occ maintenance:mode --on

        # Backup the Database
        echo "Copying previous database from ${MYSQL_DATABASE}"
        ${MKDIR} "${TEMPDIR}/database"
        ${MYSQLDUMP} -u root -p"${wizard_mysql_password_root}" "${MYSQL_DATABASE}" > "${TEMPDIR}/database/${MYSQL_DATABASE}-dbbackup.sql" 2>&1

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
        echo "Creating compressed archive of ownCloud data in file $archive_name"
        tar -C "$TEMPDIR" -czf "${SYNOPKG_PKGTMP}/$archive_name" . 2>&1

        # Move archive to export directory
        RSYNC_BAK_ARGS="--backup --suffix=.bak"
        # shellcheck disable=SC2086  # RSYNC_BAK_ARGS is intentionally a multi-word arg list
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

validate_preupgrade ()
{
    # Mirrors ownCloud's version.php OC_VersionCanBeUpgradedFrom
    # [[8,2,11],[9,0,9],[9,1]] and Updater::isUpgradePossible(): the previous
    # version must be >= one of the allowed entries and <= the new one.
    is_upgrade_possible="no"
    previous=$(echo "${SYNOPKG_OLD_PKGVER}" | cut -d '-' -f 1)
    new=$(echo "${SYNOPKG_PKGVER}" | cut -d '-' -f 1)
    if version_greater_equal "${new}" "${previous}"; then
        if echo "${previous}" | grep -q '^8\.2\.' && version_greater_equal "${previous}" "8.2.11"; then
            is_upgrade_possible="yes"
        elif echo "${previous}" | grep -q '^9\.0\.' && version_greater_equal "${previous}" "9.0.9"; then
            is_upgrade_possible="yes"
        elif version_greater_equal "${previous}" "9.1"; then
            is_upgrade_possible="yes"
        fi
    fi

    # No matching upgrade paths found
    if [ "$is_upgrade_possible" = "no" ]; then
        echo "Please uninstall previous version, no update possible from v${SYNOPKG_OLD_PKGVER}.<br/>Remember to save your ${WEB_ROOT}/data files before uninstalling."
        exit 1
    fi

    # ownCloud upgrades only possible from MySQL instances
    DATABASE_TYPE="$(config_get dbtype)"
    if [ "$DATABASE_TYPE" != "mysql" ]; then
        echo "Please migrate your previous database from ${DATABASE_TYPE} to mariadb (mysql) before performing upgrade."
        exit 1
    fi

    # Ensure data directory is present before proceeding
    DATADIR="$(config_get datadirectory)"
    if [ -z "${DATADIR}" ] || [ ! -d "${DATADIR}" ]; then
        echo "Expected data directory missing; aborting upgrade"
        exit 1
    fi

    # ------------------------------------------------------------------
    # Vendor upgrade procedure (11.0 manual upgrade). These steps run here
    # because validate_preupgrade is called without the install_log pipe, so
    # exit aborts the package upgrade before any files are replaced.
    # ------------------------------------------------------------------
    BACKUP_DIR="${SYNOPKG_PKGVAR}/backup"
    ${MKDIR} "${BACKUP_DIR}"
    OC_VER=$(sed -n "s/.*OC_VersionString = '\([^']*\)'.*/\1/p" "${WEB_ROOT}/version.php" 2>/dev/null | head -1)
    OC_VER="${OC_VER:-unknown}"
    STAMP=$(date +%Y%m%d%H%M%S)

    # Step 1: maintenance mode. (The package has no DSM cron job to disable;
    # background jobs run via occ system:cron.)
    if ! exec_occ maintenance:mode --on >&2; then
        echo "ERROR: could not enable maintenance mode; aborting upgrade"
        exit 1
    fi

    # Step 2: disable third-party apps (not shipped by ownCloud).
    DISABLED_APPS="${BACKUP_DIR}/disabled-apps-${OC_VER}-${STAMP}.txt"
    : > "${DISABLED_APPS}"
    for dir in "${WEB_ROOT}/apps"/* "${WEB_ROOT}/apps-external"/*; do
        [ -d "$dir" ] || continue
        app=$(basename "$dir")
        if [ ! -d "${SYNOPKG_PKGDEST}/share/owncloud/apps/${app}" ]; then
            if exec_occ app:disable "$app" >/dev/null 2>&1; then
                echo "$app" >> "${DISABLED_APPS}"
            fi
        fi
    done

    if [ ! -s "${DISABLED_APPS}" ]; then
        echo "(none)" > "${DISABLED_APPS}"
    fi

    # Step 3: backup the database with the application credentials.
    DB_NAME=$(config_get dbname)
    DB_USER=$(config_get dbuser)
    DB_PASS=$(config_get dbpassword)
    if [ -z "$DB_NAME" ] || [ -z "$DB_USER" ]; then
        exec_occ maintenance:mode --off >/dev/null 2>&1 || true
        echo "ERROR: cannot read database settings from config.php; aborting upgrade"
        exit 1
    fi
    DB_DUMP="${BACKUP_DIR}/owncloud-${OC_VER}-${STAMP}.sql.gz"
    if ! MYSQL_PWD="$DB_PASS" ${MYSQLDUMP} --single-transaction --quick -u "$DB_USER" "$DB_NAME" | gzip > "$DB_DUMP"; then
        exec_occ maintenance:mode --off >/dev/null 2>&1 || true
        echo "ERROR: database backup failed; aborting upgrade"
        exit 1
    fi
    if ! gzip -t "$DB_DUMP"; then
        exec_occ maintenance:mode --off >/dev/null 2>&1 || true
        echo "ERROR: database backup is corrupt; aborting upgrade"
        exit 1
    fi
    echo "Database backup: ${DB_DUMP}" >&2

    # Step 4: keep .htaccess/.user.ini for manual re-application. The vendor
    # recreates these files on upgrade, so they are not restored.
    [ -f "${WEB_ROOT}/.htaccess" ] && cp -p "${WEB_ROOT}/.htaccess" "${BACKUP_DIR}/htaccess-${OC_VER}-${STAMP}"
    [ -f "${WEB_ROOT}/.user.ini" ] && cp -p "${WEB_ROOT}/.user.ini" "${BACKUP_DIR}/user.ini-${OC_VER}-${STAMP}"

    # Data directory marker and rollback backup of the distribution.
    DATADIR_REAL=$(realpath "$DATADIR")
    WEBROOT_REAL=$(realpath "${WEB_ROOT}")
    if echo "$DATADIR_REAL" | grep -q "^$WEBROOT_REAL"; then
        echo "${DATADIR_REAL#"$WEBROOT_REAL/"}" > "${SYNOPKG_TEMP_UPGRADE_FOLDER}/.datadirectory"
    fi
    [ -d "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}" ] && ${RM} "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}"
    echo "Backup existing distribution to ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}" >&2
    ${MKDIR} "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}"
    if ! rsync -aX "${WEB_ROOT}/" "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}" >&2 2>&1; then
        exec_occ maintenance:mode --off >/dev/null 2>&1 || true
        echo "ERROR: distribution backup failed; aborting upgrade"
        exit 1
    fi
}

service_restore ()
{
    # Validate data directory for restore
    if [ -f "${SYNOPKG_TEMP_UPGRADE_FOLDER}/.datadirectory" ]; then
        DATAPATH=$(cat "${SYNOPKG_TEMP_UPGRADE_FOLDER}/.datadirectory")
        # Data directory inside owncloud directory and needs to be restored
        echo "Restore previous data directory from ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/${DATAPATH}"
        rsync -aX -I "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/${DATAPATH}" "${WEB_ROOT}/" 2>&1
        ${RM} "${SYNOPKG_TEMP_UPGRADE_FOLDER}/.datadirectory"
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

    # Run the upgrade while maintenance mode is on (vendor procedure). occ
    # turns maintenance mode on itself and off again at the end.
    if ! exec_occ upgrade; then
        echo "ERROR: occ upgrade failed; maintenance mode stays on and the rollback backup is kept at ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}"
        echo "ERROR: database backup and disabled-apps list are in ${SYNOPKG_PKGVAR}/backup"
        # service functions run in a subshell (piped through install_log), so
        # exit only leaves the subshell; terminate the installer to fail the upgrade.
        kill -TERM "$PPID" 2>/dev/null
        exit 1
    fi

    # Disable maintenance mode after a successful upgrade.
    if ! exec_occ maintenance:mode --off; then
        echo "WARNING: could not disable maintenance mode; run 'occ maintenance:mode --off' manually"
    fi

    # Re-apply the HTTPS redirect and HSTS rules to the new .htaccess.
    configure_htaccess

    # Check the upgrade: version and app list.
    exec_occ status
    exec_occ app:list

    DATADIR=$(exec_occ config:system:get datadirectory)
    # Data directory fail-safe
    if [ ! -d "$DATADIR" ]; then
        echo "Invalid data directory '$DATADIR'. Using the default data directory instead."
        DATADIR="${WEB_ROOT}/data"
    fi

    echo "Third-party apps disabled before the upgrade are listed in ${SYNOPKG_PKGVAR}/backup/disabled-apps-*.txt; re-enable compatible ones with 'occ app:enable <app>'."

    # Remove upgrade backup files
    ${RM} "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}"

    # Keep the two newest backup sets per type (the stamp is the last 14 digits).
    for pattern in "owncloud-*.sql.gz" "htaccess-*" "user.ini-*" "disabled-apps-*"; do
        ls -1 "${SYNOPKG_PKGVAR}/backup"/${pattern} 2>/dev/null \
            | sed 's/.*-\([0-9]\{14\}\)[^0-9]*$/\1 &/' \
            | sort -rn \
            | cut -d' ' -f2- \
            | tail -n +3 \
            | while IFS= read -r old; do
                [ -n "${old}" ] && ${RM} "${old}"
            done
    done
}
