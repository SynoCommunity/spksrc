# Package
PACKAGE="wallabag"
DNAME="Wallabag"
PACKAGE_NAME="com.synocommunity.packages.${PACKAGE}"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
WEB_DIR="/var/services/web_packages"
if [ $SYNOPKG_DSM_VERSION_MAJOR -lt 7 ];then
WEB_DIR="/var/services/web"
fi
HTTP_USER="$([ $(/bin/get_key_value /etc.defaults/VERSION buildnumber) -ge 4418 ] && echo -n http || echo -n nobody)"
TMP_DIR="${SYNOPKG_PKGDEST}/../../@tmp"
PHP="/usr/local/bin/php74"
MYSQL="/usr/bin/mysql"
MYSQLDUMP="/usr/bin/mysqldump"
if command -v /var/packages/MariaDB10/target/usr/local/mariadb10/bin/mysql &> /dev/null; then
    MYSQL="/var/packages/MariaDB10/target/usr/local/mariadb10/bin/mysql"
fi
if command -v /var/packages/MariaDB10/target/usr/local/mariadb10/bin/mysqldump &> /dev/null; then
    MYSQLDUMP="/var/packages/MariaDB10/target/usr/local/mariadb10/bin/mysqldump"
fi
CFG_FILE="${WEB_DIR}/${PACKAGE}/app/config/parameters.yml"
MYSQL_USER="wallabag"
MYSQL_DATABASE="wallabag"

service_preinst ()
{
    mkdir -p ${WEB_DIR}/${PACKAGE}

    # if [ $SYNOPKG_DSM_VERSION_MAJOR -lt 5 ];then
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
            # if ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e "SHOW DATABASES" | grep ^${MYSQL_DATABASE}$ > /dev/null 2>&1; then
            #     echo "MySQL database ${MYSQL_DATABASE} already exists"
            #     exit 1
            # fi
        fi
        exit 0
    # fi
}

service_postinst () {
    # 'rand-pw' is not fully implemented on DSM 6 it requires 'user-pw' (mariadb10-db)
    # $ cat /var/log/messages
    # > dsm6 synoscgi_SYNO.Core.Package.Installation_1_install[27600]: synomariadbworker.cpp:483 Illegal field [grant-user][user-pw].
    # > dsm6 synoscgi_SYNO.Core.Package.Installation_1_install[27600]: resource_api.cpp:190 Acquire mariadb10-db for wallabag when 0x0001 (fail)
    # > dsm6 synoscgi_SYNO.Core.Package.Installation_1_install[27600]: resource_api.cpp:205 Rollback mariadb10-db for wallabag when 0x0001 (done)
    # > dsm6 synoscgi_SYNO.Core.Package.Installation_1_install[26609]: pkginstall.cpp:735 Failed to acquire resource before install wallabag [0xD900 manager.cpp:204]

    # if [ -z $SYNOPKG_DB_USER_RAND_PW ]; then
    #     echo "error with install wizard, no db password" 1>&2;
    #     #exit 1
    # fi

    if [ $SYNOPKG_DSM_VERSION_MAJOR -lt 7 ]; then
        # Install the web interface
        cp -pR ${SYNOPKG_PKGDEST}/share/${PACKAGE} ${WEB_DIR}
    fi

    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        # create wallabag database and user
        # if [ $SYNOPKG_DSM_VERSION_MAJOR -lt 5 ];then
        #     ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e "CREATE DATABASE ${MYSQL_DATABASE}; GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'localhost' IDENTIFIED BY '${wizard_mysql_database_password}';"
        # fi

        # render properties
        sed -i -e "s|@database_password@|${wizard_wallabag_password_root}|g" \
            -e "s|@database_name@|${MYSQL_DATABASE}|g" \
            -e "s|@database_port@|${wizard_database_port}|g" \
            -e "s|@protocoll_and_domain_name@|${wizard_protocoll_and_domain_name}/wallabag/web|g" \
            -e "s|@wallabag_secret@|$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 30 | head -n 1)|g" ${CFG_FILE}

        # install wallabag
        if ! ${PHP} ${WEB_DIR}/${PACKAGE}/bin/console wallabag:install --env=prod --reset -n -vvv > ${WEB_DIR}/${PACKAGE}/install.log 2>&1; then
            echo "Failed to install wallabag. Please check the log: ${WEB_DIR}/${PACKAGE}/install.log"
            exit 1
        fi
    fi

    if [ $SYNOPKG_DSM_VERSION_MAJOR -lt 7 ];then
        # permissions
        chown -R ${HTTP_USER} ${WEB_DIR}/${PACKAGE}
    fi
    exit 0
}

service_preuninst ()
{
    # Check database
    # if [ "${SYNOPKG_PKG_STATUS}" == "UNINSTALL" ] && ! ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e quit > /dev/null 2>&1; then
    #     echo "Incorrect MySQL root password"
    #     exit 1
    # fi

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
    # if [ "${SYNOPKG_PKG_STATUS}" == "UNINSTALL" ]; then
    #     if [ -n "${wizard_dbexport_path}" ]; then
    #         mkdir -p ${wizard_dbexport_path}
    #         ${MYSQLDUMP} -u root -p"${wizard_mysql_password_root}" ${MYSQL_DATABASE} > ${wizard_dbexport_path}/${MYSQL_DATABASE}.sql
    #     fi
    #     # if [ $SYNOPKG_DSM_VERSION_MAJOR -lt 5 ]; then
    #     #     ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e "DROP DATABASE ${MYSQL_DATABASE}; DROP USER '${MYSQL_USER}'@'localhost';"
    #     # fi
    # fi

    if [ $SYNOPKG_DSM_VERSION_MAJOR -lt 7 ]; then
        # Remove the web interface
        rm -rf ${WEB_DIR}/${PACKAGE}
    fi
    exit 0
}

service_preupgrade ()
{
    rm -rf ${TMP_DIR}/${PACKAGE}
    mkdir -p ${TMP_DIR}/${PACKAGE}
    mv ${CFG_FILE} ${TMP_DIR}/${PACKAGE}/
    mv ${WEB_DIR}/${PACKAGE}/data/db ${TMP_DIR}/${PACKAGE}/
    exit 0
}

service_postupgrade ()
{
    mv ${TMP_DIR}/${PACKAGE}/parameters.yml ${CFG_FILE}
    mv ${TMP_DIR}/${PACKAGE}/db ${WEB_DIR}/${PACKAGE}/data/db

    # Add new parameters to parameters.yml for new version
    if ! grep -q '^    server_name:' ${CFG_FILE}
        echo '    server_name: "wallabag"' >> ${CFG_FILE}
    fi

    # migrate database
    if ! ${PHP} ${WEB_DIR}/${PACKAGE}/bin/console doctrine:migrations:migrate --env=prod -n -vvv > ${WEB_DIR}/${PACKAGE}/migration.log 2>&1; then
        echo "Unable to migrate database schema. Please check the log: ${WEB_DIR}/${PACKAGE}/migration.log"
        exit 1
    fi

    if [ $SYNOPKG_DSM_VERSION_MAJOR -lt 7 ];then
        # permissions after upgrade
        chown -R ${USER} ${WEB_DIR}/${PACKAGE}
    fi

    rm -rf ${TMP_DIR}/${PACKAGE}
    exit 0
}
