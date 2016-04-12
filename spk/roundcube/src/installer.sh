#!/bin/sh

# Package
PACKAGE="roundcube"
DNAME="Roundcube Webmail"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
WEB_DIR="/var/services/web"
USER="$([ $(/bin/get_key_value /etc.defaults/VERSION buildnumber) -ge 4418 ] && echo -n http || echo -n nobody)"
MYSQL="$([ $(/bin/get_key_value /etc.defaults/VERSION buildnumber) -ge 7135 ] && echo -n /bin/mysql || echo -n /usr/syno/mysql/bin/mysql)"
MYSQLDUMP="$([ $(/bin/get_key_value /etc.defaults/VERSION buildnumber) -ge 7135 ] && echo -n /bin/mysqldump || echo -n /usr/syno/mysql/bin/mysqldump)"
MYSQL_USER="roundcube"
MYSQL_DATABASE="roundcube"
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
    cp -pR ${INSTALL_DIR}/share/${PACKAGE} ${WEB_DIR}
    rm -fr ${WEB_DIR}/${PACKAGE}/installer

    # Setup database and configuration files
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e "CREATE DATABASE ${MYSQL_DATABASE}; GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'localhost' IDENTIFIED BY '${wizard_mysql_password_roundcube}';"
        ${MYSQL} -u ${MYSQL_USER} -p"${wizard_mysql_password_roundcube}" ${MYSQL_DATABASE} < ${WEB_DIR}/${PACKAGE}/SQL/mysql.initial.sql
        sed -e "s|^\(\$config\['db_dsnw'\] =\).*$|\1 \'mysqli://roundcube:${wizard_mysql_password_roundcube}@localhost/roundcube\';|" \
            -e "s|^\(\$config\['default_host'\] =\).*$|\1 \'${wizard_roundcube_default_host}\';|" \
            -e "s|^\(\$config\['smtp_server'\] =\).*$|\1 \'${wizard_roundcube_smtp_server}\';|" \
            -e "s|^\(\$config\['smtp_port'\] =\).*$|\1 \'${wizard_roundcube_smtp_port:=25}\';|" \
            -e "s|^\(\$config\['smtp_user'\] =\).*$|\1 \'${wizard_roundcube_smtp_user}\';|" \
            -e "s|^\(\$config\['smtp_pass'\] =\).*$|\1 \'${wizard_roundcube_smtp_pass}\';|" \
            ${WEB_DIR}/${PACKAGE}/config/config.inc.php.sample > ${WEB_DIR}/${PACKAGE}/config/config.inc.php
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
    rm -fr ${TMP_DIR}/${PACKAGE}
    mkdir -p ${TMP_DIR}/${PACKAGE}

    # Save pre 1.0.0 configuration files
    mv ${WEB_DIR}/${PACKAGE}/config/db.inc.php ${TMP_DIR}/${PACKAGE}/
    mv ${WEB_DIR}/${PACKAGE}/config/main.inc.php ${TMP_DIR}/${PACKAGE}/

    # Save configuration files for version >= 1.0.0
    mv ${WEB_DIR}/${PACKAGE}/config/config.inc.php ${TMP_DIR}/${PACKAGE}/

    # Save user installed plugins
    mkdir -p ${TMP_DIR}/${PACKAGE}/plugins
    for plugin in ${WEB_DIR}/${PACKAGE}/plugins/*/
    do
        dir=`basename $plugin`
        if [ ! -d ${INSTALL_DIR}/share/${PACKAGE}/plugins/${dir} ]; then
            cp -pR ${WEB_DIR}/${PACKAGE}/plugins/${dir} ${TMP_DIR}/${PACKAGE}/plugins/
        fi
    done

    # Save user installed skins
    mkdir -p ${TMP_DIR}/${PACKAGE}/skins
    for skin in ${WEB_DIR}/${PACKAGE}/skins/*/
    do
        dir=`basename $skin`
        if [ ! -d ${INSTALL_DIR}/share/${PACKAGE}/skins/${dir} ]; then
            cp -pR ${WEB_DIR}/${PACKAGE}/skins/${dir} ${TMP_DIR}/${PACKAGE}/skins/
        fi
    done

    exit 0
}

postupgrade ()
{
    # Restore pre 1.0.0 configuration files, still 1.0.0 compatible
    mv ${TMP_DIR}/${PACKAGE}/db.inc.php ${WEB_DIR}/${PACKAGE}/config/db.inc.php
    mv ${TMP_DIR}/${PACKAGE}/main.inc.php ${WEB_DIR}/${PACKAGE}/config/main.inc.php

    # Restore configuration files for version >= 1.0.0
    mv ${TMP_DIR}/${PACKAGE}/config.inc.php ${WEB_DIR}/${PACKAGE}/config/config.inc.php

    # Restore user installed plugins
    for plugin in ${TMP_DIR}/${PACKAGE}/plugins/*/
    do
        dir=`basename $plugin`
        if [ ! -d ${WEB_DIR}/${PACKAGE}/plugins/${dir} ]; then
            cp -pR ${TMP_DIR}/${PACKAGE}/plugins/${dir} ${WEB_DIR}/${PACKAGE}/plugins/
        fi
    done

    # Restore user installed skins
    for skin in ${TMP_DIR}/${PACKAGE}/skin/*/
    do
        dir=`basename $skin`
        if [ ! -d ${WEB_DIR}/${PACKAGE}/skins/${dir} ]; then
            cp -pR ${TMP_DIR}/${PACKAGE}/skins/${dir} ${WEB_DIR}/${PACKAGE}/skins/
        fi
    done

    rm -fr ${TMP_DIR}/${PACKAGE}

    exit 0
}
