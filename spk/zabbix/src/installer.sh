#!/bin/sh

# Package
PACKAGE="zabbix"
DNAME="Zabbix"
PACKAGE_NAME="com.synocommunity.packages.${PACKAGE}"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
SSS="/var/packages/${PACKAGE}/scripts/start-stop-status"
PATH="${INSTALL_DIR}/bin:${PATH}"
MYSQL="/usr/syno/mysql/bin/mysql"

# Zabbix Others
CFG_FILE="${INSTALL_DIR}/etc/zabbix_server.conf"
PROXY_CFG_FILE="${INSTALL_DIR}/etc/zabbix_proxy.conf"
MYSQL_PACKAGE_USER="zabbix"
MYSQL_PACKAGE_USER_DATABASE="zabbix"
MYSQL_PACKAGE_USER_DATABASE1="zabbixproxy"
TMP_DIR="${SYNOPKG_PKGDEST}/../../@tmp"
USER="${PACKAGE}server"
USER1="${PACKAGE}proxy"
USER2="${PACKAGE}agent"
GROUP="nobody"
WEBUSER="$([ $(grep buildnumber /etc.defaults/VERSION | cut -d"\"" -f2) -ge 4418 ] && echo -n http || echo -n nobody)"
WEB_DIR="/var/services/web"

preinst ()
{
    # Check MySQL database
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        if [ ! -z "${wizard_mysql_password_root}" ]; then
            if ! ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e quit > /dev/null 2>&1; then
                echo "Incorrect MySQL root password"
                exit 1
            fi
            if ${MYSQL} -u root -p"${wizard_mysql_password_root}" mysql -e "SELECT User FROM user" | grep ^${MYSQL_PACKAGE_USER}$ > /dev/null 2>&1; then
                echo "MySQL user ${MYSQL_PACKAGE_USER} already exists"
                exit 1
            fi
            if ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e "SHOW DATABASES" | grep ^${MYSQL_PACKAGE_USER_DATABASE}$ > /dev/null 2>&1; then
                echo "MySQL database ${MYSQL_PACKAGE_USER_DATABASE} already exists"
                exit 1
            fi
            if ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e "SHOW DATABASES" | grep ^${MYSQL_PACKAGE_USER_DATABASE1}$ > /dev/null 2>&1; then
                echo "MySQL database ${MYSQL_PACKAGE_USER_DATABASE1} already exists"
                exit 1
            fi
        fi
    fi

    exit 0
}

postinst ()
{
    # Link
    ln -s ${SYNOPKG_PKGDEST} ${INSTALL_DIR}

    # Edit the configuration according to the wizard
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
    # Setup Database 1
        ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e "CREATE DATABASE ${MYSQL_PACKAGE_USER_DATABASE}; GRANT ALL PRIVILEGES ON ${MYSQL_PACKAGE_USER_DATABASE}.* TO '${MYSQL_PACKAGE_USER}'@'localhost' IDENTIFIED BY '${wizard_mysql_password_zabbix:=zabbix}';"
        ${MYSQL} -u ${MYSQL_PACKAGE_USER} --password="${wizard_mysql_password_zabbix:=zabbix}" -h localhost ${MYSQL_PACKAGE_USER_DATABASE} < /var/packages/${PACKAGE}/target/share/database/schema.sql
        ${MYSQL} -u ${MYSQL_PACKAGE_USER} --password="${wizard_mysql_password_zabbix:=zabbix}" -h localhost ${MYSQL_PACKAGE_USER_DATABASE} < /var/packages/${PACKAGE}/target/share/database/images.sql
        ${MYSQL} -u ${MYSQL_PACKAGE_USER} --password="${wizard_mysql_password_zabbix:=zabbix}" -h localhost ${MYSQL_PACKAGE_USER_DATABASE} < /var/packages/${PACKAGE}/target/share/database/data.sql
    # Setup Database 2
        ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e "CREATE DATABASE ${MYSQL_PACKAGE_USER_DATABASE1}; GRANT ALL PRIVILEGES ON ${MYSQL_PACKAGE_USER_DATABASE1}.* TO '${MYSQL_PACKAGE_USER}'@'localhost' IDENTIFIED BY '${wizard_mysql_password_zabbix:=zabbix}';"
        ${MYSQL} -u ${MYSQL_PACKAGE_USER} --password="${wizard_mysql_password_zabbix:=zabbix}" -h localhost ${MYSQL_PACKAGE_USER_DATABASE1} < /var/packages/${PACKAGE}/target/share/database/schema.sql

    # Setup Config File's
        sed -i -e "s|@db_password@|${wizard_mysql_password_zabbix:=zabbix}|g" ${CFG_FILE}
        sed -i -e "s|@db_password@|${wizard_mysql_password_zabbix:=zabbix}|g" ${INSTALL_DIR}/share/zabbix/conf/zabbix.conf.php
        sed -i -e "s|@db_password@|${wizard_mysql_password_zabbix:=zabbix}|g" ${PROXY_CFG_FILE}
    fi

    # Install busybox stuff
    ${INSTALL_DIR}/bin/busybox --install ${INSTALL_DIR}/bin

    # Create user
    adduser -h ${INSTALL_DIR}/var -g "${DNAME} User" -G ${GROUP} -s /bin/sh -S -D ${USER}
    adduser -h ${INSTALL_DIR}/var -g "${DNAME} User" -G ${GROUP} -s /bin/sh -S -D ${USER1}
    adduser -h ${INSTALL_DIR}/var -g "${DNAME} User" -G ${GROUP} -s /bin/sh -S -D ${USER2}

    # Correct the files ownership
    chown -R ${USER}:root ${SYNOPKG_PKGDEST}
    

    # Install the web interface and fix php.ini
    cp -pR ${INSTALL_DIR}/share/zabbix ${WEB_DIR}

    if [ "${WEBUSER}" == "nobody" ]; then
        echo -e "php_value max_execution_time 300\nphp_value max_input_time 300\nphp_value date.timezone UTC" > ${WEB_DIR}/${PACKAGE}/.htaccess
    else
        echo -e "[PATH=${WEB_DIR}/${PACKAGE}]\nmax_execution_time = 300\nmax_input_time = 300" > /etc/php/conf.d/${PACKAGE_NAME}.ini
    fi

    echo -e "\nErrorDocument 403 \"Zabbix Server is turned off...\ndeny from all\n" >> ${WEB_DIR}/${PACKAGE}/.htaccess

    # Fix for Zabbix and MariaDB socket error
    # Seems to work without this on DSM4.3
    if [ $(grep buildnumber /etc.defaults/VERSION | cut -d"\"" -f2) -ge 4418 ]; then
        sed -i -e "s|#DBSocket=/tmp/mysql.sock|DBSocket=/run/mysqld/mysqld.sock|g" ${CFG_FILE}
        sed -i -e "s|#DBSocket=/tmp/mysql.sock|DBSocket=/run/mysqld/mysqld.sock|g" ${PROXY_CFG_FILE}
        sed -i '14i\SOCKET          = /run/mysqld/mysqld.sock' ${INSTALL_DIR}/etc/odbc.ini
        sed -i '27i\SOCKET          = /run/mysqld/mysqld.sock' ${INSTALL_DIR}/etc/odbc.ini
    fi

    # Fix permissions
    chown -R ${WEBUSER} ${WEB_DIR}/${PACKAGE}

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

    # Remove the user (if not upgrading)
    if [ "${SYNOPKG_PKG_STATUS}" == "UNINSTALL" ]; then
        delgroup ${USER} ${GROUP}
        delgroup ${USER1} ${GROUP}
        delgroup ${USER2} ${GROUP}
        deluser ${USER}
        deluser ${USER1}
        deluser ${USER2}
    fi

    exit 0
}

postuninst ()
{
    # Remove link
    rm -f ${INSTALL_DIR}

    # Remove php configuration
    rm -f /etc/php/conf.d/${PACKAGE_NAME}.ini

    # Remove database
    if [ "${SYNOPKG_PKG_STATUS}" == "UNINSTALL" -a "${wizard_remove_database}" == "true" ]; then
        ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e "DROP DATABASE ${MYSQL_PACKAGE_USER_DATABASE}; DROP USER '${MYSQL_PACKAGE_USER}'@'localhost';"
        ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e "DROP DATABASE ${MYSQL_PACKAGE_USER_DATABASE1};"
    fi

    # Remove the web interface
    rm -fr ${WEB_DIR}/zabbix

    exit 0
}

preupgrade ()
{
    # Stop the package
    ${SSS} stop > /dev/null

    # Save some stuff
    rm -fr ${TMP_DIR}/${PACKAGE}
    mkdir -p ${TMP_DIR}/${PACKAGE}
    mv ${INSTALL_DIR}/etc ${TMP_DIR}/${PACKAGE}/
    mv ${INSTALL_DIR}/var ${TMP_DIR}/${PACKAGE}/
    mv ${WEB_DIR}/zabbix/conf ${TMP_DIR}/${PACKAGE}/

    exit 0
}

postupgrade ()
{
    # Restore some stuff
    rm -fr ${INSTALL_DIR}/etc
    rm -fr ${WEB_DIR}/zabbix/conf
    mv ${TMP_DIR}/${PACKAGE}/etc ${INSTALL_DIR}/
    mv ${TMP_DIR}/${PACKAGE}/var ${INSTALL_DIR}/
    mv ${TMP_DIR}/${PACKAGE}/conf ${WEB_DIR}/zabbix/

    rm -fr ${TMP_DIR}/${PACKAGE}

    exit 0
}