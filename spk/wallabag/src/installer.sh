#!/bin/sh

# Package
PACKAGE="wallabag"
DNAME="Wallabag"
PACKAGE_NAME="com.synocommunity.packages.${PACKAGE}"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
WEB_DIR="/var/services/web"
USER="$([ $(/bin/get_key_value /etc.defaults/VERSION buildnumber) -ge 4418 ] && echo -n http || echo -n nobody)"
TMP_DIR="${SYNOPKG_PKGDEST}/../../@tmp"
PHP="$([ $(/bin/get_key_value /etc.defaults/VERSION buildnumber) -ge 7135 ] && echo -n /usr/local/bin/php56 || echo -n /usr/bin/php)"
MYSQL="/usr/bin/mysql"
MYSQLDUMP="/usr/bin/mysqldump"
CFG_FILE="${WEB_DIR}/${PACKAGE}/app/config/parameters.yml"
MYSQL_USER="wallabag"
MYSQL_DATABASE="wallabag"


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

    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        # create wallabag database and user
        ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e "CREATE DATABASE ${MYSQL_DATABASE}; GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'localhost' IDENTIFIED BY '${wizard_mysql_database_password}';"

        # render properties
        sed -i -e "s|@database_password@|${wizard_mysql_database_password}|g" \
            -e "s|@database_name@|${MYSQL_DATABASE}|g" \
            -e "s|@wallabag_secret@|$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 30 | head -n 1)|g" \
            ${CFG_FILE}

        # install wallabag
        if ! ${PHP} ${WEB_DIR}/${PACKAGE}/bin/console wallabag:install --env=prod --reset -n -vvv > ${WEB_DIR}/${PACKAGE}/install.log 2>&1; then
            echo "Failed to install wallabag. Please check the log: ${WEB_DIR}/${PACKAGE}/install.log"
            exit 1
        fi
    fi

    # permissions
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
    rm -rf ${WEB_DIR}/${PACKAGE}

    exit 0
}

preupgrade ()
{
    rm -rf ${TMP_DIR}/${PACKAGE}
    mkdir -p ${TMP_DIR}/${PACKAGE}
    mv ${CFG_FILE} ${TMP_DIR}/${PACKAGE}/
    mv ${WEB_DIR}/${PACKAGE}/data/db ${TMP_DIR}/${PACKAGE}/
    exit 0
}

postupgrade ()
{
    mv ${TMP_DIR}/${PACKAGE}/parameters.yml ${CFG_FILE}
    mv ${TMP_DIR}/${PACKAGE}/db ${WEB_DIR}/${PACKAGE}/data/db

    # migrate database
    if ! ${PHP} ${WEB_DIR}/${PACKAGE}/bin/console doctrine:migrations:migrate --env=prod -n -vvv > ${WEB_DIR}/${PACKAGE}/migration.log 2>&1; then
        echo "Unable to migrate database schema. Please check the log: ${WEB_DIR}/${PACKAGE}/migration.log"
        exit 1
    fi

    # permissions after upgrade
    chown -R ${USER} ${WEB_DIR}/${PACKAGE}

    rm -rf ${TMP_DIR}/${PACKAGE}
    exit 0
}
