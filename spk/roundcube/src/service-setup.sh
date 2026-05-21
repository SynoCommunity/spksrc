
# Package
SC_DNAME="Roundcube Webmail"
SC_PKG_PREFIX="com-synocommunity-packages-"
SC_PKG_NAME="${SC_PKG_PREFIX}${SYNOPKG_PKGNAME}"

# Others
MYSQL="/usr/local/mariadb10/bin/mysql"
MYSQLDUMP="/usr/local/mariadb10/bin/mysqldump"
PHP_BIN="/usr/local/bin/php84"
MYSQL_USER="${SYNOPKG_PKGNAME}"
MYSQL_DATABASE="${SYNOPKG_PKGNAME}"
WEB_DIR="/var/services/web_packages"
WEB_ROOT="${WEB_DIR}/${SYNOPKG_PKGNAME}"
CFG_FILE="${WEB_ROOT}/config/config.inc.php"

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
        if [ "${wizard_roundcube_restore}" = "true" ] && [ -n "${wizard_backup_file}" ]; then
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
        if [ "${wizard_roundcube_restore}" = "true" ]; then
            echo "The backup file is valid, performing restore"
            # Extract archive to temp folder
            TEMPDIR="${SYNOPKG_PKGTMP}/${SYNOPKG_PKGNAME}"
            ${MKDIR} "${TEMPDIR}"
            tar -xzf "${wizard_backup_file}" -C "${TEMPDIR}" 2>&1

            # Restore configuration file
            echo "Restoring configuration to ${WEB_ROOT}/config"
            rsync -aX -I "${TEMPDIR}/config/config.inc.php" "${CFG_FILE}" 2>&1

            # Restore user installed plugins
            if [ -n "$(find "${TEMPDIR}/plugins" -maxdepth 0 -type d -not -empty 2>/dev/null)" ]; then
                echo "Restoring user installed plugins to ${WEB_ROOT}/plugins"
                for plugin in "${TEMPDIR}/plugins"/*/
                do
                    dir=$(basename "$plugin")
                    if [ ! -d "${WEB_ROOT}/plugins/${dir}" ]; then
                        rsync -aX -I "${TEMPDIR}/plugins/${dir}" "${WEB_ROOT}/plugins/" 2>&1
                    fi
                done
            fi

            # Restore user installed skins
            if [ -n "$(find "${TEMPDIR}/skins" -maxdepth 0 -type d -not -empty 2>/dev/null)" ]; then
                echo "Restoring user installed skins to ${WEB_ROOT}/skins"
                for skin in "${TEMPDIR}/skins"/*/
                do
                    dir=$(basename "$skin")
                    if [ ! -d "${WEB_ROOT}/skins/${dir}" ]; then
                        rsync -aX -I "${TEMPDIR}/skins/${dir}" "${WEB_ROOT}/skins/" 2>&1
                    fi
                done
            fi

            # Update database password
            MARIADB_PASSWORD_ESCAPED=$(printf '%s' "${wizard_mysql_password_roundcube}" | sed 's/[&/\]/\\&/g')
            sed -i "s|\(\$config\['db_dsnw'\] = 'mysqli://roundcube:\)[^@]*\(@unix(/run/mysqld/mysqld10.sock)/roundcube';\)|\1${MARIADB_PASSWORD_ESCAPED}\2|" "${CFG_FILE}"

            # Restore the Database
            echo "Restoring database to ${MYSQL_DATABASE}"
            ${MYSQL} -u root -p"${wizard_mysql_password_root}" "${MYSQL_DATABASE}" < "${TEMPDIR}/database/${MYSQL_DATABASE}-dbbackup.sql" 2>&1

            # Clean-up temporary files
            ${RM} "${TEMPDIR}"
        else
            # Setup initial database structure
            ${MYSQL} -u "${MYSQL_USER}" -p"${wizard_mysql_password_roundcube}" "${MYSQL_DATABASE}" < "${WEB_ROOT}/SQL/mysql.initial.sql"

            # Setup configuration file
            sed -e "s|^\(\$config\['db_dsnw'\] =\).*$|\1 \'mysqli://roundcube:${wizard_mysql_password_roundcube}@unix(/run/mysqld/mysqld10.sock)/roundcube\';|" \
                -e "s|^\(\$config\['imap_host'\] =\).*$|\1 \'${wizard_roundcube_imap_host}\';|" \
                -e "s|^\(\$config\['smtp_host'\] =\).*$|\1 \'${wizard_roundcube_smtp_host}\';|" \
                -e "s|^\(\$config\['smtp_user'\] =\).*$|\1 \'${wizard_roundcube_smtp_user}\';|" \
                -e "s|^\(\$config\['smtp_pass'\] =\).*$|\1 \'${wizard_roundcube_smtp_pass}\';|" \
                "${WEB_ROOT}/config/config.inc.php.sample" > "${CFG_FILE}"
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
        if [ -f "/var/packages/${SYNOPKG_PKGNAME}/INFO" ]; then
            SC_PKG_VER=$(awk -F'"' '/version=/ {split($2, v, "-"); print v[1]}' "/var/packages/${SYNOPKG_PKGNAME}/INFO")
        fi
        TEMPDIR="${SYNOPKG_PKGTMP}/${SYNOPKG_PKGNAME}_backup_v${SC_PKG_VER}_$(date +"%Y%m%d")"
        ${MKDIR} "${TEMPDIR}"

        # Backup the configuration file
        echo "Copying previous configuration from ${WEB_ROOT}/config"
        ${MKDIR} "${TEMPDIR}/config"
        rsync -aX "${CFG_FILE}" "${TEMPDIR}/config/" 2>&1

        # Save user installed plugins
        echo "Copying user installed plugins from ${WEB_ROOT}/plugins"
        ${MKDIR} "${TEMPDIR}/plugins"
        for plugin in "${WEB_ROOT}/plugins"/*/
        do
            dir=$(basename "$plugin")
            if [ ! -d "${SYNOPKG_PKGDEST}/share/${SYNOPKG_PKGNAME}/plugins/${dir}" ]; then
                rsync -aX "${WEB_ROOT}/plugins/${dir}" "${TEMPDIR}/plugins/" 2>&1
            fi
        done

        # Save user installed skins
        echo "Copying user installed skins from ${WEB_ROOT}/skins"
        ${MKDIR} "${TEMPDIR}/skins"
        for skin in "${WEB_ROOT}/skins"/*/
        do
            dir=$(basename "$skin")
            if [ ! -d "${SYNOPKG_PKGDEST}/share/${SYNOPKG_PKGNAME}/skins/${dir}" ]; then
                rsync -aX "${WEB_ROOT}/skins/${dir}" "${TEMPDIR}/skins/" 2>&1
            fi
        done

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
    # Prepare temp folder
    [ -d "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}" ] && ${RM} "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}"
    ${MKDIR} "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}"
    
    # Save pre 1.0.0 configuration files
    if [ -f "${WEB_ROOT}/config/db.inc.php" ]; then
        rsync -aX "${WEB_ROOT}/config/db.inc.php" "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/" 2>&1
    fi
    if [ -f "${WEB_ROOT}/config/main.inc.php" ]; then
        rsync -aX "${WEB_ROOT}/config/main.inc.php" "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/" 2>&1
    fi

    # Save configuration files for version >= 1.0.0
    rsync -aX "${CFG_FILE}" "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/" 2>&1

    # Save user installed plugins
    ${MKDIR} "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/plugins"
    for plugin in "${WEB_ROOT}/plugins"/*/
    do
        dir=$(basename "$plugin")
        if [ ! -d "${SYNOPKG_PKGDEST}/share/${SYNOPKG_PKGNAME}/plugins/${dir}" ]; then
            rsync -aX "${WEB_ROOT}/plugins/${dir}" "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/plugins/" 2>&1
        fi
    done

    # Save user installed skins
    ${MKDIR} "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/skins"
    for skin in "${WEB_ROOT}/skins"/*/
    do
        dir=$(basename "$skin")
        if [ ! -d "${SYNOPKG_PKGDEST}/share/${SYNOPKG_PKGNAME}/skins/${dir}" ]; then
            rsync -aX "${WEB_ROOT}/skins/${dir}" "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/skins/" 2>&1
        fi
    done
}

service_restore ()
{
    # Restore pre 1.0.0 configuration files, still 1.0.0 compatible
    if [ -f "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/db.inc.php" ]; then
        rsync -aX -I "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/db.inc.php" "${WEB_ROOT}/config/db.inc.php" 2>&1
    fi
    if [ -f "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/main.inc.php" ]; then
        rsync -aX -I "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/main.inc.php" "${WEB_ROOT}/config/main.inc.php" 2>&1
    fi

    # Restore configuration files for version >= 1.0.0
    rsync -aX -I "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/config.inc.php" "${CFG_FILE}" 2>&1

    # Restore user installed plugins
    if [ -n "$(find "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/plugins" -maxdepth 0 -type d -not -empty 2>/dev/null)" ]; then
        for plugin in "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/plugins"/*/
        do
            dir=$(basename "$plugin")
            if [ ! -d "${WEB_ROOT}/plugins/${dir}" ]; then
                rsync -aX -I "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/plugins/${dir}" "${WEB_ROOT}/plugins/" 2>&1
            fi
        done
    fi

    # Restore user installed skins
    if [ -n "$(find "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/skins" -maxdepth 0 -type d -not -empty 2>/dev/null)" ]; then
        for skin in "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/skins"/*/
        do
            dir=$(basename "$skin")
            if [ ! -d "${WEB_ROOT}/skins/${dir}" ]; then
                rsync -aX -I "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/skins/${dir}" "${WEB_ROOT}/skins/" 2>&1
            fi
        done
    fi

    # Run database schema migration using Roundcube's own db_update()
    if [ -f "${CFG_FILE}" ]; then
        echo "Running database schema update for ${SYNOPKG_PKGNAME}..."
        DB_UPDATE="${SYNOPKG_PKGDEST}/bin/db_update.php"
        if [ -f "${DB_UPDATE}" ] && [ -x "${PHP_BIN}" ]; then
            ROUNDCUBE_CONFIG_DIR="${WEB_ROOT}/config" \
                ${PHP_BIN} "${DB_UPDATE}" \
                    --install-path="${SYNOPKG_PKGDEST}/share/roundcube/" \
                    --dir="${WEB_ROOT}/SQL" \
                    --package=roundcube 2>&1
        fi
    fi

    ${RM} "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}"
}
