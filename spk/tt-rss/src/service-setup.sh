
# Package
PACKAGE="tt-rss"
SVC_KEEP_LOG=y
SVC_BACKGROUND=y
SVC_WRITE_PID=y

# Others
DSM6_WEB_DIR="/var/services/web"
if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -ge 7 ]; then
  WEB_DIR="/var/services/web_packages"
else
  WEB_DIR="${DSM6_WEB_DIR}"
fi
LOGS_DIR="${WEB_DIR}/${PACKAGE}/logs"

VERSION_FILE_DIRECTORY="var"
VERSION_FILE="${VERSION_FILE_DIRECTORY}/version.txt"

if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 7 ]; then
    WEB_USER="http"
    WEB_GROUP="http"
fi

PHP="/usr/local/bin/php74"
JQ="/bin/jq"
SYNOSVC="/usr/syno/sbin/synoservice"
MARIADB_10_INSTALL_DIRECTORY="/var/packages/MariaDB10"
MARIADB_10_BIN_DIRECTORY="${MARIADB_10_INSTALL_DIRECTORY}/target/usr/local/mariadb10/bin"
MYSQL="${MARIADB_10_BIN_DIRECTORY}/mysql"
MYSQLDUMP="${MARIADB_10_BIN_DIRECTORY}/mysqldump"
MYSQL_USER="ttrss"
MYSQL_DATABASE="ttrss"

exec_update_schema() {
  TTRSS="${WEB_DIR}/${PACKAGE}/update.php --update-schema=force-yes"
  COMMAND="${PHP} ${TTRSS}"
  if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 7 ]; then
      /bin/su "$WEB_USER" -s /bin/sh -c "${COMMAND}"
  else
      $COMMAND
  fi
  return $?
}

service_prestart ()
{
  TTRSS="${WEB_DIR}/${PACKAGE}/update.php --daemon"
  LOG_FILE="${LOGS_DIR}/daemon.log"
  COMMAND="${PHP} ${TTRSS}"
  if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 7 ]; then
      /bin/su "$WEB_USER" -s /bin/sh -c "${COMMAND}" >> ${LOG_FILE} 2>&1 &
  else
      $COMMAND >> ${LOG_FILE} 2>&1 &
  fi
  echo "$!" > "${PID_FILE}"
}

service_postinst ()
{
  if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -lt 7 ]; then
    # Install the web interface
    ${CP} "${SYNOPKG_PKGDEST}/share/${PACKAGE}" ${WEB_DIR}

    TEMPDIR="${SYNOPKG_PKGTMP}/web"
    ${MKDIR} ${TEMPDIR}

    WS_CFG_PATH="/usr/syno/etc/packages/WebStation"
    WS_CFG_FILE="WebStation.json"
    FULL_WS_CFG_FILE="${WS_CFG_PATH}/${WS_CFG_FILE}"
    TEMP_WS_CFG_FILE="${TEMPDIR}/${WS_CFG_FILE}"
    PHP_CFG_FILE="PHPSettings.json"
    PHP_PROF_NAME="Default PHP 7.4 Profile"
    FULL_PHP_CFG_FILE="${WS_CFG_PATH}/${PHP_CFG_FILE}"
    TEMP_PHP_CFG_FILE="${TEMPDIR}/${PHP_CFG_FILE}"
    WS_BACKEND=$(${JQ} -r '.default.backend' "${FULL_WS_CFG_FILE}")
    WS_PHP=$(${JQ} -r '.default.php' "${FULL_WS_CFG_FILE}")
    RESTART_APACHE="no"
    RSYNC_ARCH_ARGS="--backup --suffix=.bak --remove-source-files"
    # Check if Apache is the selected back-end
    if [ ! "$WS_BACKEND" = "2" ]; then
        echo "Set Apache as the back-end server"
        ${JQ} '.default.backend = 2' "${FULL_WS_CFG_FILE}" > "${TEMP_WS_CFG_FILE}"
        rsync -aX ${RSYNC_ARCH_ARGS} "${TEMP_WS_CFG_FILE}" "${WS_CFG_PATH}/" 2>&1
        RESTART_APACHE="yes"
    fi
    # Check if default PHP profile is selected
    if [ -z "$WS_PHP" ] || [ "$WS_PHP" = "null" ]; then
        echo "Enable default PHP profile"
        # Locate default PHP profile
        PHP_PROF_ID=$(${JQ} -r '. | to_entries[] | select(.value | type == "object" and .profile_desc == "'"$PHP_PROF_NAME"'") | .key' "${FULL_PHP_CFG_FILE}")
        ${JQ} ".default.php = \"$PHP_PROF_ID\"" "${FULL_WS_CFG_FILE}" > "${TEMP_WS_CFG_FILE}"
        rsync -aX ${RSYNC_ARCH_ARGS} "${TEMP_WS_CFG_FILE}" "${WS_CFG_PATH}/" 2>&1
        RESTART_APACHE="yes"
    fi
    # Check for tt-rss PHP profile
    if ! ${JQ} -e '.["com-synocommunity-packages-tt-rss"]' "${FULL_PHP_CFG_FILE}" >/dev/null; then
        echo "Add PHP profile for tt-rss"
        ${JQ} --slurpfile ttRssNode "${SYNOPKG_PKGDEST}/web/tt-rss.json" '.["com-synocommunity-packages-tt-rss"] = $ttRssNode[0]' "${FULL_PHP_CFG_FILE}" > "${TEMP_PHP_CFG_FILE}"
        rsync -aX ${RSYNC_ARCH_ARGS} "${TEMP_PHP_CFG_FILE}" "${WS_CFG_PATH}/" 2>&1
        RESTART_APACHE="yes"
    fi
    # Check for tt-rss Apache config
    if [ ! -f "/usr/local/etc/apache24/sites-enabled/tt-rss.conf" ]; then
        echo "Add Apache config for tt-rss"
        rsync -aX ${SYNOPKG_PKGDEST}/web/tt-rss.conf /usr/local/etc/apache24/sites-enabled/ 2>&1
        RESTART_APACHE="yes"
    fi
    # Restart Apache if configs have changed
    if [ "${RESTART_APACHE}" = "yes" ]; then
        if ${JQ} -e 'to_entries | map(select((.key | startswith("com-synocommunity-packages-")) and .key != "com-synocommunity-packages-tt-rss")) | length > 0' "${FULL_PHP_CFG_FILE}" >/dev/null; then
            echo " [WARNING] Multiple PHP profiles detected, will require restart of DSM to load new configs"
        else
            echo "Restart Apache to load new configs"
            ${SYNOSVC} --restart pkgctl-Apache2.4
        fi
    fi
    # Clean-up temporary files
    ${RM} "${TEMPDIR}"
  fi

  mkdir "-p" "${LOGS_DIR}"

  # Setup database and configuration file
  if [ "${SYNOPKG_PKG_STATUS}" = "INSTALL" ]; then
    single_user_mode=$([ "${wizard_single_user}" = "true" ] && echo "true" || echo "false")
    ${CP} "${WEB_DIR}/${PACKAGE}/config.php-dist" "${WEB_DIR}/${PACKAGE}/config.php"
    {
      echo "putenv('TTRSS_DB_TYPE=mysql');"
      echo "putenv('TTRSS_DB_HOST=localhost');"
      echo "putenv('TTRSS_DB_USER=${MYSQL_USER}');"
      echo "putenv('TTRSS_DB_NAME=${MYSQL_DATABASE}');"
      echo "putenv('TTRSS_DB_PASS=${wizard_mysql_password_ttrss}');"
      echo "putenv('TTRSS_SINGLE_USER_MODE=${single_user_mode}');"
      echo "putenv('TTRSS_SELF_URL_PATH=http://${wizard_domain_name}/${PACKAGE}/');"
      echo "putenv('TTRSS_PHP_EXECUTABLE=${PHP}');"
      echo "putenv('TTRSS_MYSQL_DB_SOCKET=/run/mysqld/mysqld10.sock');"
    } >>"${WEB_DIR}/${PACKAGE}/config.php"
    if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -ge 7 ]; then
      touch "${SYNOPKG_PKGVAR}/.dsm7_migrated"
    fi
  fi

  if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -lt 7 ]; then
    # Fix permissions
    chown -R "${WEB_USER}:${WEB_GROUP}" "${WEB_DIR}/${PACKAGE}"
    chown -R "${WEB_USER}:${WEB_GROUP}" "${LOGS_DIR}"
  fi

  if [ "${SYNOPKG_PKG_STATUS}" = "INSTALL" ]; then
    exec_update_schema
  fi

  return 0
}

validate_preinst ()
{
  # Check for modification to PHP template defaults on DSM 6
  if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 7 ]; then
    WS_TMPL_PATH="/var/packages/WebStation/target/misc"
    WS_TMPL_FILE="php74_fpm.mustache"
    FULL_WS_TMPL_FILE="${WS_TMPL_PATH}/${WS_TMPL_FILE}"
    # Check for PHP template defaults
    if ! grep -q -E '^user = http$' "${FULL_WS_TMPL_FILE}" || ! grep -q -E '^listen\.owner = http$' "${FULL_WS_TMPL_FILE}"; then
      echo "PHP template defaults have been modified. Installation is not supported."
      exit 1
    fi
  fi
}

validate_preuninst ()
{
  # Check database
  if [ "${SYNOPKG_PKG_STATUS}" = "UNINSTALL" ] && ! ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e quit > /dev/null 2>&1; then
    echo "Incorrect MySQL root password"
    exit 1
  fi

  # Check database export location
  if [ "${SYNOPKG_PKG_STATUS}" = "UNINSTALL" ] && [ -n "${wizard_dbexport_path}" ]; then
    if [ -f "${wizard_dbexport_path}" ] || [ -e "${wizard_dbexport_path}/${MYSQL_DATABASE}.sql" ]; then
      echo "File ${wizard_dbexport_path}/${MYSQL_DATABASE}.sql already exists. Please remove or choose a different location"
      exit 1
    fi
  fi
}

service_preuninst ()
{
  # Export database
  if [ "${SYNOPKG_PKG_STATUS}" = "UNINSTALL" ]; then
    if [ -n "${wizard_dbexport_path}" ]; then
      ${MKDIR} -p "${wizard_dbexport_path}"
      ${MYSQLDUMP} -u root -p"${wizard_mysql_password_root}" "${MYSQL_DATABASE}" > "${wizard_dbexport_path}/${MYSQL_DATABASE}.sql"
    fi
  fi  
}

service_postuninst ()
{
  if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -lt 7 ]; then
    # Remove the web interface
    ${RM} ${WEB_DIR}/${PACKAGE}

    # Remove web configurations
    TEMPDIR="${SYNOPKG_PKGTMP}/web"
    ${MKDIR} ${TEMPDIR}
    WS_CFG_PATH="/usr/syno/etc/packages/WebStation"
    PHP_CFG_FILE="PHPSettings.json"
    FULL_PHP_CFG_FILE="${WS_CFG_PATH}/${PHP_CFG_FILE}"
    TEMP_PHP_CFG_FILE="${TEMPDIR}/${PHP_CFG_FILE}"
    RESTART_APACHE="no"
    RSYNC_ARCH_ARGS="--backup --suffix=.bak --remove-source-files"
    # Check for tt-rss PHP profile
    if ${JQ} -e '.["com-synocommunity-packages-tt-rss"]' "${FULL_PHP_CFG_FILE}" >/dev/null; then
        echo "Removing PHP profile for tt-rss"
        ${JQ} 'del(.["com-synocommunity-packages-tt-rss"])' ${FULL_PHP_CFG_FILE} > ${TEMP_PHP_CFG_FILE}
        rsync -aX ${RSYNC_ARCH_ARGS} ${TEMP_PHP_CFG_FILE} ${WS_CFG_PATH}/ 2>&1
        ${RM} "${WS_CFG_PATH}/php_profile/com-synocommunity-packages-tt-rss"
        RESTART_APACHE="yes"
    fi
    # Check for tt-rss Apache config
    if [ -f "/usr/local/etc/apache24/sites-enabled/tt-rss.conf" ]; then
        echo "Removing Apache config for tt-rss"
        ${RM} /usr/local/etc/apache24/sites-enabled/tt-rss.conf
        RESTART_APACHE="yes"
    fi
    # Restart Apache if configs have changed
    if [ "$RESTART_APACHE" = "yes" ]; then
        if ${JQ} -e 'to_entries | map(select((.key | startswith("com-synocommunity-packages-")) and .key != "com-synocommunity-packages-tt-rss")) | length > 0' "${FULL_PHP_CFG_FILE}" >/dev/null; then
            echo " [WARNING] Multiple PHP profiles detected, will require restart of DSM to load new configs"
        else
            echo "Restart Apache to load new configs"
            ${SYNOSVC} --restart pkgctl-Apache2.4
        fi
    fi
    # Clean-up temporary files
    ${RM} "${TEMPDIR}"
  fi

  return 0
}

service_save ()
{
  SOURCE_WEB_DIR="${WEB_DIR}"
  if [ ! -f "${SYNOPKG_PKGVAR}/.dsm7_migrated" ]; then
    if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -ge 7 ]; then
      SOURCE_WEB_DIR="${DSM6_WEB_DIR}"
    fi
  fi
  # Save the configuration file
  ${MKDIR} "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE}"
  ${CP} "${SOURCE_WEB_DIR}/${PACKAGE}/config.php" "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE}/"

  ${MKDIR} "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE}/feed-icons/"
  ${CP} "${SOURCE_WEB_DIR}/${PACKAGE}/feed-icons"/*.ico "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE}/feed-icons/" 2>/dev/null

  ${CP} "${SOURCE_WEB_DIR}/${PACKAGE}/plugins.local" "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE}/" 2>/dev/null
  ${CP} "${SOURCE_WEB_DIR}/${PACKAGE}/themes.local" "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE}/" 2>/dev/null

  ${MKDIR} -p "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE}/${VERSION_FILE_DIRECTORY}"
  echo "${SYNOPKG_OLD_PKGVER}" | sed -r "s/^.*-([0-9]+)$/\1/" >"${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE}/${VERSION_FILE}"

  ${MKDIR} -p "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE}/cache/feed-icons/"
  ${CP} "${SOURCE_WEB_DIR}/${PACKAGE}/cache/feed-icons"/* "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE}/cache/feed-icons/" 2>/dev/null

  return 0
}

service_restore ()
{
  if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -ge 7 ]; then
    touch "${SYNOPKG_PKGVAR}/.dsm7_migrated"
  fi
  # Restore the configuration file
  ${CP} "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE}/config.php" "${WEB_DIR}/${PACKAGE}/config.php"
  OLD_SPK_REV=$(cat "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE}/${VERSION_FILE}")
  if [ "${OLD_SPK_REV}" -lt "14" ]; then
    # Parse old configuration and save to new config format
    sed -i -e "s|define('DB_TYPE', '\(.*\)');|putenv('TTRSS_DB_TYPE=\1');|" \
      -e "s|define('DB_HOST', '\(.*\)');|putenv('TTRSS_DB_HOST=\1');|" \
      -e "s|define('DB_USER', '\(.*\)');|putenv('TTRSS_DB_USER=\1');|" \
      -e "s|define('DB_NAME', '\(.*\)');|putenv('TTRSS_DB_NAME=\1');|" \
      -e "s|define('DB_PASS', '\(.*\)');|putenv('TTRSS_DB_PASS=\1');|" \
      -e "s|define('SINGLE_USER_MODE', \(.*\));|putenv('TTRSS_SINGLE_USER_MODE=\1');|" \
      -e "s|define('SELF_URL_PATH', '\(.*\)');|putenv('TTRSS_SELF_URL_PATH=\1');|" \
      -e "s|define('DB_PORT', '\(.*\)');|putenv('TTRSS_DB_PORT=\1');|" \
      -e "s|define('PHP_EXECUTABLE', \(.*\));||" \
      "${WEB_DIR}/${PACKAGE}/config.php"
    echo "putenv('TTRSS_PHP_EXECUTABLE=${PHP}');">>"${WEB_DIR}/${PACKAGE}/config.php"
  fi
  if [ "${OLD_SPK_REV}" -lt "15" ]; then
    sed -i -e "s|putenv('TTRSS_DB_PASS=.*');|putenv('TTRSS_DB_PASS=${wizard_mysql_password_ttrss}');|" \
      "${WEB_DIR}/${PACKAGE}/config.php"
    echo "putenv('TTRSS_MYSQL_DB_SOCKET=/run/mysqld/mysqld10.sock');">>"${WEB_DIR}/${PACKAGE}/config.php"
  fi
  if [ "${OLD_SPK_REV}" -lt "17" ]; then
    # Check config file for legacy PHP exec to migrate
    PHP_EXEC_LINE="putenv('TTRSS_PHP_EXECUTABLE=${PHP}');"
    SEARCH_PATTERN="^putenv('TTRSS_PHP_EXECUTABLE="
    sed -i "s|$SEARCH_PATTERN.*|$PHP_EXEC_LINE|" "${WEB_DIR}/${PACKAGE}/config.php"
    echo "Legacy PHP exec config migrated successfully."
  fi

  ${MV} "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE}"/feed-icons/*.ico "${WEB_DIR}/${PACKAGE}"/feed-icons/ 2>/dev/null
  ${MV} "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE}"/plugins.local/* "${WEB_DIR}/${PACKAGE}"/plugins.local/ 2>/dev/null
  ${MV} "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE}"/themes.local/* "${WEB_DIR}/${PACKAGE}"/themes.local/ 2>/dev/null

  ${MKDIR} -p "${WEB_DIR}/${PACKAGE}/cache/feed-icons/"
  ${MV} "${SYNOPKG_TEMP_UPGRADE_FOLDER}/${PACKAGE}"/cache/feed-icons/* "${WEB_DIR}/${PACKAGE}"/cache/feed-icons/ 2>/dev/null

  exec_update_schema

  return 0
}
