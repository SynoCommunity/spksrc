#!/bin/sh

# Package
PACKAGE="spotweb"

# Get DSM Version & Set MYSQL
[ -f "/etc.defaults/VERSION" ] || exit 1
DSM_VERSION=`grep ^majorversion= /etc.defaults/VERSION | cut -d'"' -f2`
[ -z "$DSM_VERSION" ] && exit 1

if [ $DSM_VERSION -le 4 ]; then
	MYSQL="/usr/syno/mysql/bin/mysql"
	USER="nobody"
else
	MYSQL="/usr/bin/mysql"
	USER="http"
fi

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
SSS="/var/packages/${PACKAGE}/scripts/start-stop-status"
WEB_DIR="/var/services/web"
MYSQL_USER="spotweb"
MYSQL_DATABASE="spotweb"
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
# Create conf folder and write conf/PKG_DEPS for MariaDB
mkdir -p /var/packages/Spotweb/conf
cat > /var/packages/Spotweb/conf/PKG_DEPS << EOF
[MariaDB]
dsm_min_ver=5.0-4300
EOF

    # Link
    ln -s ${SYNOPKG_PKGDEST} ${INSTALL_DIR}

    # Install the web interface
    cp -R ${INSTALL_DIR}/www ${WEB_DIR}/${PACKAGE}

    # Create the cache directory and give this the correct permissions
    mkdir ${WEB_DIR}/${PACKAGE}/cache
    chmod -R 777 ${WEB_DIR}/${PACKAGE}/cache

    # Remove web interface from install directory
    rm -r ${INSTALL_DIR}/www

    # Setup database
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e "CREATE DATABASE ${MYSQL_DATABASE}; GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'localhost' IDENTIFIED BY '${wizard_mysql_password_spotweb}';"
    fi

    # Fix permissions
    chown -R ${USER} ${WEB_DIR}/${PACKAGE}

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
    rm -fr ${WEB_DIR}/${PACKAGE}

    exit 0
}

preupgrade ()
{
    # Stop the package
    ${SSS} stop > /dev/null
	
    # Fix permissions
    chown -R ${USER} ${WEB_DIR}/${PACKAGE}

    # Save some stuff
    rm -fr ${TMP_DIR}/${PACKAGE}
    mkdir -p ${TMP_DIR}/${PACKAGE}
    mv ${WEB_DIR}/${PACKAGE}/dbsettings.inc.php ${TMP_DIR}/${PACKAGE}
    mv ${WEB_DIR}/${PACKAGE}/ownsettings.php ${TMP_DIR}/${PACKAGE}
    mv ${WEB_DIR}/${PACKAGE}/settings.php ${TMP_DIR}/${PACKAGE}
    mv ${WEB_DIR}/${PACKAGE}/.htaccess ${TMP_DIR}/${PACKAGE}

    exit 0
}

postupgrade ()
{
    # Restore some stuff
    mv ${TMP_DIR}/${PACKAGE}/dbsettings.inc.php ${WEB_DIR}/${PACKAGE}
    mv ${TMP_DIR}/${PACKAGE}/ownsettings.php ${WEB_DIR}/${PACKAGE}
    mv ${TMP_DIR}/${PACKAGE}/settings.php ${WEB_DIR}/${PACKAGE}
    mv ${TMP_DIR}/${PACKAGE}/.htaccess ${WEB_DIR}/${PACKAGE}
    rm -fr ${TMP_DIR}/${PACKAGE}

    exit 0
}
