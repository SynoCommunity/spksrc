#!/bin/sh

# Package
PACKAGE="owncloud"
DNAME="ownCloud"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
WEB_DIR="/var/services/web"
USER="nobody"
MYSQL="/usr/syno/mysql/bin/mysql"
MYSQL_USER="owncloud"
MYSQL_DATABASE="owncloud"
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

    # Install the web interface
    cp -R ${INSTALL_DIR}/share/${PACKAGE} ${WEB_DIR}
    mkdir ${WEB_DIR}/${PACKAGE}/data

    # Prepare data directory
    DATA_DIR=
    if [ -z "${wizard_owncloud_datadirectory}" ]; then
        DATA_DIR="OC::\$SERVERROOT.\"/data\""
    else
        mkdir ${wizard_owncloud_datadirectory}
        chown ${USER} ${wizard_owncloud_datadirectory}
        DATA_DIR="\"${wizard_owncloud_datadirectory}\""
        echo -e "<Directory \"${WEB_DIR}/${PACKAGE}\">\nphp_admin_value open_basedir none\n</Directory>" > /usr/syno/etc/sites-enabled-user/${PACKAGE}.conf
    fi

    # Setup database and autoconfig file
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e "CREATE DATABASE ${MYSQL_DATABASE}; GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'localhost' IDENTIFIED BY '${wizard_mysql_password_owncloud:=owncloud}';"
        sed -i -e "s/@admin_username@/${wizard_owncloud_admin_username:=admin}/g" ${WEB_DIR}/${PACKAGE}/config/autoconfig.php
        sed -i -e "s/@admin_password@/${wizard_owncloud_admin_password:=admin}/g" ${WEB_DIR}/${PACKAGE}/config/autoconfig.php
        sed -i -e "s/@db_password@/${wizard_mysql_password_owncloud:=owncloud}/g" ${WEB_DIR}/${PACKAGE}/config/autoconfig.php
        sed -i -e "s#@directory@#${DATA_DIR}#g" ${WEB_DIR}/${PACKAGE}/config/autoconfig.php
    fi

    # Fix permissions
    chown ${USER} ${WEB_DIR}/${PACKAGE}/data
    chown -R ${USER} ${WEB_DIR}/${PACKAGE}/apps
    chown -R ${USER} ${WEB_DIR}/${PACKAGE}/config

    exit 0
}

preuninst ()
{
    # Check database
    if [ "${SYNOPKG_PKG_STATUS}" == "UNINSTALL" -a "${wizard_remove_database}" == "true" ] && ! ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e quit > /dev/null 2>&1; then
        echo "Incorrect MySQL root password"
        exit 1
    fi

    exit 0
}

postuninst ()
{
    # Remove open_basedir configuration
    if [ -f /usr/syno/etc/sites-enabled-user/${PACKAGE}.conf ]; then
        rm /usr/syno/etc/sites-enabled-user/${PACKAGE}.conf
    fi

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
    # Save the configuration file and data
    rm -fr ${TMP_DIR}/${PACKAGE}
    mkdir -p ${TMP_DIR}/${PACKAGE}
    mv ${WEB_DIR}/${PACKAGE}/config/config.php ${TMP_DIR}/${PACKAGE}/

    exit 0
}

postupgrade ()
{
    # Restore the configuration file and data
    mv ${TMP_DIR}/${PACKAGE}/config.php ${WEB_DIR}/${PACKAGE}/config/
    rm -fr ${TMP_DIR}/${PACKAGE}

    exit 0
}
