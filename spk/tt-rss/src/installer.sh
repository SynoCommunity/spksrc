#!/bin/sh

# Package
PACKAGE="ttrss"
DNAME="Tiny Tiny RSS"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
SSS="/var/packages/${PACKAGE}/scripts/start-stop-status"
WEB_DIR="/var/services/web"
USER="nobody"
MYSQL="/usr/syno/mysql/bin/mysql"
MYSQL_USER="ttrss"
MYSQL_DATABASE="ttrss"
TMP_DIR="${SYNOPKG_PKGDEST}/../../@tmp"


preinst ()
{
    # Check database
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        if ! ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e quit > /dev/null 2>&1; then
            echo "Incorrect MySQL root password"
            exit 1
        fi
        if ${MYSQL} -u root -p"${wizard_mysql_password_root}" mysql -e "SELECT User FROM user" | grep ^${MYSQL_USER}$ > /dev/null 2>&1; then
            echo "MySQL user ${MYSQL_USER} already exists"
            exit 1
        fi
        if ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e "SHOW DATABASES" | grep ^${MYSQL_DATABASE}$ > /dev/null 2>&1; then
            echo "MySQL database ${MYSQL_DATABASE} already exists"
            exit 1
        fi
    fi

    exit 0
}

postinst ()
{
    # Link
    ln -s ${SYNOPKG_PKGDEST} ${INSTALL_DIR}

    # Install busybox stuff
    ${INSTALL_DIR}/bin/busybox --install ${INSTALL_DIR}/bin

    # Install the web interface
    cp -R ${INSTALL_DIR}/share/tt-rss ${WEB_DIR}

    # Setup database and configuration file
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e "CREATE DATABASE ${MYSQL_DATABASE}; GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'localhost' IDENTIFIED BY '${wizard_mysql_password_ttrss}';"
        ${MYSQL} -u ${MYSQL_USER} -p"${wizard_mysql_password_ttrss}" ${MYSQL_DATABASE} < ${WEB_DIR}/tt-rss/schema/ttrss_schema_mysql.sql
        sed -e "s|define('DB_TYPE', \"pgsql\");|define('DB_TYPE', 'mysql');|" \
            -e "s|define('DB_USER', \"fox\");|define('DB_USER', '${MYSQL_USER}');|" \
            -e "s|define('DB_NAME', \"fox\");|define('DB_NAME', '${MYSQL_DATABASE}');|" \
            -e "s|define('DB_PASS', \"XXXXXX\");|define('DB_PASS', '${wizard_mysql_password_ttrss}');|" \
            -e "s|define('SELF_URL_PATH', 'http://yourserver/tt-rss/');|define('SELF_URL_PATH', 'http://${wizard_domain_name}/tt-rss/');|" \
            ${WEB_DIR}/tt-rss/config.php-dist > ${WEB_DIR}/tt-rss/config.php
    fi

    # Fix permissions
    chown ${USER} ${WEB_DIR}/tt-rss/lock
    chown ${USER} ${WEB_DIR}/tt-rss/feed-icons
    chown -R ${USER} ${WEB_DIR}/tt-rss/cache

    exit 0
}

preuninst ()
{
    # Check database
    if [ "${SYNOPKG_PKG_STATUS}" == "UNINSTALL" -a "${wizard_remove_database}" == "true" ] && ! ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e quit > /dev/null 2>&1; then
        echo "Incorrect MySQL root password"
        exit 1
    fi

    # Stop the package
    ${SSS} stop > /dev/null

    exit 0
}

postuninst ()
{
    # Remove link
    rm -f ${INSTALL_DIR}

    # Remove database
    if [ "${SYNOPKG_PKG_STATUS}" == "UNINSTALL" -a "${wizard_remove_database}" == "true" ]; then
        ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e "DROP DATABASE ${MYSQL_DATABASE}; DROP USER '${MYSQL_USER}'@'localhost';"
    fi

    # Remove the web interface
    rm -fr ${WEB_DIR}/tt-rss

    exit 0
}

preupgrade ()
{
    # Stop the package
    ${SSS} stop > /dev/null

    # Save the configuration file
    rm -fr ${TMP_DIR}/${PACKAGE}
    mkdir -p ${TMP_DIR}/${PACKAGE}
    mv ${WEB_DIR}/tt-rss/config.php ${TMP_DIR}/${PACKAGE}/

    exit 0
}

postupgrade ()
{
    # Restore the configuration file if it has not been updated
    old_config_version=$(grep 'CONFIG_VERSION' ${TMP_DIR}/${PACKAGE}/config.php | sed "s/define('CONFIG_VERSION', \([0-9]\+\));/\1/")
    new_config_version=$(grep 'CONFIG_VERSION' ${WEB_DIR}/tt-rss/config.php-dist | sed "s/define('CONFIG_VERSION', \([0-9]\+\));/\1/")
    if [ ${old_config_version} -ne ${new_config_version} ]; then
        echo "Configuration file ${WEB_DIR}/tt-rss/config.php needs to be updated manually. See ${WEB_DIR}/tt-rss/config.php-dist for changes to apply."
    fi
    mv ${TMP_DIR}/${PACKAGE}/config.php ${WEB_DIR}/tt-rss/
    rm -fr ${TMP_DIR}/${PACKAGE}

    exit 0
}
