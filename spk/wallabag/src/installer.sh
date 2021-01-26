
PUBLIC_PATH="wallabag"
TMP_DIR="${SYNOPKG_PKGVAR}/tmp"
# for backwards compatability
if [ $SYNOPKG_DSM_VERSION_MAJOR -lt 7 ];then
    SYNOPKG_PKGNAME="wallabag"
    TMP_DIR="${SYNOPKG_PKGDEST}/../../@tmp"
    PUBLIC_PATH="wallabag/web"
fi

INSTALL_DIR="/usr/local/${SYNOPKG_PKGNAME}"
WEB_DIR="/var/services/web_packages"
if [ $SYNOPKG_DSM_VERSION_MAJOR -lt 7 ];then
WEB_DIR="/var/services/web"
fi
HTTP_USER="$([ $(/bin/get_key_value /etc.defaults/VERSION buildnumber) -ge 4418 ] && echo -n http || echo -n nobody)"
PHP="/usr/local/bin/php74"
MYSQL="/usr/bin/mysql"
MYSQLDUMP="/usr/bin/mysqldump"
if command -v /var/packages/MariaDB10/target/usr/local/mariadb10/bin/mysql &> /dev/null; then
    MYSQL="/var/packages/MariaDB10/target/usr/local/mariadb10/bin/mysql"
fi
if command -v /var/packages/MariaDB10/target/usr/local/mariadb10/bin/mysqldump &> /dev/null; then
    MYSQLDUMP="/var/packages/MariaDB10/target/usr/local/mariadb10/bin/mysqldump"
fi
CFG_FILE="${WEB_DIR}/${SYNOPKG_PKGNAME}/app/config/parameters.yml"
MYSQL_USER="${SYNOPKG_PKGNAME}"
MYSQL_DATABASE="${SYNOPKG_PKGNAME}"

preinst ()
{
    if [ $SYNOPKG_DSM_VERSION_MAJOR -lt 7 ];then
        mkdir -p ${WEB_DIR}/${SYNOPKG_PKGNAME}
    fi
}

postinst () {
    if [ $SYNOPKG_DSM_VERSION_MAJOR -lt 7 ]; then
        cp -pR ${SYNOPKG_PKGDEST}/share/${SYNOPKG_PKGNAME} ${WEB_DIR}
        # use old url
        ui_conf_file="var/packages/${SYNOPKG_PKGNAME}/target/app/config"
        jq '.".url"."com.synocommunity.packages.wallabag"."url" = "/wallabag/web"' $ui_conf_file 1<> $ui_conf_file
    fi

    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        # set preferences
        sed -i -e "s|@database_password@|${wizard_wallabag_password}|g" \
            -e "s|@database_name@|${MYSQL_DATABASE}|g" \
            -e "s|@database_port@|${wizard_database_port}|g" \
            -e "s|@protocoll_and_domain_name@|${wizard_protocoll_and_domain_name}/${PUBLIC_PATH}|g" \
            -e "s|@wallabag_secret@|$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 30 | head -n 1)|g" ${CFG_FILE}

        # install wallabag
        if ! ${PHP} ${WEB_DIR}/${SYNOPKG_PKGNAME}/bin/console wallabag:install --env=prod --reset -n -vvv > ${WEB_DIR}/${SYNOPKG_PKGNAME}/install.log 2>&1; then
            echo "Failed to install wallabag. Please check the log: ${WEB_DIR}/${SYNOPKG_PKGNAME}/install.log"
            exit 1
        fi
    fi

    if [ $SYNOPKG_DSM_VERSION_MAJOR -lt 7 ];then
        chown -R ${HTTP_USER} ${WEB_DIR}/${SYNOPKG_PKGNAME}
    fi
    exit 0
}

preuninst ()
{
    echo "wizard_delete_data: $wizard_delete_data" >&2;
    if [ "$wizard_delete_data" == "true" ]; then
        resource_file="/var/packages/${SYNOPKG_PKGNAME}/conf/resource"
        jq '."mariadb10-db"."drop-db-uninst" = true' $resource_file 1<> $resource_file
        jq '."mariadb10-db"."drop-user-uninst" = true' $resource_file 1<> $resource_file
    fi
    exit 0
}

postuninst ()
{
    if [ $SYNOPKG_DSM_VERSION_MAJOR -lt 7 ]; then
        rm -rf ${WEB_DIR}/${SYNOPKG_PKGNAME}
    fi
    exit 0
}

preupgrade ()
{
    rm -rf ${TMP_DIR}/${SYNOPKG_PKGNAME}
    mkdir -p ${TMP_DIR}/${SYNOPKG_PKGNAME}
    mv ${CFG_FILE} ${TMP_DIR}/${SYNOPKG_PKGNAME}/parameters.yml
    mv ${WEB_DIR}/${SYNOPKG_PKGNAME}/data/db ${TMP_DIR}/${SYNOPKG_PKGNAME}/
    exit 0
}

postupgrade ()
{
    mv ${TMP_DIR}/${SYNOPKG_PKGNAME}/parameters.yml ${CFG_FILE}
    mv ${TMP_DIR}/${SYNOPKG_PKGNAME}/db ${WEB_DIR}/${SYNOPKG_PKGNAME}/data/db
    touch ${WEB_DIR}/${SYNOPKG_PKGNAME}/var/logs/prod.log

    # Add new parameters to parameters.yml for newer version
    if ! grep -q '^    server_name:' ${CFG_FILE}; then
        echo '    server_name: "wallabag"' >> ${CFG_FILE}
    fi

    # migrate database
    if ! ${PHP} ${WEB_DIR}/${SYNOPKG_PKGNAME}/bin/console doctrine:migrations:migrate --env=prod -n -vvv > ${WEB_DIR}/${SYNOPKG_PKGNAME}/migration.log 2>&1; then
        echo "Unable to migrate database schema. Please check the log: ${WEB_DIR}/${SYNOPKG_PKGNAME}/migration.log"
        exit 1
    fi

    if [ $SYNOPKG_DSM_VERSION_MAJOR -lt 7 ]; then
        chown -R ${HTTP_USER}:${USER} ${WEB_DIR}/${SYNOPKG_PKGNAME}
    fi

    rm -rf ${TMP_DIR}/${SYNOPKG_PKGNAME}
    exit 0
}
