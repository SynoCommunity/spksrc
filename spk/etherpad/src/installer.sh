#!/bin/sh

# Package
PACKAGE="etherpad"
DNAME="Etherpad"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
SSS="/var/packages/${PACKAGE}/scripts/start-stop-status"
NODE_DIR="/usr/local/node"
PATH="${INSTALL_DIR}/bin:${NODE_DIR}/bin:${PATH}"
USER="etherpad"
GROUP="users"
MYSQL="/usr/syno/mysql/bin/mysql"
MYSQL_USER="etherpad"
MYSQL_DATABASE="etherpad"
ETHERPAD="${INSTALL_DIR}/share/etherpad/bin/run.sh"
CFG_FILE="${INSTALL_DIR}/share/etherpad/settings.json"
TMP_DIR="${SYNOPKG_PKGDEST}/../../@tmp"


preinst ()
{
    exit 0
}

postinst ()
{
    # Link
    ln -s ${SYNOPKG_PKGDEST} ${INSTALL_DIR}
    
    # Install busybox stuff
    ${INSTALL_DIR}/bin/busybox --install ${INSTALL_DIR}/bin

    # Create user
    adduser -h ${INSTALL_DIR}/var -g "${DNAME} User" -G ${GROUP} -s /bin/sh -S -D ${USER}

    # Generate random string for sessionKey
    string=`< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-32};echo;`

    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e "CREATE DATABASE ${MYSQL_DATABASE}; GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'localhost' IDENTIFIED BY '${wizard_mysql_password_etherpad:=etherpad}';"
        #edit settings.json
        sed -i -e "s|\"sessionKey\" : \"\"|\"sessionKey\" : \"${string}\"|g" \
               -e "s|@dbpassword@|${wizard_mysql_password_etherpad:=etherpad}|g" \
               -e "s|@adminusr@|${wizard_etherpad_admin_username:=etherpad}|g" \
               -e "s|@adminpass@|${wizard_etherpad_admin_password:=etherpad}|g" \
               ${CFG_FILE}
        # Get NPM dependencies
        PATH=${PATH} ${INSTALL_DIR}/share/etherpad/bin/installDeps.sh  
        # Prepare database
        ${SSS} start
        sleep 10
        ${SSS} stop
        ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e "ALTER DATABASE ${MYSQL_DATABASE} CHARACTER SET utf8 COLLATE utf8_bin;USE ${MYSQL_DATABASE};ALTER TABLE store CONVERT TO CHARACTER SET utf8 COLLATE utf8_bin;"
        sleep 10
    fi

    # Correct the files ownership
    chown -R ${USER}:root ${SYNOPKG_PKGDEST}

    exit 0
}

preuninst ()
{
    # Check database
    if [ "${SYNOPKG_PKG_STATUS}" == "UNINSTALL" -a "${wizard_remove_database}" == "true" ] && ! ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e quit > /dev/null 2>&1; then
        echo "Incorrect MySQL root password"
        exit 1
    fi
    
    # Remove the user (if not upgrading)
    if [ "${SYNOPKG_PKG_STATUS}" != "UPGRADE" ]; then
        delgroup ${USER} ${GROUP}
        deluser ${USER}
    fi

    exit 0


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

    exit 0
}

preupgrade ()
{
    # Stop the package
    ${SSS} stop > /dev/null

    # Save some stuff
    rm -fr ${TMP_DIR}/${PACKAGE}
    mkdir -p ${TMP_DIR}/${PACKAGE}
    mv ${INSTALL_DIR}/share/etherpad/settings.json ${TMP_DIR}/${PACKAGE}/settings.json

    exit 0
}

postupgrade ()
{
    # Restore some stuff
    mv ${TMP_DIR}/${PACKAGE}/settings.json ${INSTALL_DIR}/share/etherpad/settings.json
    rm -fr ${TMP_DIR}/${PACKAGE}

    exit 0
}
