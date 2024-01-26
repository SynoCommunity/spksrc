
# Package
SVC_KEEP_LOG=y
SVC_BACKGROUND=y
SVC_WRITE_PID=y

# Others
MYSQL="/usr/local/mariadb10/bin/mysql"
MYSQLDUMP="/usr/local/mariadb10/bin/mysqldump"
MYSQL_USER="fengoffice"
MYSQL_DATABASE="fengoffice"
PHP="/usr/local/bin/php74"
if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -ge 7 ]; then
    WEB_DIR="/var/services/web_packages"
else
    WEB_DIR="/var/services/web"
    # DSM 6 file and process ownership
    WEB_USER="http"
    WEB_GROUP="http"
fi

service_prestart ()
{
    FENGOFFICE="${WEB_DIR}/${SYNOPKG_PKGNAME}/cron.php"
    COMMAND="${PHP} ${FENGOFFICE}"
    SLEEP_TIME="600"
    # Main loop
    while true; do
        # Update
        echo "Updating..."
        if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 7 ]; then
            /bin/su "$WEB_USER" -s /bin/sh -c "${COMMAND}" >> ${LOG_FILE} 2>&1
        else
            $COMMAND >> ${LOG_FILE} 2>&1
        fi
        # Wait
        echo "Waiting ${SLEEP_TIME} seconds..."
        sleep ${SLEEP_TIME}
    done &
    echo "$!" > "${PID_FILE}"
}

validate_preinst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" = "INSTALL" ]; then
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
}

service_postinst ()
{
    # Install the web interface
    if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 7 ]; then
        cp -pR ${SYNOPKG_PKGDEST}/share/${SYNOPKG_PKGNAME} ${WEB_DIR}
    fi

    # Setup database and run installer
    if [ "${SYNOPKG_PKG_STATUS}" = "INSTALL" ]; then
        ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e "CREATE DATABASE ${MYSQL_DATABASE}; GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'localhost' IDENTIFIED BY '${wizard_mysql_password_fengoffice:=fengoffice}';"
        cd ${WEB_DIR}/${SYNOPKG_PKGNAME}/public/install/ && QUERY_STRING="script_installer_storage[database_type]=mysql&script_installer_storage[database_host]=localhost&script_installer_storage[database_user]=${MYSQL_USER}&script_installer_storage[database_pass]=${wizard_mysql_password_fengoffice:=fengoffice}&script_installer_storage[database_name]=${MYSQL_DATABASE}&script_installer_storage[database_prefix]=fo_&script_installer_storage[database_engine]=InnoDB&script_installer_storage[absolute_url]=http://${wizard_domain_name:=$(hostname)}/${SYNOPKG_PKGNAME}&script_installer_storage[plugins][]=core_dimensions&script_installer_storage[plugins][]=workspaces&script_installer_storage[plugins][]=mail&submited=submited" php install_helper.php > /dev/null
    fi

    # Fix permissions
    if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 7 ]; then
        chown -R ${WEB_USER}:${WEB_GROUP} ${WEB_DIR}/${SYNOPKG_PKGNAME}/config
        chown -R ${WEB_USER}:${WEB_GROUP} ${WEB_DIR}/${SYNOPKG_PKGNAME}/cache
        chown -R ${WEB_USER}:${WEB_GROUP} ${WEB_DIR}/${SYNOPKG_PKGNAME}/upload
        chown -R ${WEB_USER}:${WEB_GROUP} ${WEB_DIR}/${SYNOPKG_PKGNAME}/tmp
    fi
}

service_preuninst ()
{
    # Check database
    if [ "${SYNOPKG_PKG_STATUS}" = "UNINSTALL" ] && ! ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e quit > /dev/null 2>&1; then
        echo "Incorrect MySQL root password"
        exit 1
    fi

    # Check database export location
    if [ "${SYNOPKG_PKG_STATUS}" = "UNINSTALL" ] && [ -n "${wizard_dbexport_path}" ]; then
        if [ -f "${wizard_dbexport_path}" ] || [ -e "${wizard_dbexport_path}/${MYSQL_DATABASE}.sql" ]; then
            echo "File ${wizard_dbexport_path}/${MYSQL_DATABASE}.sql already exists. Please remove or choose a different location"
            exit 1
        fi
    fi
}

service_postuninst ()
{
    # Export and remove database
    if [ "${SYNOPKG_PKG_STATUS}" = "UNINSTALL" ]; then
        if [ -n "${wizard_dbexport_path}" ]; then
            mkdir -p ${wizard_dbexport_path}
            ${MYSQLDUMP} -u root -p"${wizard_mysql_password_root}" ${MYSQL_DATABASE} > ${wizard_dbexport_path}/${MYSQL_DATABASE}.sql
        fi
        ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e "DROP DATABASE ${MYSQL_DATABASE}; DROP USER '${MYSQL_USER}'@'localhost';"
    fi

    # Remove the web interface
    if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 7 ]; then
        rm -fr ${WEB_DIR}/${SYNOPKG_PKGNAME}
    fi
}

service_save ()
{
    # Save configuration and files
    rm -fr ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}
    mkdir -p ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}
    mv ${WEB_DIR}/${SYNOPKG_PKGNAME}/config/config.php ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/
    mv ${WEB_DIR}/${SYNOPKG_PKGNAME}/config/installed_version.php ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/
    mkdir ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/upload/
    cp -r ${WEB_DIR}/${SYNOPKG_PKGNAME}/upload/*/ ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/upload/
}

service_restore ()
{
    # Detect package version
    PACKAGE_VERSION=$(echo ${SYNOPKG_PKGVER} | cut -d '-' -f 1)
    # Detect old version
    INSTALLED_VERSION=$(sed -n "s|return '\(.*\)';|\1|p" ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/installed_version.php | xargs)

    # Restore configuration
    mv ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/config.php ${WEB_DIR}/${SYNOPKG_PKGNAME}/config/
    cp -r ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}/upload/*/ ${WEB_DIR}/${SYNOPKG_PKGNAME}/upload/
    rm -fr ${SYNOPKG_TEMP_UPGRADE_FOLDER}/${SYNOPKG_PKGNAME}

    # Fix permissions
    if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 7 ]; then
        chown -R ${WEB_USER}:${WEB_GROUP} ${WEB_DIR}/${SYNOPKG_PKGNAME}/upload
    fi

    # Run update scripts
    if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 7 ]; then
        /bin/su "$WEB_USER" -s /bin/sh -c "${PHP} ${WEB_DIR}/${SYNOPKG_PKGNAME}/public/upgrade/console.php ${INSTALLED_VERSION} ${PACKAGE_VERSION}" >> ${LOG_FILE} 2>&1
        /bin/su "$WEB_USER" -s /bin/sh -c "${PHP} ${WEB_DIR}/${SYNOPKG_PKGNAME}/public/install/plugin-console.php update_all" >> ${LOG_FILE} 2>&1
    else
        ${PHP} ${WEB_DIR}/${SYNOPKG_PKGNAME}/public/upgrade/console.php ${INSTALLED_VERSION} ${PACKAGE_VERSION} >> ${LOG_FILE} 2>&1
        ${PHP} ${WEB_DIR}/${SYNOPKG_PKGNAME}/public/install/plugin-console.php update_all >> ${LOG_FILE} 2>&1
    fi
}
