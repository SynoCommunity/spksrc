# Nextcloud service setup for DSM 7 with PHP 8.3
SVC_BACKGROUND=y
SVC_WRITE_PID=y

WEB_DIR="/var/services/web_packages"
WEB_ROOT="${WEB_DIR}/${SYNOPKG_PKGNAME}"
NEXTCLOUD_VERSION="${SYNOPKG_PKGVER%%-*}"
NEXTCLOUD_ARCHIVE="nextcloud-${NEXTCLOUD_VERSION}.tar.bz2"
NEXTCLOUD_URL="https://download.nextcloud.com/server/releases/${NEXTCLOUD_ARCHIVE}"
NEXTCLOUD_SHA256="8dd0bc8f8e2d262edad11197d4a07af799b51fe872ee2d9259ffa19b43e543ad"

if [ -z "${SYNOPKG_PKGTMP}" ]; then
    SYNOPKG_PKGTMP="${SYNOPKG_PKGDEST_VOL}/@tmp"
fi

# PHP CLI used for all maintenance tasks
PHP_BIN="/usr/local/bin/php83"
MYSQL="/usr/local/mariadb10/bin/mysql"
MYSQLDUMP="/usr/local/mariadb10/bin/mysqldump"
MYSQL_DATABASE="${SYNOPKG_PKGNAME}"
MYSQL_USER="nc_${wizard_nextcloud_admin_username}"

stage_nextcloud_sources() {
    TMP_ARCHIVE_DIR="${SYNOPKG_PKGTMP}/${SYNOPKG_PKGNAME}-archive"
    ${MKDIR} "${TMP_ARCHIVE_DIR}"
    ARCHIVE_PATH="${TMP_ARCHIVE_DIR}/${NEXTCLOUD_ARCHIVE}"

    if [ ! -f "${ARCHIVE_PATH}" ]; then
        echo "[nextcloud] Fetching ${NEXTCLOUD_URL}"
        if ! curl -fL --connect-timeout 30 --retry 2 --retry-delay 5 -o "${ARCHIVE_PATH}.tmp" "${NEXTCLOUD_URL}"; then
            ${RM} "${ARCHIVE_PATH}.tmp"
            echo "[nextcloud] ERROR: Download failed" >&2
            return 1
        fi
        if [ -n "${NEXTCLOUD_SHA256}" ]; then
            if ! echo "${NEXTCLOUD_SHA256}  ${ARCHIVE_PATH}.tmp" | sha256sum -c - >/dev/null 2>&1; then
                ${RM} "${ARCHIVE_PATH}.tmp"
                echo "[nextcloud] ERROR: Checksum verification failed" >&2
                return 1
            fi
        fi
        mv "${ARCHIVE_PATH}.tmp" "${ARCHIVE_PATH}"
        chmod 600 "${ARCHIVE_PATH}"
    fi

    if ! ${MKDIR} "${WEB_ROOT}"; then
        echo "[nextcloud] ERROR: Failed to prepare web root" >&2
        return 1
    fi

    for path in "${WEB_ROOT}"/* "${WEB_ROOT}"/.[!.]* "${WEB_ROOT}"/..?*; do
        if [ -e "${path}" ]; then
            if ! ${RM} "${path}"; then
                echo "[nextcloud] ERROR: Failed to clean ${path}" >&2
                return 1
            fi
        fi
    done

    if ! tar -xjf "${ARCHIVE_PATH}" -C "${WEB_ROOT}" --strip-components 1; then
        echo "[nextcloud] ERROR: Failed to extract archive" >&2
        return 1
    fi

    if ! chown -R "${EFF_USER}:http" "${WEB_ROOT}" 2>/dev/null; then
        echo "[nextcloud] WARNING: Failed to adjust ownership" >&2
    fi
}

exec_occ() {
    # Call Nextcloud's occ tool with consistent PHP options
    "${PHP_BIN}" -d memory_limit=512M "${WEB_ROOT}/occ" --no-warnings "$@"
}

configure_trusted_domains() {
    # Remove NAS UI ports and append wizard-supplied domains if missing
    if ! DOMAINS=$(exec_occ config:system:get trusted_domains 2>/dev/null); then
        DOMAINS=""
    fi
    line_number=0
    echo "${DOMAINS}" | while read -r line; do
        if echo "$line" | grep -qE ':5000|:5001'; then
            cleaned=$(echo "$line" | sed -E 's/(:5000|:5001)//')
            exec_occ config:system:set trusted_domains "$line_number" --value="$cleaned"
        fi
        line_number=$((line_number + 1))
    done

    if ! DOMAINS=$(exec_occ config:system:get trusted_domains 2>/dev/null); then
        DOMAINS=""
    fi
    line_number=$(echo "${DOMAINS}" | sed -n '$=')
    for var in wizard_nextcloud_trusted_domain_1 wizard_nextcloud_trusted_domain_2 wizard_nextcloud_trusted_domain_3; do
        eval val=\$$var
        if [ -n "$val" ] && ! echo "${DOMAINS}" | grep -qx "$val"; then
            exec_occ config:system:set trusted_domains "$line_number" --value="$val"
            line_number=$((line_number + 1))
        fi
    done
}

configure_security_headers() {
    # Ensure HTTPS redirect and HSTS are present in the shipped .htaccess
    APACHE_CONF="${WEB_ROOT}/.htaccess"
    if [ -f "${APACHE_CONF}" ]; then
        if ! grep -q "RewriteCond %{HTTPS} off" "${APACHE_CONF}"; then
            {
                echo "RewriteEngine On"
                echo "RewriteCond %{HTTPS} off"
                echo "RewriteRule ^(.*)$ https://%{HTTP_HOST}%{REQUEST_URI} [L,R=301]"
            } >> "${APACHE_CONF}"
        fi
        if ! grep -q "Strict-Transport-Security" "${APACHE_CONF}"; then
            {
                echo "<IfModule mod_headers.c>"
                echo "Header always set Strict-Transport-Security \"max-age=15552000; includeSubDomains\""
                echo "</IfModule>"
            } >> "${APACHE_CONF}"
        fi
    fi
}

setup_instance() {
    # Fresh install path: create DB, user and bootstrap Nextcloud
    ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e "CREATE DATABASE ${MYSQL_DATABASE}; GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'localhost' IDENTIFIED BY '${wizard_mysql_password_nextcloud}';"
    exec_occ maintenance:install \
        --database "mysql" \
        --database-name "${MYSQL_DATABASE}" \
        --database-host "localhost:/run/mysqld/mysqld10.sock" \
        --database-user "${MYSQL_USER}" \
        --database-pass "${wizard_mysql_password_nextcloud}" \
        --admin-user "${wizard_nextcloud_admin_username}" \
        --admin-pass "${wizard_nextcloud_admin_password}" \
        --data-dir "${DATA_DIR}" 2>&1
}

configure_after_install() {
    # Common post-install/upgrade tasks and heavy maintenance routines
    configure_security_headers
    if [ "${SYNOPKG_PKG_STATUS}" = "INSTALL" ]; then
        configure_trusted_domains
        exec_occ config:system:set memcache.local --value="\\OC\\Memcache\\APCu"
        exec_occ config:system:set memcache.locking --value="\\OC\\Memcache\\Redis"
        exec_occ config:system:set filelocking.enabled --value="true"
    fi
    exec_occ maintenance:mode --on
    exec_occ maintenance:repair --include-expensive
    exec_occ db:add-missing-indices
    exec_occ maintenance:mode --off
}

service_prestart() {
    # Emulate cron by looping Nextcloud's cron.php inside the package service
    cron_script="${WEB_ROOT}/cron.php"
    sleep_interval=300

    if [ ! -f "${cron_script}" ]; then
        return
    fi

    (
        while true; do
            "${PHP_BIN}" -d memory_limit=512M -f "${cron_script}" >/dev/null 2>&1
            sleep "${sleep_interval}"
        done
    ) &

    if [ -n "${PID_FILE}" ]; then
        echo "$!" > "${PID_FILE}"
    fi
}

validate_preinst() {
    # Guard fresh installs and optional restores before files are deployed
    if [ "${SYNOPKG_PKG_STATUS}" = "INSTALL" ]; then
        if ! ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e quit >/dev/null 2>&1; then
            echo "Incorrect MariaDB 'root' password"
            exit 1
        fi
        if ${MYSQL} -u root -p"${wizard_mysql_password_root}" mysql -e "SELECT User FROM user" | grep ^"${MYSQL_USER}"$ >/dev/null 2>&1; then
            echo "MariaDB user '${MYSQL_USER}' already exists"
            exit 1
        fi
        if ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e "SHOW DATABASES" | grep ^"${MYSQL_DATABASE}"$ >/dev/null 2>&1; then
            echo "MariaDB database '${MYSQL_DATABASE}' already exists"
            exit 1
        fi
        if [ -n "${wizard_data_share}" ]; then
            share_path=""
            for vol in /volume* /volumeUSB*; do
                if [ -d "${vol}/${wizard_data_share}" ]; then
                    share_path="${vol}/${wizard_data_share}"
                    break
                fi
            done
            if [ -n "${share_path}" ] && [ -f "${share_path}/data/.ncdata" ]; then
                echo "Cannot install because ${share_path}/data already contains existing Nextcloud data (.ncdata). Please rename or remove the folder and try again."
                exit 1
            fi
        fi
        if [ "${wizard_nextcloud_restore}" = "true" ] && [ -n "${wizard_backup_file}" ]; then
            if [ ! -r "${wizard_backup_file}" ]; then
                echo "Backup file '${wizard_backup_file}' is not readable"
                exit 1
            fi
        fi
    fi
}

service_postinst() {
    if [ "${SYNOPKG_PKG_STATUS}" = "INSTALL" ]; then
        # Populate WEB_ROOT before we invoke occ or import backups
        if ! stage_nextcloud_sources; then
            return 1
        fi
        DATA_DIR="${SHARE_PATH}/data"
        ${MKDIR} "${DATA_DIR}"
        if [ "${wizard_nextcloud_restore}" = "true" ] && [ -n "${wizard_backup_file}" ]; then
            TEMPDIR="${SYNOPKG_PKGTMP}/${SYNOPKG_PKGNAME}"
            ${MKDIR} "${TEMPDIR}"
            tar -xzf "${wizard_backup_file}" -C "${TEMPDIR}" 2>&1
            rsync -aX -I "${TEMPDIR}/config/" "${WEB_ROOT}/config/" 2>&1
            if [ -d "${TEMPDIR}/themes" ]; then
                rsync -aX -I "${TEMPDIR}/themes/" "${WEB_ROOT}/themes/" 2>&1
            fi
            rsync -aX -I "${TEMPDIR}/data" "${SHARE_PATH}/" 2>&1
            db_user=$(grep "'dbuser'" "${WEB_ROOT}/config/config.php" | sed -n "s/.*'dbuser' => '\(.*\)'.*/\1/p")
            db_password=$(grep "'dbpassword'" "${WEB_ROOT}/config/config.php" | sed -n "s/.*'dbpassword' => '\(.*\)'.*/\1/p")
            ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e "CREATE DATABASE ${MYSQL_DATABASE}; GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${db_user}'@'localhost' IDENTIFIED BY '${db_password}';" 2>&1
            ${MYSQL} -u root -p"${wizard_mysql_password_root}" "${MYSQL_DATABASE}" < "${TEMPDIR}/database/${MYSQL_DATABASE}-dbbackup.sql" 2>&1
            exec_occ maintenance:data-fingerprint -n
            exec_occ maintenance:mode --off
        else
            setup_instance
        fi
        configure_after_install
    fi
}

validate_preuninst() {
    # Ensure we can connect to MariaDB and optional export path is writable
    if [ "${SYNOPKG_PKG_STATUS}" = "UNINSTALL" ]; then
        if ! ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e quit >/dev/null 2>&1; then
            echo "Incorrect MariaDB 'root' password"
            exit 1
        fi
        if [ -n "${wizard_export_path}" ]; then
            DATADIR="$(exec_occ config:system:get datadirectory 2>/dev/null)"
            if [ -z "${DATADIR}" ] || [ ! -d "${DATADIR}" ]; then
                echo "Expected data directory missing; aborting uninstall backup"
                exit 1
            fi
            if [ ! -d "${wizard_export_path}" ] || [ ! -w "${wizard_export_path}" ]; then
                echo "Backup export path '${wizard_export_path}' is not writable"
                exit 1
            fi
        fi
    fi
}

service_preuninst() {
    # Optional backup and DB cleanup before files are removed
    if [ "${SYNOPKG_PKG_STATUS}" = "UNINSTALL" ]; then
        if [ -n "${wizard_export_path}" ]; then
            DATADIR="$(exec_occ config:system:get datadirectory 2>/dev/null)"
            OCC_VER=$(exec_occ -V | cut -d ' ' -f 2)
            TEMPDIR="${SYNOPKG_PKGTMP}/${SYNOPKG_PKGNAME}_backup_v${OCC_VER}_$(date +"%Y%m%d")"
            ${MKDIR} "${TEMPDIR}/database"
            exec_occ maintenance:mode --on
            ${MYSQLDUMP} -u root -p"${wizard_mysql_password_root}" "${MYSQL_DATABASE}" > "${TEMPDIR}/database/${MYSQL_DATABASE}-dbbackup.sql" 2>&1
            ${MKDIR} "${TEMPDIR}/config"
            rsync -aX "${WEB_ROOT}/config/" "${TEMPDIR}/config/" 2>&1
            if [ -d "${WEB_ROOT}/themes" ]; then
                ${MKDIR} "${TEMPDIR}/themes"
                rsync -aX "${WEB_ROOT}/themes/" "${TEMPDIR}/themes/" 2>&1
            fi
            rsync -aX "${DATADIR}" "${TEMPDIR}/" 2>&1
            exec_occ maintenance:mode --off
            tar -C "${TEMPDIR}" -czf "${SYNOPKG_PKGTMP}/${SYNOPKG_PKGNAME}_backup_v${OCC_VER}_$(date +"%Y%m%d")".tar.gz . 2>&1
            rsync -aX --backup --suffix=.bak "${SYNOPKG_PKGTMP}/${SYNOPKG_PKGNAME}_backup_v${OCC_VER}_$(date +"%Y%m%d")".tar.gz "${wizard_export_path}/" 2>&1
            ${RM} "${TEMPDIR}" "${SYNOPKG_PKGTMP}/${SYNOPKG_PKGNAME}_backup_v${OCC_VER}_$(date +"%Y%m%d")".tar.gz
        fi

        db_user="$(exec_occ config:system:get dbuser 2>/dev/null)"
        ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e "DROP DATABASE IF EXISTS ${MYSQL_DATABASE};"
        if [ -n "${db_user}" ]; then
            ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e "DROP USER IF EXISTS '${db_user}'@'localhost';"
        fi
    fi
}

validate_preupgrade() {
    # Confirm data directory exists prior to upgrade prep
    if [ "${SYNOPKG_PKG_STATUS}" = "UPGRADE" ]; then
        DATADIR="$(exec_occ config:system:get datadirectory 2>/dev/null)"
        if [ -z "${DATADIR}" ] || [ ! -d "${DATADIR}" ]; then
            echo "Expected data directory missing; aborting upgrade"
            exit 1
        fi
    fi
}

service_save ()
{
    # Stash existing installation for the upgrade transaction
    exec_occ maintenance:mode --on
    ${RM} "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}"
    ${MKDIR} "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}"
    rsync -aX "${WEB_ROOT}/" "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}" 2>&1
}

service_restore ()
{
    # Restore config/themes/custom_apps and finish upgrade with maintenance routines
    if ! stage_nextcloud_sources; then
        return 1
    fi
    rsync -aX -I "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/config/" "${WEB_ROOT}/config/" 2>&1
    if [ -d "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/themes" ]; then
        rsync -aX -I "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/themes/" "${WEB_ROOT}/themes/" 2>&1
    fi
    if [ -d "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/custom_apps" ]; then
        rsync -aX -I "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/custom_apps/" "${WEB_ROOT}/custom_apps/" 2>&1
    fi
    # Restore user-installed apps that are not part of the base distribution
    if [ -d "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/apps" ]; then
        # Merge apps directory - only copy apps that don't exist in the fresh install
        # This preserves user-installed apps while allowing bundled apps to be updated
        for app_dir in "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/apps"/*/; do
            app_name=$(basename "${app_dir}")
            if [ -n "${app_name}" ] && [ ! -d "${WEB_ROOT}/apps/${app_name}" ]; then
                rsync -aX "${app_dir}" "${WEB_ROOT}/apps/${app_name}/" 2>&1
            fi
        done
    fi
    exec_occ maintenance:mode --off
    exec_occ upgrade
    configure_after_install
    ${RM} "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}"
}
