
# Package
PACKAGE_NAME="com.synocommunity.packages.${SYNOPKG_PKGNAME}"

# Others
WEB_DIR="/var/services/web_packages"
if [ $SYNOPKG_DSM_VERSION_MAJOR -lt 7 ];then
    WEB_DIR="/var/services/web"
fi
TMP_DIR="${SYNOPKG_PKGVAR}/tmp"
# for backwards compatability
if [ $SYNOPKG_DSM_VERSION_MAJOR -lt 7 ];then
    TMP_DIR="${SYNOPKG_PKGDEST}/../../@tmp"
fi
BUILDNUMBER="$(/bin/get_key_value /etc.defaults/VERSION buildnumber)"

HTTP_USER="$([ $(/bin/get_key_value /etc.defaults/VERSION buildnumber) -ge 4418 ] && echo -n http || echo -n nobody)"
MARIADB_10_INSTALL_DIRECTORY="/var/packages/MariaDB10"
MARIADB_10_BIN_DIRECTORY="${MARIADB_10_INSTALL_DIRECTORY}/target/usr/local/mariadb10/bin"
MARIADB_10_SERVER_PORT="$(grep -A1 '\[mysqld\]' /var/packages/MariaDB10/etc/my_port.cnf | tail -n1 | awk -F= '{print $2}')"
MYSQL="${MARIADB_10_BIN_DIRECTORY}/mysql"
MYSQLDUMP="${MARIADB_10_BIN_DIRECTORY}/mysqldump"
MYSQL_USER="${SYNOPKG_PKGNAME}"
MYSQL_DATABASE="${SYNOPKG_PKGNAME}"


service_preinst ()
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

        if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -lt 7 ]; then

            # Check directory
            if [ ! -d ${wizard_owncloud_datadirectory:=/volume1/owncloud} ]; then
                echo "Directory does not exist"
                exit 1
            fi

        fi

    fi

    return 0
}

service_postinst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then

        if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -lt 7 ]; then
            # Install the web interface
            ${CP} ${SYNOPKG_PKGDEST}/share/${SYNOPKG_PKGNAME} ${WEB_DIR}

            # Configure open_basedir
            if [ "${HTTP_USER}" == "nobody" ]; then
                echo -e "<Directory \"${WEB_DIR}/${SYNOPKG_PKGNAME}\">\nphp_admin_value open_basedir none\n</Directory>" > /usr/syno/etc/sites-enabled-user/${SYNOPKG_PKGNAME}.conf
            else
                echo -e "extension = fileinfo.so\n[PATH=${WEB_DIR}/${SYNOPKG_PKGNAME}]\nopen_basedir = Null" > /etc/php/conf.d/${PACKAGE_NAME}.ini
                echo -e "<Directory \"${WEB_DIR}/${SYNOPKG_PKGNAME}\">\nXSendFilePath /\n</Directory>" > /etc/httpd/sites-enabled-user/${PACKAGE_NAME}.conf
            fi
        fi

        # Create data directory
        ${MKDIR} "${wizard_owncloud_datadirectory}"

        # Setup configuration file
        {
            echo '<?php';
            echo '$AUTOCONFIG = array(';
            echo '  "dbtype"        => "mysql",';
            echo '  "dbname"        => "'${MYSQL_DATABASE}'",';
            echo '  "dbuser"        => "'${MYSQL_USER}'",';
            echo '  "dbpass"        => "'${wizard_mysql_password_owncloud}'",';
            echo '  "dbhost"        => "localhost:'${MARIADB_10_SERVER_PORT}'",';
            echo '  "dbtableprefix" => "",';
            echo '  "adminlogin"    => "'${wizard_owncloud_admin_username}'",';
            echo '  "adminpass"     => "'${wizard_owncloud_admin_password}'",';
            echo '  "directory"     => "'${wizard_owncloud_datadirectory}'",';
            echo ');';
        } >>"${WEB_DIR}/${SYNOPKG_PKGNAME}/config/autoconfig.php"

        if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -lt 7 ]; then
            # Fix permissions
            chown -R ${HTTP_USER} ${WEB_DIR}/${SYNOPKG_PKGNAME}
        fi

    fi

    return 0
}

service_preuninst ()
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

service_postuninst ()
{
    if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -lt 7 ]; then
        # Remove open_basedir configuration
        ${RM} /usr/syno/etc/sites-enabled-user/${SYNOPKG_PKGNAME}.conf
        ${RM} /etc/php/conf.d/${PACKAGE_NAME}.ini
        ${RM} /etc/httpd/sites-enabled-user/${PACKAGE_NAME}.conf
    fi

    # Export and remove database
    if [ "${SYNOPKG_PKG_STATUS}" == "UNINSTALL" ]; then
        if [ -n "${wizard_dbexport_path}" ]; then
            mkdir -p ${wizard_dbexport_path}
            ${MYSQLDUMP} -u root -p"${wizard_mysql_password_root}" ${MYSQL_DATABASE} > ${wizard_dbexport_path}/${MYSQL_DATABASE}.sql
        fi
        ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e "DROP DATABASE ${MYSQL_DATABASE}; DROP USER '${MYSQL_USER}'@'localhost';"
    fi

    if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -lt 7 ]; then
        # Remove the web interface
        ${RM} ${WEB_DIR}/${SYNOPKG_PKGNAME}
    fi

    return 0
}

service_preupgrade ()
{
    # Stop the package
    ${SSS} stop > /dev/null

    # Save the configuration file and data
    rm -fr ${TMP_DIR}/${SYNOPKG_PKGNAME}
    mkdir -p ${TMP_DIR}/${SYNOPKG_PKGNAME}
    mv ${WEB_DIR}/${SYNOPKG_PKGNAME}/config/config.php ${TMP_DIR}/${SYNOPKG_PKGNAME}/

    return 0
}

service_postupgrade ()
{
    # Restore the configuration file and data
    mv ${TMP_DIR}/${SYNOPKG_PKGNAME}/config.php ${WEB_DIR}/${SYNOPKG_PKGNAME}/config/
    rm -fr ${TMP_DIR}/${SYNOPKG_PKGNAME}

    return 0
}
