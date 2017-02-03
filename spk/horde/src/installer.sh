#!/bin/sh

# Package
PACKAGE="horde"
DNAME="Horde"
PACKAGE_NAME="com.synocommunity.packages.${PACKAGE}"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
SSS="/var/packages/${PACKAGE}/scripts/start-stop-status"
WEB_DIR="/var/services/web"
TMP_DIR="${SYNOPKG_PKGDEST}/../../@tmp"
BUILDNUMBER="$(/bin/get_key_value /etc.defaults/VERSION buildnumber)"

USER="$([ "${BUILDNUMBER}" -ge "4418" ] && echo -n http || echo -n nobody)"
MYSQL="$([ "${BUILDNUMBER}" -ge "7321" ] && echo -n /bin/mysql || echo -n /usr/syno/mysql/bin/mysql)"
MYSQLDUMP="$([ "${BUILDNUMBER}" -ge "7321" ] && echo -n /bin/mysqldump || echo -n /usr/syno/mysql/bin/mysqldump)"
MYSQL_USER="horde"
MYSQL_DATABASE="horde"


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

    # Install busybox stuff
    ${INSTALL_DIR}/bin/busybox --install ${INSTALL_DIR}/bin

    # Create the web interface
    mkdir ${WEB_DIR}/${PACKAGE}

    # Setup database
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e "CREATE DATABASE ${MYSQL_DATABASE}; GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'localhost' IDENTIFIED BY '${wizard_mysql_password_horde:=horde}';"
    fi

    # Configure Apache variables
    if [ "${USER}" == "nobody" ]; then
        echo -e "<Directory \"${WEB_DIR}/${PACKAGE}\">\nSetEnv PHP_PEAR_SYSCONF_DIR ${INSTALL_DIR}/etc\nphp_value include_path \".:${INSTALL_DIR}/share/pear\"\nphp_admin_value open_basedir none\n</Directory>" > /usr/syno/etc/sites-enabled-user/${PACKAGE}.conf
    else
        echo -e "extension = fileinfo.so\n[PATH=${WEB_DIR}/${PACKAGE}]\nopen_basedir = Null\ninclude_path = .:${INSTALL_DIR}/share/pear/php" > /etc/php/conf.d/${PACKAGE_NAME}.ini
    fi

    # Create Pear config
    pear config-create ${INSTALL_DIR}/share ${INSTALL_DIR}/etc/pear.conf > /dev/null
    pear -c ${INSTALL_DIR}/etc/pear.conf config-set bin_dir ${INSTALL_DIR}/bin > /dev/null

    # Install Pear
    pear -c ${INSTALL_DIR}/etc/pear.conf install pear > /dev/null

    # Begin installation
    ${INSTALL_DIR}/bin/pear -c ${INSTALL_DIR}/etc/pear.conf channel-discover pear.horde.org > /dev/null
    ${INSTALL_DIR}/bin/pear -c ${INSTALL_DIR}/etc/pear.conf install horde/horde_role > /dev/null

    # Create required Horde variable manually instead of running interactive script via "pear run-scripts horde/horde_role"
    ${INSTALL_DIR}/bin/pear -c ${INSTALL_DIR}/etc/pear.conf config-set -c pear.horde.org horde_dir ${WEB_DIR}/${PACKAGE} > /dev/null

    # Setup temporary page
    echo -e "<html><body><h2>Horde installation is in progress, please wait. It can take 10 to 20 minutes to finish.</h2></body></html>" \
      > ${WEB_DIR}/${PACKAGE}/index.html

    # Save selected edition because of upgrades
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        if [ ${wizard_horde_edition_groupware} == "true" ]; then
            echo "groupware" > ${INSTALL_DIR}/var/edition
        else
            echo "webmail" > ${INSTALL_DIR}/var/edition
        fi
    else
        mv ${TMP_DIR}/${PACKAGE}/edition ${INSTALL_DIR}/var
    fi

    edition=`cat ${INSTALL_DIR}/var/edition`

    # Create script for easy upgrade
    echo -e "#!/bin/sh\n${INSTALL_DIR}/bin/pear -c ${INSTALL_DIR}/etc/pear.conf upgrade -B\nchown -R ${USER} ${WEB_DIR}/${PACKAGE}" > ${INSTALL_DIR}/bin/horde-pear-upgrade
    chmod +x ${INSTALL_DIR}/bin/horde-pear-upgrade

    # Finish installation in the background
    postinst_bg &

    exit 0
}

postinst_bg ()
{
    ${INSTALL_DIR}/bin/pear -c ${INSTALL_DIR}/etc/pear.conf install -a -B -f horde/$edition > $(INSTALL_DIR)/var/install.log 2>&1

    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        cp ${WEB_DIR}/${PACKAGE}/config/conf.php.dist ${WEB_DIR}/${PACKAGE}/config/conf.php
        echo -e "\n\$conf['sql']['username'] = '${MYSQL_USER}';" \
          "\n\$conf['sql']['password'] = '${wizard_mysql_password_horde:=horde}';" \
          "\n\$conf['sql']['hostspec'] = 'localhost';" \
          "\n\$conf['sql']['port'] = 3306;" \
          "\n\$conf['sql']['protocol'] = 'tcp';" \
          "\n\$conf['sql']['database'] = '${MYSQL_DATABASE}';" \
          "\n\$conf['sql']['phptype'] = 'mysql';" \
          "\n\$conf['share']['driver'] = 'Sqlng';" \
          "\n\$conf['group']['driver'] = 'Sql';" >> ${WEB_DIR}/${PACKAGE}/config/conf.php
    fi

    # Create/update database tables (second run creates last two table) - work around interactive installer
    PHP_PEAR_SYSCONF_DIR=${INSTALL_DIR}/etc php -d open_basedir=none -d include_path=${INSTALL_DIR}/share/pear/php ${INSTALL_DIR}/bin/horde-db-migrate >> $(INSTALL_DIR)/var/install.log 2>&1
    PHP_PEAR_SYSCONF_DIR=${INSTALL_DIR}/etc php -d open_basedir=none -d include_path=${INSTALL_DIR}/share/pear/php ${INSTALL_DIR}/bin/horde-db-migrate >> $(INSTALL_DIR)/var/install.log 2>&1

    # Fix permissions
    chown -R ${USER} ${WEB_DIR}/${PACKAGE}

    # Remove temporary page
    rm -f ${WEB_DIR}/${PACKAGE}/index.html
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

    # Remove Apache configuration
    rm -f /usr/syno/etc/sites-enabled-user/${PACKAGE}.conf
    rm -f /etc/php/conf.d/${PACKAGE_NAME}.ini

    # Remove the web interface
    rm -fr ${WEB_DIR}/${PACKAGE}

    exit 0
}

preupgrade ()
{
    # Stop the package
    ${SSS} stop > /dev/null 

    # Save configuration files
    rm -fr ${TMP_DIR}/${PACKAGE}
    mkdir -p ${TMP_DIR}/${PACKAGE}

    # Save package edition config
    mv ${INSTALL_DIR}/var/edition ${TMP_DIR}/${PACKAGE}

    # Save main Horde config
    mv ${WEB_DIR}/${PACKAGE}/config/conf.php ${TMP_DIR}/${PACKAGE}/

    # Save e-mail config
    mv ${WEB_DIR}/${PACKAGE}/imp/config/backends.local.php ${TMP_DIR}/${PACKAGE}/

    # Save other apps configs
    cd ${WEB_DIR}/${PACKAGE} && for file in */config/conf.php; do
        if [ ! -f ${WEB_DIR}/${PACKAGE}/$file ]; then 
            continue
        fi
        dir=$(dirname $file)
        mkdir -p ${TMP_DIR}/${PACKAGE}/$dir
        mv ${WEB_DIR}/${PACKAGE}/$file ${TMP_DIR}/${PACKAGE}/$file
    done

    exit 0
}

postupgrade ()
{
    # Restore main Horde config
    mkdir -p ${WEB_DIR}/${PACKAGE}/config
    mv ${TMP_DIR}/${PACKAGE}/conf.php ${WEB_DIR}/${PACKAGE}/config/conf.php

    # Restore e-mail config
    if [ -f ${TMP_DIR}/${PACKAGE}/backends.local.php ]; then
        mkdir -p ${WEB_DIR}/${PACKAGE}/imp/config
        mv ${TMP_DIR}/${PACKAGE}/backends.local.php ${WEB_DIR}/${PACKAGE}/imp/config/backends.local.php
    fi

    # Restore other apps configs
    cd ${TMP_DIR}/${PACKAGE} && for file in */config/conf.php; do
        if [ ! -f ${TMP_DIR}/${PACKAGE}/$file ]; then 
            continue
        fi
        dir=$(dirname $file)
        mkdir -p ${WEB_DIR}/${PACKAGE}/$dir
        mv ${TMP_DIR}/${PACKAGE}/$file ${WEB_DIR}/${PACKAGE}/$file
    done

    rm -fr ${TMP_DIR}/${PACKAGE}

    exit 0
}
