#!/bin/sh

# Package
PACKAGE="zabbixserver"
DNAME="Zabbix Server"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
SSS="/var/packages/${PACKAGE}/scripts/start-stop-status"
PATH="${INSTALL_DIR}/bin:/usr/local/bin:/bin:/usr/bin:/usr/syno/bin"
USER="root"
CFG_FILE="${INSTALL_DIR}/etc/zabbix_server.conf"
MYSQL="/usr/syno/mysql/bin/mysql"
MYSQL_USER="zabbix"
MYSQL_DATABASE="zabbix"
TMP_DIR="${SYNOPKG_PKGDEST}/../../@tmp"
WEB_DIR="/var/services/web"

preinst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then

        # Check database
        if ! ${MYSQL} -u ${USER} -p"${wizard_mysql_password_root}" -e quit > /dev/null 2>&1; then
            echo "Incorrect MySQL root password"
            exit 1
        fi
        if ${MYSQL} -u ${USER} -p"${wizard_mysql_password_root}" mysql -e "SELECT User FROM user" | grep ^${MYSQL_USER}$ > /dev/null 2>&1; then
            echo "MySQL user ${MYSQL_USER} already exists"
            exit 1
        fi
        if ${MYSQL} -u ${USER} -p"${wizard_mysql_password_root}" -e "SHOW DATABASES" | grep ^${MYSQL_DATABASE}$ > /dev/null 2>&1; then
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
	cp -R ${INSTALL_DIR}/frontends/zabbix ${WEB_DIR}
	mv ${WEB_DIR}/zabbix/.htaccess.txt ${WEB_DIR}/zabbix/.htaccess
	ln -s ${INSTALL_DIR}/lib/mysql/libmysqlclient.so.16.0.0 ${INSTALL_DIR}/lib/libmysqlclient.so.16

    # Setup database and config file's
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e "CREATE DATABASE ${MYSQL_DATABASE}; GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'localhost' IDENTIFIED BY '${wizard_mysql_password_zabbix:=zabbix}';"
        
	 ${MYSQL} -u ${MYSQL_USER} --password="${wizard_mysql_password_zabbix:=zabbix}" -h localhost ${MYSQL_DATABASE} < /var/packages/${PACKAGE}/target/app/schema.sql
	 ${MYSQL} -u ${MYSQL_USER} --password="${wizard_mysql_password_zabbix:=zabbix}" -h localhost ${MYSQL_DATABASE} < /var/packages/${PACKAGE}/target/app/images.sql
	 ${MYSQL} -u ${MYSQL_USER} --password="${wizard_mysql_password_zabbix:=zabbix}" -h localhost ${MYSQL_DATABASE} < /var/packages/${PACKAGE}/target/app/data.sql
	 
	 sed -i -e "s|@db_password@|${wizard_mysql_password_zabbix:=zabbix}|g" ${CFG_FILE}
	 sed -i -e "s|@sr_port@|${zabbix_server_port:=10051}|g" ${CFG_FILE}

	 sed -i -e "s|@db_password@|${wizard_mysql_password_zabbix:=zabbix}|g" ${WEB_DIR}/zabbix/conf/zabbix.conf.php
	 sed -i -e "s|@sr_port@|${zabbix_server_port:=10051}|g" ${WEB_DIR}/zabbix/conf/zabbix.conf.php
	 sed -i -e "s|@sr_name@|${zabbix_server_hostname:=Zabbix server}|g" ${WEB_DIR}/zabbix/conf/zabbix.conf.php
    fi


    # Correct the files ownership
    chown -R ${USER}:root ${SYNOPKG_PKGDEST}

    exit 0
}

preuninst ()
{
    # Check database
    if [ "${SYNOPKG_PKG_STATUS}" == "NINSTALL" -a "${wizard_remove_database}" == "true" ] && ! ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e quit > /dev/null 2>&1; then
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

    exit 0
}

postupgrade ()
{
    # Restore some stuff
    rm -fr ${INSTALL_DIR}/etc
    mv ${TMP_DIR}/${PACKAGE}/etc ${INSTALL_DIR}/
    rm -fr ${TMP_DIR}/${PACKAGE}

    exit 0
}
