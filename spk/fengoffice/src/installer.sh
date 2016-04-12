#!/bin/sh

# Package
PACKAGE="fengoffice"
DNAME="Feng Office"
VERSION="2.5.1.2"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
SSS="/var/packages/${PACKAGE}/scripts/start-stop-status"
WEB_DIR="/var/services/web"
USER="$([ $(/bin/get_key_value /etc.defaults/VERSION buildnumber) -ge 4418 ] && echo -n http || echo -n nobody)"
MYSQL="$([ $(/bin/get_key_value /etc.defaults/VERSION buildnumber) -ge 7135 ] && echo -n /bin/mysql || echo -n /usr/syno/mysql/bin/mysql)"
MYSQLDUMP="$([ $(/bin/get_key_value /etc.defaults/VERSION buildnumber) -ge 7135 ] && echo -n /bin/mysqldump || echo -n /usr/syno/mysql/bin/mysqldump)"ump"
MYSQL_USER="fengoffice"
MYSQL_DATABASE="fengoffice"
TMP_DIR="${SYNOPKG_PKGDEST}/../../@tmp"


preinst ()
{
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
    cp -pR ${INSTALL_DIR}/share/${PACKAGE} ${WEB_DIR}

    # Setup database and run installer
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e "CREATE DATABASE ${MYSQL_DATABASE}; GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'localhost' IDENTIFIED BY '${wizard_mysql_password_fengoffice:=fengoffice}';"
        cd ${WEB_DIR}/${PACKAGE}/public/install/ && QUERY_STRING="script_installer_storage[database_type]=mysql&script_installer_storage[database_host]=localhost&script_installer_storage[database_user]=${MYSQL_USER}&script_installer_storage[database_pass]=${wizard_mysql_password_fengoffice:=fengoffice}&script_installer_storage[database_name]=${MYSQL_DATABASE}&script_installer_storage[database_prefix]=fo_&script_installer_storage[database_engine]=InnoDB&script_installer_storage[absolute_url]=http://${wizard_domain_name:=`hostname`}/${PACKAGE}&script_installer_storage[plugins][]=core_dimensions&script_installer_storage[plugins][]=workspaces&script_installer_storage[plugins][]=mail&submited=submited" php install_helper.php > /dev/null
    fi

    # Fix permissions
    chown -R ${USER} ${WEB_DIR}/${PACKAGE}/config
    chown -R ${USER} ${WEB_DIR}/${PACKAGE}/cache
    chown -R ${USER} ${WEB_DIR}/${PACKAGE}/upload
    chown -R ${USER} ${WEB_DIR}/${PACKAGE}/tmp

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

    # Save configuration and files
    rm -fr ${TMP_DIR}/${PACKAGE}
    mkdir -p ${TMP_DIR}/${PACKAGE}
    mv ${WEB_DIR}/${PACKAGE}/config/config.php ${TMP_DIR}/${PACKAGE}/
    mv ${WEB_DIR}/${PACKAGE}/config/installed_version.php ${TMP_DIR}/${PACKAGE}/
    mkdir ${TMP_DIR}/${PACKAGE}/upload/
    cp -r ${WEB_DIR}/${PACKAGE}/upload/*/ ${TMP_DIR}/${PACKAGE}/upload/

    exit 0
}

postupgrade ()
{
    # Detect old version
    INSTALLED_VERSION=`sed -n "s|return '\(.*\)';|\1|p" ${TMP_DIR}/${PACKAGE}/installed_version.php | xargs`

    # Restore configuration
    mv ${TMP_DIR}/${PACKAGE}/config.php ${WEB_DIR}/${PACKAGE}/config/
    cp -r ${TMP_DIR}/${PACKAGE}/upload/*/ ${WEB_DIR}/${PACKAGE}/upload/
    rm -fr ${TMP_DIR}/${PACKAGE}

    # Fix permissions
    chown -R ${USER} ${WEB_DIR}/${PACKAGE}/upload

    # Run update scripts
    php ${WEB_DIR}/${PACKAGE}/public/upgrade/console.php ${INSTALLED_VERSION} ${VERSION} > /dev/null
    php ${WEB_DIR}/${PACKAGE}/public/install/plugin-console.php update_all > /dev/null

    exit 0
}
