#!/bin/sh

# Package
PACKAGE="roundcube"
DNAME="Roundcube Webmail"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
WEB_DIR="/var/services/web"
USER="$([ $(grep buildnumber /etc.defaults/VERSION | cut -d"\"" -f2) -ge 4418 ] && echo -n http || echo -n nobody)"
MYSQL="/usr/syno/mysql/bin/mysql"
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
    cp -R ${INSTALL_DIR}/share/${PACKAGE} ${WEB_DIR}
    rm -fr ${WEB_DIR}/${PACKAGE}/installer

    # Setup database and configuration files
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e "CREATE DATABASE ${MYSQL_DATABASE}; GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'localhost' IDENTIFIED BY '${wizard_mysql_password_roundcube}';"
        ${MYSQL} -u ${MYSQL_USER} -p"${wizard_mysql_password_roundcube}" ${MYSQL_DATABASE} < ${WEB_DIR}/${PACKAGE}/SQL/mysql.initial.sql
        sed "s|^\(\$rcmail_config\['db_dsnw'\] =\).*$|\1 \'mysqli://roundcube:${wizard_mysql_password_roundcube}@localhost/roundcube\';|" \
            ${WEB_DIR}/${PACKAGE}/config/db.inc.php.dist > ${WEB_DIR}/${PACKAGE}/config/db.inc.php
        sed -e "s|^\(\$rcmail_config\['default_host'\] =\).*$|\1 \'${wizard_roundcube_default_host}\';|" \
            -e "s|^\(\$rcmail_config\['smtp_server'\] =\).*$|\1 \'${wizard_roundcube_smtp_server}\';|" \
            -e "s|^\(\$rcmail_config\['smtp_port'\] =\).*$|\1 \'${wizard_roundcube_smtp_port:=25}\';|" \
            -e "s|^\(\$rcmail_config\['smtp_user'\] =\).*$|\1 \'${wizard_roundcube_smtp_user}\';|" \
            -e "s|^\(\$rcmail_config\['smtp_pass'\] =\).*$|\1 \'${wizard_roundcube_smtp_pass}\';|" \
            ${WEB_DIR}/${PACKAGE}/config/main.inc.php.dist > ${WEB_DIR}/${PACKAGE}/config/main.inc.php
    fi

    # Fix permissions
    chown -R ${USER} ${WEB_DIR}/${PACKAGE}
    find ${WEB_DIR}/${PACKAGE} -type f -exec chmod 640 {} \;
    find ${WEB_DIR}/${PACKAGE} -type d -exec chmod 750 {} \;

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
    # Save configuration files
    rm -fr ${TMP_DIR}/${PACKAGE}
    mkdir -p ${TMP_DIR}/${PACKAGE}
    mv ${WEB_DIR}/${PACKAGE}/config/db.inc.php ${TMP_DIR}/${PACKAGE}/
    mv ${WEB_DIR}/${PACKAGE}/config/main.inc.php ${TMP_DIR}/${PACKAGE}/

    exit 0
}

postupgrade ()
{
    # Restore configuration files
    mv ${TMP_DIR}/${PACKAGE}/db.inc.php ${WEB_DIR}/${PACKAGE}/config/db.inc.php
    mv ${TMP_DIR}/${PACKAGE}/main.inc.php ${WEB_DIR}/${PACKAGE}/config/main.inc.php
    chown -R ${USER} ${WEB_DIR}/${PACKAGE}
    rm -fr ${TMP_DIR}/${PACKAGE}

    exit 0
}
