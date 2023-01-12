
# Package
PACKAGE="tt-rss"

# Others
LOGS_DIR="${SYNOPKG_PKGVAR}/logs"
DSM6_WEB_DIR="/var/services/web"
if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -ge 7 ]; then
  WEB_DIR="/var/services/web_packages"
else
  WEB_DIR="${DSM6_WEB_DIR}"
fi

VERSION_FILE_DIRECTORY="var"
VERSION_FILE="${VERSION_FILE_DIRECTORY}/version.txt"

USER=http
PHP="${SYNOPKG_PKGDEST}/bin/virtual-php"
MARIADB_10_INSTALL_DIRECTORY="/var/packages/MariaDB10"
MARIADB_10_BIN_DIRECTORY="${MARIADB_10_INSTALL_DIRECTORY}/target/usr/local/mariadb10/bin"
MYSQL="${MARIADB_10_BIN_DIRECTORY}/mysql"
MYSQLDUMP="${MARIADB_10_BIN_DIRECTORY}/mysqldump"
MYSQL_USER="ttrss"
MYSQL_DATABASE="ttrss"
SVC_KEEP_LOG=y
SVC_BACKGROUND=y
SVC_WRITE_PID=y

service_postinst ()
{
    if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -lt 7 ]; then
      # Install the web interface
      ${CP} "${SYNOPKG_PKGDEST}/share/${PACKAGE}" ${WEB_DIR} 
    fi
    
    mkdir "-p" "${LOGS_DIR}"

    # Setup database and configuration file
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        "${MYSQL}" -u "${MYSQL_USER}" -p"${wizard_mysql_password_root}" "${MYSQL_DATABASE}" < "${WEB_DIR}/${PACKAGE}/schema/ttrss_schema_mysql.sql"
        single_user_mode=$([ "${wizard_single_user}" == "true" ] && echo "true" || echo "false")
        ${CP} "${WEB_DIR}/${PACKAGE}/config.php-dist" "${WEB_DIR}/${PACKAGE}/config.php"
        {
          echo "putenv('TTRSS_DB_TYPE=mysql');";
          echo "putenv('TTRSS_DB_HOST=localhost');";
          echo "putenv('TTRSS_DB_USER=${MYSQL_USER}');";
          echo "putenv('TTRSS_DB_NAME=${MYSQL_DATABASE}');";
          echo "putenv('TTRSS_DB_PASS=${wizard_mysql_password_ttrss}');";
          echo "putenv('TTRSS_SINGLE_USER_MODE=${single_user_mode}');";
          echo "putenv('TTRSS_SELF_URL_PATH=http://${wizard_domain_name}/${PACKAGE}/');";
          echo "putenv('TTRSS_PHP_EXECUTABLE=${PHP}');";
          echo "putenv('TTRSS_MYSQL_DB_SOCKET=/run/mysqld/mysqld10.sock');"
        } >>"${WEB_DIR}/${PACKAGE}/config.php"
        if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -ge 7 ]; then
          touch "${SYNOPKG_PKGVAR}/.dsm7_migrated"
        fi
    fi

    if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -lt 7 ]; then
      # Fix permissions
      chown "${USER}" "${WEB_DIR}/${PACKAGE}/lock";
      chown "${USER}" "${WEB_DIR}/${PACKAGE}/feed-icons";
      chown -R "${USER}" "${WEB_DIR}/${PACKAGE}/cache";
      chown -R "${USER}" "${LOGS_DIR}";
      chmod +x "${WEB_DIR}/${PACKAGE}/index.php";
    fi

    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
       "${SYNOPKG_PKGDEST}/bin/update-schema"
    fi
    return 0
}

validate_preuninst ()
{
    # Check database
    if [ "${SYNOPKG_PKG_STATUS}" == "UNINSTALL" ] && ! ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e quit > /dev/null 2>&1; then
        echo "Incorrect MySQL root password"
        exit 1
    fi

    # Check database export location
    if [ "${SYNOPKG_PKG_STATUS}" == "UNINSTALL" -a -n "${wizard_dbexport_path}" ]; then
        if [ -f "${wizard_dbexport_path}" -o -e "${wizard_dbexport_path}/${MYSQL_DATABASE}.sql" ]; then
            echo "File ${wizard_dbexport_path}/${MYSQL_DATABASE}.sql already exists. Please remove or choose a different location"
            exit 1
        fi
    fi
}

service_postuninst ()
{
    # Export and remove database
    if [ "${SYNOPKG_PKG_STATUS}" == "UNINSTALL" ]; then
        if [ -n "${wizard_dbexport_path}" ]; then
            ${MKDIR} ${wizard_dbexport_path}
            ${MYSQLDUMP} -u root -p"${wizard_mysql_password_root}" ${MYSQL_DATABASE} > ${wizard_dbexport_path}/${MYSQL_DATABASE}.sql
        fi
    fi

    if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -lt 7 ]; then
      # Remove the web interface
      ${RM} ${WEB_DIR}/${PACKAGE}
    fi

    return 0
}

service_preupgrade ()
{
    SOURCE_WEB_DIR="${WEB_DIR}"
    if [ ! -f "${SYNOPKG_PKGVAR}/.dsm7_migrated" ]; then
      if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -ge 7 ]; then
        SOURCE_WEB_DIR="${DSM6_WEB_DIR}"
      fi
    fi
    # Save the configuration file
    ${MKDIR} "${TMP_DIR}/${PACKAGE}"
    ${CP} "${SOURCE_WEB_DIR}/${PACKAGE}/config.php" "${TMP_DIR}/${PACKAGE}/"

    ${MKDIR} "${TMP_DIR}/${PACKAGE}/feed-icons/"
    ${CP} "${SOURCE_WEB_DIR}/${PACKAGE}/feed-icons"/*.ico "${TMP_DIR}/${PACKAGE}/feed-icons/"

    ${CP} "${SOURCE_WEB_DIR}/${PACKAGE}/plugins.local" "${TMP_DIR}/${PACKAGE}/"
    ${CP} "${SOURCE_WEB_DIR}/${PACKAGE}/themes.local" "${TMP_DIR}/${PACKAGE}/"

    ${MKDIR} -p "${TMP_DIR}/${PACKAGE}/${VERSION_FILE_DIRECTORY}"
    echo "${SYNOPKG_OLD_PKGVER}" | sed -r "s/^.*-([0-9]+)$/\1/" >"${TMP_DIR}/${PACKAGE}/${VERSION_FILE}"

    return 0
}

service_postupgrade ()
{
    if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -ge 7 ]; then
      touch "${SYNOPKG_PKGVAR}/.dsm7_migrated"
    fi
    # Restore the configuration file
    ${CP} "${TMP_DIR}/${PACKAGE}/config.php" "${WEB_DIR}/${PACKAGE}/config.php"
    SPK_REV=$(cat "${TMP_DIR}/${PACKAGE}/${VERSION_FILE}")
    if [ "${SPK_REV}" -lt "14" ]
    then
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
    if [ "${SPK_REV}" -lt "15" ]
    then
      sed -i -e "s|putenv('TTRSS_DB_PASS=.*');|putenv('TTRSS_DB_PASS=${wizard_mysql_password_ttrss}');|" \
        "${WEB_DIR}/${PACKAGE}/config.php"
      echo "putenv('TTRSS_MYSQL_DB_SOCKET=/run/mysqld/mysqld10.sock');">>"${WEB_DIR}/${PACKAGE}/config.php"
    fi

    ${MV} "${TMP_DIR}/${PACKAGE}"/feed-icons/*.ico "${WEB_DIR}/${PACKAGE}"/feed-icons/;
    ${MV} "${TMP_DIR}/${PACKAGE}"/plugins.local/* "${WEB_DIR}/${PACKAGE}"/plugins.local/;
    ${MV} "${TMP_DIR}/${PACKAGE}"/themes.local/* "${WEB_DIR}/${PACKAGE}"/themes.local/;

    "${SYNOPKG_PKGDEST}"/bin/update-schema;

    return 0
}
