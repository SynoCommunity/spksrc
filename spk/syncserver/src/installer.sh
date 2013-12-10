#!/bin/sh

# Package
PACKAGE="syncserver"
DNAME="Mozilla Sync Server"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
SSS="/var/packages/${PACKAGE}/scripts/start-stop-status"
PYTHON_DIR="/usr/local/python"
PATH="${INSTALL_DIR}/env/bin:${INSTALL_DIR}/bin:${PYTHON_DIR}/bin:${PATH}"
HG="${PYTHON_DIR}/bin/hg"
VIRTUALENV="${PYTHON_DIR}/bin/virtualenv"
WIZARD="/var/packages/${PACKAGE}/WIZARD_UIFILES"

INDEXFILES="${INSTALL_DIR}/app/help"

USER="syncserver"
GROUP="users"

MYSQL="/usr/syno/mysql/bin/mysql"

INI_FILE="${INSTALL_DIR}/var/syncserver.ini"
CONF_FILE="${INSTALL_DIR}/var/syncserver.conf"
TMP_DIR="${SYNOPKG_PKGDEST}/../../@tmp"


preinst ()
{

    exit 0
}

postinst ()
{
    # Link
    ln -s ${SYNOPKG_PKGDEST} ${INSTALL_DIR}

    # Get IP address
    IP=`/sbin/ifconfig | grep 'inet addr:'| grep -v '127.0.0.1' | cut -d: -f2 | awk '{ print $1}'`

    # Edit the configuration according to the wizard
    # Setup database, using SQLite unless MySQL password is provided
    if [ ! -z "${wizard_mysql_password_root}" ]; then
        # Use MySQL
        ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e "CREATE DATABASE ${PACKAGE}; GRANT ALL PRIVILEGES ON ${PACKAGE}.* TO '${USER}'@'localhost' IDENTIFIED BY '${wizard_password_syncserver:=syncserver}';"    
        sed -i "s|sqluri.*|sqluri = pymysql://${USER}:${wizard_password_syncserver}@localhost:3306/${PACKAGE}|g" ${CONF_FILE}
    else
        if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
             # No need for uninstall wizard files with SQLite, removing
             rm -fr ${WIZARD}/uninstall*
        fi
    fi

    # Set other variables according to the wizard
    sed -i "s|@ip@|${IP}|g" ${CONF_FILE}
    sed -i "s|@smtp_server@|${wizard_syncserver_smtp_server:=localhost}|g" ${CONF_FILE}
    sed -i "s|@smtp_port@|${wizard_syncserver_smtp_port:=25}|g" ${CONF_FILE}
    sed -i "s|@sender@|${wizard_syncserver_sender:=syncserver@domain.com}|g" ${CONF_FILE}

    # Create a Python virtualenv
    ${VIRTUALENV} --system-site-packages ${INSTALL_DIR}/env >> /dev/null

    # Install the bundle
    ${INSTALL_DIR}/env/bin/pip install --no-index -U --no-deps --force-reinstall ${INSTALL_DIR}/share/requirements.pybundle > /dev/null

    # Build Sync dependencies
    cd ${INSTALL_DIR}/share/syncserver/deps/server-storage && ${INSTALL_DIR}/env/bin/python setup.py develop > /dev/null
    cd ${INSTALL_DIR}/share/syncserver/deps/server-reg && ${INSTALL_DIR}/env/bin/python setup.py develop > /dev/null
    cd ${INSTALL_DIR}/share/syncserver/deps/server-core && ${INSTALL_DIR}/env/bin/python setup.py develop > /dev/null

    # Build Sync
    cd ${INSTALL_DIR}/share/syncserver && ${INSTALL_DIR}/env/bin/python setup.py develop > /dev/null

    # Adjust and index help files
    pkgindexer_add ${INSTALL_DIR}/app/index.conf > /dev/null
    pkgindexer_add ${INSTALL_DIR}/app/helptoc.conf > /dev/null

    # Since we're already counting on the IP not changing...
    for f in `find ${INDEXFILES} -name 'index.html'`; do sed -i "s|syno-ip|${IP}|g" ${f};done;

    # Create user
    adduser -h ${INSTALL_DIR}/var -g "${DNAME} User" -G ${GROUP} -s /bin/sh -S -D ${USER}

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

    # Stop the package
    ${SSS} stop > /dev/null

    # Remove the user if uninstalling
    if [ "${SYNOPKG_PKG_STATUS}" == "UNINSTALL" ]; then
        delgroup ${USER} ${GROUP}
        deluser ${USER}
    fi

    # Remove help files
    pkgindexer_del ${INSTALL_DIR}/app/index.conf > /dev/null
    pkgindexer_del ${INSTALL_DIR}/app/helptoc.conf > /dev/null

    exit 0
}

postuninst ()
{
    # Remove link
    rm -f ${INSTALL_DIR}

    # Remove MySQL database
    if [ "${SYNOPKG_PKG_STATUS}" == "UNINSTALL" -a "${wizard_remove_database}" == "true" ]; then
        ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e "DROP DATABASE ${PACKAGE}; DROP USER '${USER}'@'localhost';"
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
    mv ${INSTALL_DIR}/var ${TMP_DIR}/${PACKAGE}/

    exit 0
}

postupgrade ()
{
    # Restore some stuff
    rm -fr ${INSTALL_DIR}/var
    mv ${TMP_DIR}/${PACKAGE}/var ${INSTALL_DIR}/
    rm -fr ${TMP_DIR}/${PACKAGE}

    exit 0
}
