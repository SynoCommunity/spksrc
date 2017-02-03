#!/bin/sh

# Package
PACKAGE="mantisbt"
DNAME="MantisBT"
PACKAGE_NAME="com.synocommunity.packages.${PACKAGE}"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
WEB_DIR="/var/services/web"
TMP_DIR="${SYNOPKG_PKGDEST}/../../@tmp"
BUILDNUMBER="$(/bin/get_key_value /etc.defaults/VERSION buildnumber)"

USER="$([ "${BUILDNUMBER}" -ge "4418" ] && echo -n http || echo -n nobody)"
PHP="$([ "${BUILDNUMBER}" -ge "7321" ] && echo -n /usr/local/bin/php56 || echo -n /usr/bin/php)"
MYSQL="$([ "${BUILDNUMBER}" -ge "7321" ] && echo -n /bin/mysql || echo -n /usr/syno/mysql/bin/mysql)"
MYSQLDUMP="$([ "${BUILDNUMBER}" -ge "7321" ] && echo -n /bin/mysqldump || echo -n /usr/syno/mysql/bin/mysqldump)"
MYSQL_USER="mantisbt"
MYSQL_DATABASE="mantisbt"


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
    cp -pR ${INSTALL_DIR}/share/${PACKAGE} ${WEB_DIR}

    # Configure open_basedir
    if [ "${USER}" == "nobody" ]; then
        echo -e "<Directory \"${WEB_DIR}/${PACKAGE}\">\nphp_admin_value open_basedir none\n</Directory>" > /usr/syno/etc/sites-enabled-user/${PACKAGE}.conf
    else
        echo -e "extension = fileinfo.so\n[PATH=${WEB_DIR}/${PACKAGE}]\nopen_basedir = Null" > /etc/php/conf.d/${PACKAGE_NAME}.ini
    fi

    # Setup database and configuration file
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e "CREATE DATABASE ${MYSQL_DATABASE}; GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'localhost' IDENTIFIED BY '${wizard_mysql_password_mantisbt:=mantisbt}';"
        sed -i -e "s/@password@/${wizard_mysql_password_mantisbt:=mantisbt}/g" ${WEB_DIR}/${PACKAGE}/config_inc.php
    fi

    # Install/upgrade database
    sed -i -e "s/gpc_get_int( 'install', 0 );/gpc_get_int( 'install', 2 );/g" ${WEB_DIR}/${PACKAGE}/admin/install.php
    ${PHP} ${WEB_DIR}/${PACKAGE}/admin/install.php > /dev/null

    # Remove admin directory
    rm -fr ${WEB_DIR}/${PACKAGE}/admin/

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

    exit 0
}

postuninst ()
{
    # Remove link
    rm -f ${INSTALL_DIR}

    # Export and remove database
    if [ "${SYNOPKG_PKG_STATUS}" == "UNINSTALL" ]; then
        if [ -n "${wizard_dbexport_path}" ]; then
            mkdir -p ${wizard_dbexport_path}
            ${MYSQLDUMP} -u root -p"${wizard_mysql_password_root}" ${MYSQL_DATABASE} > ${wizard_dbexport_path}/${MYSQL_DATABASE}.sql
        fi
        ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e "DROP DATABASE ${MYSQL_DATABASE}; DROP USER '${MYSQL_USER}'@'localhost';"
    fi

    # Remove open_basedir configuration
    rm -f /usr/syno/etc/sites-enabled-user/${PACKAGE}.conf
    rm -f /etc/php/conf.d/${PACKAGE_NAME}.ini

    # Remove the web interface
    rm -fr ${WEB_DIR}/${PACKAGE}

    exit 0
}

preupgrade ()
{
    # Backup files
    rm -fr ${TMP_DIR}/${PACKAGE}
    mkdir -p ${TMP_DIR}/${PACKAGE}

    # Save the configuration file
    mv ${WEB_DIR}/${PACKAGE}/config_inc.php ${TMP_DIR}/${PACKAGE}/

    # Save custom files
    for file in ${WEB_DIR}/${PACKAGE}/custom*
    do
        mv $file ${TMP_DIR}/${PACKAGE}/
    done

    exit 0
}

postupgrade ()
{
    # Restore the configuration file
    mv ${TMP_DIR}/${PACKAGE}/config_inc.php ${WEB_DIR}/${PACKAGE}/

    # Restore custom files
    for file in ${TMP_DIR}/${PACKAGE}/custom*
    do
        mv $file ${WEB_DIR}/${PACKAGE}/
    done

    rm -fr ${TMP_DIR}/${PACKAGE}

    exit 0
}
