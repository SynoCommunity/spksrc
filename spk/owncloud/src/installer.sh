#!/bin/sh

# Package
PACKAGE="owncloud"
DNAME="ownCloud"
PACKAGE_NAME="com.synocommunity.packages.${PACKAGE}"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
WEB_DIR="/var/services/web"
USER="$([ $(/bin/get_key_value /etc.defaults/VERSION buildnumber) -ge 4418 ] && echo -n http || echo -n nobody)"
MYSQL="$([ $(/bin/get_key_value /etc.defaults/VERSION buildnumber) -ge 7135 ] && echo -n /bin/mysql || echo -n /usr/syno/mysql/bin/mysql)"
MYSQLDUMP="$([ $(/bin/get_key_value /etc.defaults/VERSION buildnumber) -ge 7135 ] && echo -n /bin/mysqldump || echo -n /usr/syno/mysql/bin/mysqldump)"
MYSQL_USER="owncloud"
MYSQL_DATABASE="owncloud"
TMP_DIR="${SYNOPKG_PKGDEST}/../../@tmp"


preinst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then

        # Check database
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

        # Check directory
        if [ ! -d ${wizard_owncloud_datadirectory:=/volume1/owncloud} ]; then
            echo "Directory does not exist"
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
    cp -pR ${INSTALL_DIR}/share/${PACKAGE} ${WEB_DIR}
    mkdir ${WEB_DIR}/${PACKAGE}/data

    # Configure open_basedir
    if [ "${USER}" == "nobody" ]; then
        echo -e "<Directory \"${WEB_DIR}/${PACKAGE}\">\nphp_admin_value open_basedir none\n</Directory>" > /usr/syno/etc/sites-enabled-user/${PACKAGE}.conf
    else
        echo -e "extension = fileinfo.so\n[PATH=${WEB_DIR}/${PACKAGE}]\nopen_basedir = Null" > /etc/php/conf.d/${PACKAGE_NAME}.ini
        echo -e "<Directory \"${WEB_DIR}/${PACKAGE}\">\nXSendFilePath /\n</Directory>" > /etc/httpd/sites-enabled-user/${PACKAGE_NAME}.conf
    fi

    # Setup database and autoconfig file
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e "CREATE DATABASE ${MYSQL_DATABASE}; GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'localhost' IDENTIFIED BY '${wizard_mysql_password_owncloud:=owncloud}';"
        sed -i -e "s/@admin_username@/${wizard_owncloud_admin_username:=admin}/g" \
               -e "s/@admin_password@/${wizard_owncloud_admin_password:=admin}/g" \
               -e "s/@db_password@/${wizard_mysql_password_owncloud:=owncloud}/g" \
               -e "s#@directory@#${wizard_owncloud_datadirectory:=/volume1/owncloud}#g" \
               ${WEB_DIR}/${PACKAGE}/config/autoconfig.php
        chown -R ${USER} ${wizard_owncloud_datadirectory}
    fi

    # Fix permissions
    chown -R ${USER} ${WEB_DIR}/${PACKAGE}

    exit 0
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

    exit 0
}

postuninst ()
{
    # Remove link
    rm -f ${INSTALL_DIR}

    # Remove open_basedir configuration
    rm -f /usr/syno/etc/sites-enabled-user/${PACKAGE}.conf
    rm -f /etc/php/conf.d/${PACKAGE_NAME}.ini
    rm -f /etc/httpd/sites-enabled-user/${PACKAGE_NAME}.conf

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

    exit 0
}

preupgrade ()
{
    # Stop the package
    ${SSS} stop > /dev/null

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
