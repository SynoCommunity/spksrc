#!/bin/sh

# Package
PACKAGE="syncserver"
DNAME="SyncServer"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
SSS="/var/packages/${PACKAGE}/scripts/start-stop-status"
PYTHON_DIR="/usr/local/python"
PATH="${INSTALL_DIR}/bin:${INSTALL_DIR}/env/bin:${PYTHON_DIR}/bin:/usr/local/bin:/bin:/usr/bin:/usr/syno/bin"
HG="${PYTHON_DIR}/bin/hg"
VIRTUALENV="${PYTHON_DIR}/bin/virtualenv"

USER="syncserver"
GROUP="users"

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

    # Edit the configuration according to the wizard
    sed -i -e "s|@port@|${wizard_syncserver_port:=8084}|g" ${INI_FILE}
    sed -i -e "s|@url@|${wizard_syncserver_url:=http://192.168.1.40:8084}|g" ${CONF_FILE}
    sed -i -e "s|@smtp_server@|${wizard_syncserver_smtp_server:=localhost}|g" ${CONF_FILE}
    sed -i -e "s|@smtp_port@|${wizard_syncserver_smtp_port:=25}|g" ${CONF_FILE}
    sed -i -e "s|@sender@|${wizard_syncserver_sender:=syncserver@domain.com}|g" ${CONF_FILE}
    
    # Create a Python virtualenv
    ${VIRTUALENV} --system-site-packages ${INSTALL_DIR}/env >> /dev/null

    # Install the bundle
    ${INSTALL_DIR}/env/bin/pip install --no-index -U --no-deps --force-reinstall ${INSTALL_DIR}/share/requirements.pybundle > /dev/null

    # Build syncserver
    cd ${INSTALL_DIR}/share/syncserver && ${INSTALL_DIR}/env/bin/buildapp server-core,server-reg,server-storage >> /dev/null

    # Create user
    adduser -h ${INSTALL_DIR}/var -g "${DNAME} User" -G ${GROUP} -s /bin/sh -S -D ${USER}

    # Correct the files ownership
    chown -R ${USER}:root ${SYNOPKG_PKGDEST}

    exit 0
}

preuninst ()
{

    # Stop the package
    ${SSS} stop > /dev/null

    # Remove the user if uninstalling
    if [ "${SYNOPKG_PKG_STATUS}" == "UNINSTALL" ]; then
	delgroup ${USER} ${GROUP}
	deluser ${USER}
    fi

    exit 0
}

postuninst ()
{
    # Remove link
    rm -f ${INSTALL_DIR}

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
