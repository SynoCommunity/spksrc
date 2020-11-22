#!/bin/sh

# Package
PACKAGE="tt-rss"
DNAME="Tiny Tiny RSS"

# Others
LINK_DIR="/usr/local/${PACKAGE}"
LOGS_DIR="${SYNOPKG_PKGDEST}/var/logs"
SSS="/var/packages/${PACKAGE}/scripts/start-stop-status"
WEB_DIR="/var/services/web"
TMP_DIR="${SYNOPKG_PKGDEST}/../../@tmp"
BUILDNUMBER="$(/bin/get_key_value /etc.defaults/VERSION buildnumber)"

USER="$([ "${BUILDNUMBER}" -ge "4418" ] && echo -n http || echo -n nobody)"
PHP="${SYNOPKG_PKGDEST}/bin/virtual-php"
MYSQL="$([ "${BUILDNUMBER}" -ge "7321" ] && echo -n /bin/mysql || echo -n /usr/syno/mysql/bin/mysql)"
MYSQLDUMP="$([ "${BUILDNUMBER}" -ge "7321" ] && echo -n /bin/mysqldump || echo -n /usr/syno/mysql/bin/mysqldump)"
MYSQL_USER="ttrss"
MYSQL_DATABASE="ttrss"
MYSQL_USER_EXISTS=0
MYSQL_DATABASE_EXISTS=0

MYSQL_STATUS_VARS="${TMP_DIR}/mysql-status-vars"

preinst ()
{
    # Check database
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        mkdir -p "${TMP_DIR}"
        if ! ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e quit > /dev/null 2>&1; then
            echo "Incorrect MySQL root password"
            exit 1
        fi
        if ${MYSQL} -u root -p"${wizard_mysql_password_root}" mysql -e "SELECT User FROM user" | grep ^${MYSQL_USER}$ > /dev/null 2>&1; then
            echo "MySQL user ${MYSQL_USER} already exists and will be re-used"
            echo "MYSQL_USER_EXISTS=1">>"${MYSQL_STATUS_VARS}"
            #exit 1
        fi
        if ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e "SHOW DATABASES" | grep ^${MYSQL_DATABASE}$ > /dev/null 2>&1; then
            echo "MySQL database ${MYSQL_DATABASE} already exists and will be re-used"
            echo "MYSQL_DATABASE_EXISTS=1">>"${MYSQL_STATUS_VARS}"
            #exit 1
        fi
    fi

    return 0
}

postinst ()
{
    if [ -f "${MYSQL_STATUS_VARS}" ]; then
        . "${MYSQL_STATUS_VARS}"
        rm "${MYSQL_STATUS_VARS}"
    fi
    # Link
    ln -s ${SYNOPKG_PKGDEST} ${LINK_DIR} >> "${LOGS_DIR}/${PACKAGE}_install.log" 2>&1

    # Install busybox stuff
    ${SYNOPKG_PKGDEST}/bin/busybox --install ${SYNOPKG_PKGDEST}/bin >> "${LOGS_DIR}/${PACKAGE}_install.log" 2>&1

    # Install the web interface
    cp -pR ${SYNOPKG_PKGDEST}/share/${PACKAGE} ${WEB_DIR} >> "${LOGS_DIR}/${PACKAGE}_install.log" 2>&1

    # Setup database and configuration file
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        if [ "${MYSQL_DATABASE_EXISTS}" == "0" ]; then
            "${MYSQL}" -u root -p"${wizard_mysql_password_root}" -e "CREATE DATABASE ${MYSQL_DATABASE};"  >> "${LOGS_DIR}/${PACKAGE}_install.log" 2>&1
        fi
        if [ "${MYSQL_USER_EXISTS}" == "0" ]; then
            "${MYSQL}" -u root -p"${wizard_mysql_password_root}" -e "GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'localhost' IDENTIFIED BY '${wizard_mysql_password_ttrss}';"  >> "${LOGS_DIR}/${PACKAGE}_install.log" 2>&1
        fi
        "${MYSQL}" -u "${MYSQL_USER}" -p"${wizard_mysql_password_ttrss}" "${MYSQL_DATABASE}" < "${WEB_DIR}/${PACKAGE}/schema/ttrss_schema_mysql.sql"  >> "${LOGS_DIR}/${PACKAGE}_install.log" 2>&1
        single_user_mode=$([ "${wizard_single_user}" == "true" ] && echo "true" || echo "false")
        sed -e "s|define('DB_TYPE', '.*');|define('DB_TYPE', 'mysql');|" \
            -e "s|define('DB_HOST', '.*');|define('DB_HOST', 'localhost');|" \
            -e "s|define('DB_USER', '.*');|define('DB_USER', '${MYSQL_USER}');|" \
            -e "s|define('DB_NAME', '.*');|define('DB_NAME', '${MYSQL_DATABASE}');|" \
            -e "s|define('DB_PASS', '.*');|define('DB_PASS', '${wizard_mysql_password_ttrss}');|" \
            -e "s|define('SINGLE_USER_MODE', .*);|define('SINGLE_USER_MODE', ${single_user_mode});|" \
            -e "s|define('SELF_URL_PATH', '.*');|define('SELF_URL_PATH', 'http://${wizard_domain_name}/${PACKAGE}/');|" \
            -e "s|define('DB_PORT', '.*');|define('DB_PORT', '3306');|" \
            -e "s|define('PHP_EXECUTABLE', '.*');|define('PHP_EXECUTABLE', '${PHP}');|" \
            ${WEB_DIR}/${PACKAGE}/config.php-dist > ${WEB_DIR}/${PACKAGE}/config.php 2>> "${LOGS_DIR}/${PACKAGE}_install.log"
    fi

    # Fix permissions
    chown "${USER}" "${WEB_DIR}/${PACKAGE}/lock" >> "${LOGS_DIR}/${PACKAGE}_install.log" 2>&1
    chown "${USER}" "${WEB_DIR}/${PACKAGE}/feed-icons"  >> "${LOGS_DIR}/${PACKAGE}_install.log" 2>&1
    chown -R "${USER}" "${WEB_DIR}/${PACKAGE}/cache"  >> "${LOGS_DIR}/${PACKAGE}_install.log" 2>&1
    chown -R "${USER}" "${LOGS_DIR}" >> "${LOGS_DIR}/${PACKAGE}_install.log" 2>&1
    chmod +x "${WEB_DIR}/${PACKAGE}/index.php"
    return 0
}

preuninst ()
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

    # Stop the package
    ${SSS} stop > /dev/null

    return 0
}

postuninst ()
{
    # Remove link
    rm -f ${LINK_DIR}

    # Export and remove database
    if [ "${SYNOPKG_PKG_STATUS}" == "UNINSTALL" ]; then
        if [ -n "${wizard_dbexport_path}" ]; then
            mkdir -p ${wizard_dbexport_path}
            ${MYSQLDUMP} -u root -p"${wizard_mysql_password_root}" ${MYSQL_DATABASE} > ${wizard_dbexport_path}/${MYSQL_DATABASE}.sql
        fi
        ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e "DROP DATABASE ${MYSQL_DATABASE}; DROP USER '${MYSQL_USER}'@'localhost';"
    fi

    # Remove the web interface
    rm -fr ${WEB_DIR}/${PACKAGE}

    return 0
}

preupgrade ()
{
    # Stop the package
    ${SSS} stop > /dev/null

    # Save the configuration file
    rm -fr ${TMP_DIR}/${PACKAGE}
    mkdir -p ${TMP_DIR}/${PACKAGE}
    mv ${WEB_DIR}/${PACKAGE}/config.php ${TMP_DIR}/${PACKAGE}/

    mkdir ${TMP_DIR}/${PACKAGE}/feed-icons/
    mv ${WEB_DIR}/${PACKAGE}/feed-icons/*.ico ${TMP_DIR}/${PACKAGE}/feed-icons/

    mv ${WEB_DIR}/${PACKAGE}/plugins.local ${TMP_DIR}/${PACKAGE}/
    mv ${WEB_DIR}/${PACKAGE}/themes.local ${TMP_DIR}/${PACKAGE}/

    exit 0
}

postupgrade ()
{
    # Restore the configuration file
    mv ${TMP_DIR}/${PACKAGE}/config.php ${WEB_DIR}/${PACKAGE}/config-bak.php  >> "${LOGS_DIR}/${PACKAGE}_install.log" 2>&1
    cp ${WEB_DIR}/${PACKAGE}/config.php-dist ${WEB_DIR}/${PACKAGE}/config.php >> "${LOGS_DIR}/${PACKAGE}_install.log" 2>&1

    # Parse configuration and save to new config
    while read line
    do
        key=`echo $line | sed -n "s|^define('\(.*\)',\(.*\));.*|\1|p"`
        val=`echo $line | sed -n "s|^define('\(.*\)',\(.*\));.*|\2|p"`
        if [ "$key" == "" ]; then
            continue
        fi
        sed -i -e "s|define('$key', .*);|define('$key', $val);|g" \
               -e "s|define('PHP_EXECUTABLE', '.*');|define('PHP_EXECUTABLE', '${PHP}');|" \
            ${WEB_DIR}/${PACKAGE}/config.php >> "${LOGS_DIR}/${PACKAGE}_install.log" 2>&1
    done < ${WEB_DIR}/${PACKAGE}/config-bak.php

    mv -f ${TMP_DIR}/${PACKAGE}/feed-icons/*.ico ${WEB_DIR}/${PACKAGE}/feed-icons/  >> "${LOGS_DIR}/${PACKAGE}_install.log" 2>&1
    mv -f ${TMP_DIR}/${PACKAGE}/plugins.local/* ${WEB_DIR}/${PACKAGE}/plugins.local/  >> "${LOGS_DIR}/${PACKAGE}_install.log" 2>&1
    mv -f ${TMP_DIR}/${PACKAGE}/themes.local/* ${WEB_DIR}/${PACKAGE}/themes.local/  >> "${LOGS_DIR}/${PACKAGE}_install.log" 2>&1

    rm -fr ${TMP_DIR}/${PACKAGE} >> "${LOGS_DIR}/${PACKAGE}_install.log" 2>&1

    ${SYNOPKG_PKGDEST}/bin/update-schema >> "${LOGS_DIR}/${PACKAGE}_install.log" 2>&1

    return 0
}
