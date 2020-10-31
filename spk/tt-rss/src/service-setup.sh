#!/bin/sh

# Package
PACKAGE="tt-rss"
DNAME="Tiny Tiny RSS"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
WEB_DIR="/var/services/web"
BUILDNUMBER="$(/bin/get_key_value /etc.defaults/VERSION buildnumber)"

USER="http"
EFF_USER="http"
PHP="${INSTALL_DIR}/bin/virtual-php"
MYSQL=/bin/mysql
MYSQLDUMP=/bin/mysqldump
MYSQL_USER="ttrss"
MYSQL_DATABASE="ttrss"
MYSQL_USER_EXISTS=0
MYSQL_DATABASE_EXISTS=0



service_preinst ()
{
    # Check database
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        if ! ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e quit > /dev/null 2>&1; then
            echo "Incorrect MySQL root password"
            exit 1
        fi
        if ${MYSQL} -u root -p"${wizard_mysql_password_root}" mysql -e "SELECT User FROM user" | grep ^${MYSQL_USER}$ > /dev/null 2>&1; then
            echo "MySQL user ${MYSQL_USER} already exists and will be re-used"
            MYSQL_USER_EXISTS=1
            #exit 1
        fi
        if ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e "SHOW DATABASES" | grep ^${MYSQL_DATABASE}$ > /dev/null 2>&1; then
            echo "MySQL database ${MYSQL_DATABASE} already exists and will be re-used"
            MYSQL_DATABASE_EXISTS=1
            #exit 1
        fi
    fi

    exit 0
}

service_postinst ()
{

    # Install busybox stuff
    ${INSTALL_DIR}/bin/busybox --install ${INSTALL_DIR}/bin >> "$INST_LOG" 2>&1

    # Install the web interface
    cp -pR ${INSTALL_DIR}/share/${PACKAGE} ${WEB_DIR} >> "$INST_LOG" 2>&1

    # Setup database and configuration file
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        [ ${MYSQL_DATABASE_EXISTS} ] || ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e "CREATE DATABASE ${MYSQL_DATABASE}; GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'localhost' IDENTIFIED BY '${wizard_mysql_password_ttrss}';" >> "$INST_LOG" 2>&1
        [ ${MYSQL_USER_EXISTS} ] || ${MYSQL} -u ${MYSQL_USER} -p"${wizard_mysql_password_ttrss}" ${MYSQL_DATABASE} < ${WEB_DIR}/${PACKAGE}/schema/ttrss_schema_mysql.sql  >> "$INST_LOG" 2>&1
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
            ${WEB_DIR}/${PACKAGE}/config.php-dist > ${WEB_DIR}/${PACKAGE}/config.php 2> "$INST_LOG"
    fi

    # Fix permissions
    set_syno_permissions "${INSTALL_DIR}/var/logs" "${USER}"

    set_unix_permissions "${WEB_DIR}/${PACKAGE}/lock"
    chmod -R ug+rwx "${WEB_DIR}/${PACKAGE}/lock" >> "$INST_LOG" 2>&1

    set_unix_permissions "${WEB_DIR}/${PACKAGE}/feed-icons"
    chmod -R ug+rwx "${WEB_DIR}/${PACKAGE}/feed-icons" >> "$INST_LOG" 2>&1

    set_unix_permissions "${WEB_DIR}/${PACKAGE}/cache"
    chmod -R ug+rwx "${WEB_DIR}/${PACKAGE}/cache" >> "$INST_LOG" 2>&1

    exit 0
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

    exit 0
}

service_postuninst ()
{

    # Export and remove database
    if [ "${SYNOPKG_PKG_STATUS}" == "UNINSTALL" ]; then
        if [ -n "${wizard_dbexport_path}" ]; then
            mkdir -p ${wizard_dbexport_path} >> "$INST_LOG" 2>&1
            ${MYSQLDUMP} -u root -p"${wizard_mysql_password_root}" ${MYSQL_DATABASE} > ${wizard_dbexport_path}/${MYSQL_DATABASE}.sql 2> "$INST_LOG"
        fi
        ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e "DROP DATABASE ${MYSQL_DATABASE}; DROP USER '${MYSQL_USER}'@'localhost';"  >> "$INST_LOG" 2>&1
    fi

    # Remove the web interface
    rm -fr "${WEB_DIR}/${PACKAGE}" >> "$INST_LOG" 2>&1

    exit 0
}

service_save ()
{
    # Save the configuration file
    mkdir -p "${TMP_DIR}/${PACKAGE}" >> "$INST_LOG" 2>&1

    mv ${WEB_DIR}/${PACKAGE}/config.php ${TMP_DIR}/${PACKAGE}/ >> "$INST_LOG" 2>&1

    mkdir ${TMP_DIR}/${PACKAGE}/feed-icons/ >> "$INST_LOG" 2>&1
    mv ${WEB_DIR}/${PACKAGE}/feed-icons/*.ico ${TMP_DIR}/${PACKAGE}/feed-icons/ >> "$INST_LOG" 2>&1

    mv ${WEB_DIR}/${PACKAGE}/plugins.local ${TMP_DIR}/${PACKAGE}/ >> "$INST_LOG" 2>&1
    mv ${WEB_DIR}/${PACKAGE}/themes.local ${TMP_DIR}/${PACKAGE}/ >> "$INST_LOG" 2>&1

    exit 0
}

service_restore ()
{
    # Restore the configuration file
    mv ${TMP_DIR}/${PACKAGE}/config.php ${WEB_DIR}/${PACKAGE}/config-bak.php >> "$INST_LOG" 2>&1
    cp ${WEB_DIR}/${PACKAGE}/config.php-dist ${WEB_DIR}/${PACKAGE}/config.php >> "$INST_LOG" 2>&1

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
            ${WEB_DIR}/${PACKAGE}/config.php >> "$INST_LOG" 2>&1
    done < ${WEB_DIR}/${PACKAGE}/config-bak.php

    set_unix_permissions ${WEB_DIR}/${PACKAGE}/config.php

    mv -f ${TMP_DIR}/${PACKAGE}/feed-icons/*.ico ${WEB_DIR}/${PACKAGE}/feed-icons/ >> "$INST_LOG" 2>&1
    set_unix_permissions ${WEB_DIR}/${PACKAGE}/feed-icons/

    mv -f ${TMP_DIR}/${PACKAGE}/plugins.local/* ${WEB_DIR}/${PACKAGE}/plugins.local/ >> "$INST_LOG" 2>&1
    set_unix_permissions ${WEB_DIR}/${PACKAGE}/plugins.local/

    mv -f ${TMP_DIR}/${PACKAGE}/themes.local/* ${WEB_DIR}/${PACKAGE}/themes.local/ >> "$INST_LOG" 2>&1
    set_unix_permissions ${WEB_DIR}/${PACKAGE}/themes.local/

    exit 0
}
