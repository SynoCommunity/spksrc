#!/bin/sh

# Package
PACKAGE="syncserver"
DNAME="Firefox Sync Server"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
SSS="/var/packages/${PACKAGE}/scripts/start-stop-status"
PYTHON_DIR="/usr/local/python"
PATH="${INSTALL_DIR}/env/bin:${INSTALL_DIR}/bin:${PYTHON_DIR}/bin:${PATH}"
HG="${PYTHON_DIR}/bin/hg"
VIRTUALENV="${PYTHON_DIR}/bin/virtualenv"
WIZARD="/var/packages/${PACKAGE}/WIZARD_UIFILES"

SERVICETOOL="/usr/syno/bin/servicetool"
FWPORTS="/var/packages/${PACKAGE}/scripts/${PACKAGE}.sc"

USER="syncserver"
GROUP="users"

MYSQL="/usr/syno/mysql/bin/mysql"

INI_FILE="${INSTALL_DIR}/var/syncserver.ini"
CONF_FILE="${INSTALL_DIR}/var/syncserver.conf"
TMP_DIR="${SYNOPKG_PKGDEST}/../../@tmp"


preinst ()
{
    # Check MySQL database
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        if [ ! -z "${wizard_mysql_password_root}" ]; then
            if ! ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e quit > /dev/null 2>&1; then
                echo "Incorrect MySQL root password"
                exit 1
            fi
            if ${MYSQL} -u root -p"${wizard_mysql_password_root}" mysql -e "SELECT User FROM user" | grep ^${USER}$ > /dev/null 2>&1; then
                echo "MySQL user ${USER} already exists"
                exit 1
            fi
            if ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e "SHOW DATABASES" | grep ^${PACKAGE}$ > /dev/null 2>&1; then
                echo "MySQL database ${PACKAGE} already exists"
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

    # Get IP address
    IP=`/sbin/ifconfig | grep 'inet addr:'| grep -v '127.0.0.1' | cut -d: -f2 | awk '{ print $1}'`

    # Edit the configuration according to the wizard
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        # SMTP config
        sed -i -e "s|@smtp_server@|${wizard_syncserver_smtp_server:=localhost}|g" \
               -e "s|@smtp_port@|${wizard_syncserver_smtp_port:=25}|g" \
               -e "s|@sender@|${wizard_syncserver_sender:=syncserver@domain.com}|g" \
               ${CONF_FILE}
        # Setup database, using SQLite unless MySQL password is provided
        if [ ! -z "${wizard_mysql_password_root}" ]; then
            # Use MySQL
            ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e "CREATE DATABASE ${PACKAGE}; GRANT ALL PRIVILEGES ON ${PACKAGE}.* TO '${USER}'@'localhost' IDENTIFIED BY '${wizard_password_syncserver:=syncserver}';"
            sed -i "s|sqluri.*|sqluri = pymysql://${USER}:${wizard_password_syncserver:=syncserver}@localhost:3306/${PACKAGE}|g" ${CONF_FILE}
        else
             # No need for uninstall wizard files with SQLite, removing
             rm -fr ${WIZARD}/uninstall*
        fi
        # Setup SSL and fallback node
        if [ "${wizard_syncserver_use_ssl}" == "true" ]; then
             # Create .pem file
             awk 'FNR==1{print ""}1' /usr/syno/etc/ssl/ssl.key/server.key /usr/syno/etc/ssl/ssl.crt/server.crt > ${INSTALL_DIR}/var/server.pem
             # Store the pem with chmod 400 in /var, otherwise we can't read it
             chmod 400 ${INSTALL_DIR}/var/server.pem
             # Update ini file with .pem file
             sed -i "11a \
               \ssl_pem = ${INSTALL_DIR}/var/server.pem" ${INI_FILE}
             # Use https in fallback node
             sed -i "s|fallback_node = http.*|fallback_node = https://${IP}:8130|g" ${CONF_FILE}
         else
             # use http in fallback node
             sed -i "s|fallback_node = http.*|fallback_node = http://${IP}:8130|g" ${CONF_FILE}
         fi
    fi

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

    # Add port-forwarding config
    ${SERVICETOOL} --install-configure-file --package ${FWPORTS} >> /dev/null

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

    # Remove port-forwarding config
    if [ "${SYNOPKG_PKG_STATUS}" == "UNINSTALL" ]; then
        ${SERVICETOOL} --remove-configure-file --package ${PACKAGE}.sc >> /dev/null
    fi

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
