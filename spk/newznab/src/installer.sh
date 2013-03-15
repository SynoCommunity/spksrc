#!/bin/sh

# Package
PACKAGE="newznab"
DNAME="Newznab"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
WEB_DIR="/var/services/web"
MYSQL="/usr/syno/mysql/bin/mysql"
TMP_DIR="${SYNOPKG_PKGDEST}/../../@tmp"


preinst ()
{
    # Check database
    if [ "${SYNOPKG_PKG_STATUS}" != "UPGRADE" ]; then
        if ! ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e quit > /dev/null 2>&1; then
            echo "Incorrect MySQL root password"
            exit 1
        fi
        if ${MYSQL} -u root -p"${wizard_mysql_password_root}" mysql -e "SELECT User FROM user" | grep ^newznab$ > /dev/null 2>&1; then
            echo "MySQL user newznab already exists"
            exit 1
        fi
        if ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e "SHOW DATABASES" | grep ^newznab$ > /dev/null 2>&1; then
            echo "MySQL database newznab already exists"
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
    cp -R ${INSTALL_DIR}/share/newznab ${WEB_DIR}

    # Setup database
    if [ "${SYNOPKG_PKG_STATUS}" != "UPGRADE" ]; then
        ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e "CREATE DATABASE newznab;"
        ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e "GRANT ALL PRIVILEGES ON newznab.* TO 'newznab'@'localhost' IDENTIFIED BY '${wizard_mysql_password_newznab}';"
    fi

    # Fix permissions
    chmod 777 ${WEB_DIR}/newznab/www/lib/smarty/templates_c
    chmod 777 ${WEB_DIR}/newznab/www/covers/movies
    chmod 777 ${WEB_DIR}/newznab/www/covers/music
    chmod 777 ${WEB_DIR}/newznab/www
    chmod 777 ${WEB_DIR}/newznab/www/install
    chmod 777 ${WEB_DIR}/newznab/nzbfiles

    exit 0
}

preuninst ()
{
    exit 0
}

postuninst ()
{
    # Remove link
    rm -f ${INSTALL_DIR}

    # Remove database
    if [ "${SYNOPKG_PKG_STATUS}" != "UPGRADE" -a "${wizard_remove_database}" == "true" ]; then
        ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e "DROP DATABASE newznab;"
    fi

    # Remove the web interface
    rm -fr ${WEB_DIR}/newznab

    exit 0
}

preupgrade ()
{
    # Save some stuff
    rm -fr ${TMP_DIR}/${PACKAGE}
    mkdir -p ${TMP_DIR}/${PACKAGE}
    mv ${WEB_DIR}/newznab/www/config.php ${TMP_DIR}/${PACKAGE}/
    mv ${WEB_DIR}/newznab/www/covers/movies ${TMP_DIR}/${PACKAGE}/
    mv ${WEB_DIR}/newznab/www/covers/music ${TMP_DIR}/${PACKAGE}/
    mv ${WEB_DIR}/newznab/nzbfiles ${TMP_DIR}/${PACKAGE}/

    exit 0
}

postupgrade ()
{
    # Restore some stuff
    mv ${TMP_DIR}/${PACKAGE}/config.php ${WEB_DIR}/newznab/www/
    mv ${TMP_DIR}/${PACKAGE}/movies ${WEB_DIR}/newznab/www/covers/
    mv ${TMP_DIR}/${PACKAGE}/music ${WEB_DIR}/newznab/www/covers/
    mv ${TMP_DIR}/${PACKAGE}/nzbfiles ${WEB_DIR}/newznab/
    rm -fr ${TMP_DIR}/${PACKAGE}

    exit 0
}
