
# Package
SC_DNAME="Feng Office"
SVC_KEEP_LOG=y
SVC_BACKGROUND=y
SVC_WRITE_PID=y

# Others
MYSQL="/usr/local/mariadb10/bin/mysql"
MYSQLDUMP="/usr/local/mariadb10/bin/mysqldump"
MYSQL_USER="${SYNOPKG_PKGNAME}"
MYSQL_DATABASE="${SYNOPKG_PKGNAME}"
WEB_DIR="/var/services/web_packages"
WEB_ROOT="${WEB_DIR}/${SYNOPKG_PKGNAME}"

exec_php ()
{
    PHP="/usr/local/bin/php83"
    if [ ! -x "$PHP" ]; then
        echo "Error: PHP binary not found or not executable: $PHP" >&2
        echo "Ensure the WebStation PHP 8.3 package is installed and enabled." >&2
        return 1
    fi
    COMMAND="${PHP} $*"
    $COMMAND >> "${LOG_FILE}" 2>&1
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
    if [ "${SYNOPKG_PKG_STATUS}" = "INSTALL" ]; then
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
        if [ "${wizard_fengoffice_restore}" = "true" ] && [ -n "${wizard_backup_file}" ]; then
            if [ ! -r "${wizard_backup_file}" ]; then
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
    if [ "${SYNOPKG_PKG_STATUS}" = "INSTALL" ]; then
        # Check restore action
        if [ "${wizard_fengoffice_restore}" = "true" ]; then
            echo "The backup file is valid, performing restore"
            # Extract archive to temp folder
            TEMPDIR="${SYNOPKG_PKGTMP}/${SYNOPKG_PKGNAME}"
            ${MKDIR} "${TEMPDIR}"
            tar -xzf "${wizard_backup_file}" -C "${TEMPDIR}" 2>&1
            # Restore configuration and data
            echo "Restoring configuration and data to ${WEB_DIR}"
            rsync -aX --update -I "${TEMPDIR}/${SYNOPKG_PKGNAME}" "${WEB_DIR}/" 2>&1

            # Update database password
            sed -i "s/^\(\s*define('DB_PASS',\s*'\).*\(');\s*\)$/\1${wizard_mysql_password_fengoffice}\2/" "${WEB_ROOT}/config/config.php"

            # Restore the Database
            echo "Restoring database to ${MYSQL_DATABASE}"
            ${MYSQL} -u root -p"${wizard_mysql_password_root}" "${MYSQL_DATABASE}" < "${TEMPDIR}/database/${MYSQL_DATABASE}-dbbackup.sql" 2>&1

            # Run update scripts
            exec_php "${WEB_ROOT}/public/upgrade/console.php"
            exec_php "${WEB_ROOT}/public/install/plugin-console.php" "update_all"

            # Clean-up temporary files
            ${RM} "${TEMPDIR}"
        else
            # Setup parameters for installation script
            QUERY_STRING="\
script_installer_storage[database_type]=mysqli\
&script_installer_storage[database_host]=localhost\
&script_installer_storage[database_user]=${MYSQL_USER}\
&script_installer_storage[database_pass]=${wizard_mysql_password_fengoffice:=${SYNOPKG_PKGNAME}}\
&script_installer_storage[database_name]=${MYSQL_DATABASE}\
&script_installer_storage[database_prefix]=fo_\
&script_installer_storage[database_engine]=InnoDB\
&script_installer_storage[absolute_url]=http://${wizard_domain_name:=$(hostname)}/${SYNOPKG_PKGNAME}\
&script_installer_storage[plugins][]=core_dimensions\
&script_installer_storage[plugins][]=mail\
&script_installer_storage[plugins][]=workspaces\
&submited=submited"
            # Prepare environment
            cd "${WEB_ROOT}/public/install/" || return
            # Run installer
            echo "Run ${SC_DNAME} installer"
            exec_php "install_helper.php"
        fi
    fi
}

validate_preuninst ()
{
    # Check database
    if [ "${SYNOPKG_PKG_STATUS}" = "UNINSTALL" ] && ! ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e quit > /dev/null 2>&1; then
        echo "Incorrect MariaDB 'root' password"
        exit 1
    fi
    # Check export directory
    if [ "${SYNOPKG_PKG_STATUS}" = "UNINSTALL" ] && [ -n "${wizard_export_path}" ]; then
        if [ ! -d "${wizard_export_path}" ]; then
            echo "Error: Export directory ${wizard_export_path} does not exist"
            exit 1
        fi
        if [ ! -w "${wizard_export_path}" ]; then
            echo "Error: Unable to write to directory ${wizard_export_path}. Check permissions."
            exit 1
        fi
    fi
}

service_preuninst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" = "UNINSTALL" ] && [ -n "${wizard_export_path}" ]; then
        # Prepare archive structure
        if [ -f "${WEB_ROOT}/config/installed_version.php" ]; then
            FENG_VER=$(sed -n "s|return '\(.*\)';|\1|p" "${WEB_ROOT}/config/installed_version.php" | xargs)
        else
            FENG_VER=$(sed -n "s|return '\(.*\)';|\1|p" "${WEB_ROOT}/version.php" | xargs)
        fi
        TEMPDIR="${SYNOPKG_PKGTMP}/${SYNOPKG_PKGNAME}_backup_v${FENG_VER}_$(date +"%Y%m%d")"
        ${MKDIR} "${TEMPDIR}"

        # Backup Directories
        echo "Copying previous configuration and data from ${WEB_ROOT}"
        rsync -aX "${WEB_ROOT}" "${TEMPDIR}/" 2>&1

        # Backup the Database
        echo "Copying previous database from ${MYSQL_DATABASE}"
        ${MKDIR} "${TEMPDIR}/database"
        ${MYSQLDUMP} -u root -p"${wizard_mysql_password_root}" "${MYSQL_DATABASE}" > "${TEMPDIR}/database/${MYSQL_DATABASE}-dbbackup.sql" 2>&1

        # Create backup archive
        archive_name="$(basename "$TEMPDIR").tar.gz"
        echo "Creating compressed archive of ${SC_DNAME} data in file $archive_name"
        tar -C "$TEMPDIR" -czf "${SYNOPKG_PKGTMP}/$archive_name" . 2>&1

        # Move archive to export directory
        RSYNC_BAK_ARGS="--backup --suffix=.bak"
        # shellcheck disable=SC2086  # RSYNC_BAK_ARGS is intentionally a multi-word arg list
        rsync -aX ${RSYNC_BAK_ARGS} "${SYNOPKG_PKGTMP}/$archive_name" "${wizard_export_path}/" 2>&1
        echo "Backup file copied successfully to ${wizard_export_path}"

        # Clean-up temporary files
        ${RM} "${TEMPDIR}"
        ${RM} "${SYNOPKG_PKGTMP}/$archive_name"
    fi
}

service_save ()
{
    # Save configuration and files
    [ -d "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}" ] && ${RM} "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}"
    mkdir -p "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}"
    mv "${WEB_ROOT}/config/config.php" "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/"
    if [ -f "${WEB_ROOT}/config/installed_version.php" ]; then
        mv "${WEB_ROOT}/config/installed_version.php" "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/"
    fi
    mkdir -p "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/upload/"
    if [ -d "${WEB_ROOT}/upload" ]; then
        cp -a "${WEB_ROOT}/upload/." "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/upload/"
    fi
}

service_restore ()
{
    # Restore configuration
    mv "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/config.php" "${WEB_ROOT}/config/"
    if [ -f "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/installed_version.php" ]; then
        mv "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/installed_version.php" "${WEB_ROOT}/config/"
    fi
    mkdir -p "${WEB_ROOT}/upload"
    if [ -d "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/upload" ]; then
        cp -a "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/upload/." "${WEB_ROOT}/upload/"
    fi
    ${RM} "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}"

    # Run update scripts
    exec_php "${WEB_ROOT}/public/upgrade/console.php"
    exec_php "${WEB_ROOT}/public/install/plugin-console.php" "update_all"
}
