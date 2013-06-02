#!/bin/sh

# Package
PACKAGE="haproxy"
DNAME="HAProxy"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
SSS="/var/packages/${PACKAGE}/scripts/start-stop-status"
PYTHON_DIR="/usr/local/python"
PATH="${INSTALL_DIR}/bin:${INSTALL_DIR}/env/bin:${PYTHON_DIR}/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/usr/syno/sbin:/usr/syno/bin"
USER="haproxy"
GROUP="nobody"
VIRTUALENV="${PYTHON_DIR}/bin/virtualenv"
TMP_DIR="${SYNOPKG_PKGDEST}/../../@tmp"


preinst ()
{
    exit 0
}

postinst ()
{
    # Link
    ln -s ${SYNOPKG_PKGDEST} ${INSTALL_DIR}

    # Create user
    adduser -h ${INSTALL_DIR}/var -g "${DNAME} User" -G ${GROUP} -s /bin/sh -S -D ${USER}

    # Edit the configuration according to the wizard
    sed -i -e "s/@user@/${wizard_user:=admin}/g" ${INSTALL_DIR}/var/haproxy.cfg.tpl
    sed -i -e "s/@passwd@/${wizard_passwd:=admin}/g" ${INSTALL_DIR}/var/haproxy.cfg.tpl

    # Create a Python virtualenv
    ${VIRTUALENV} --system-site-packages ${INSTALL_DIR}/env > /dev/null

    # Install the bundle
    ${INSTALL_DIR}/env/bin/pip install -U ${INSTALL_DIR}/share/requirements.pybundle > /dev/null

    # Setup the database
    ${INSTALL_DIR}/env/bin/python ${INSTALL_DIR}/app/setup.py

    # Correct the files ownership
    chown -R ${USER}:root ${SYNOPKG_PKGDEST}

    # Index help files
    pkgindexer_add ${INSTALL_DIR}/app/index.conf > /dev/null
    pkgindexer_add ${INSTALL_DIR}/app/helptoc.conf > /dev/null

    exit 0
}

preuninst ()
{
    # Stop the package
    ${SSS} stop > /dev/null

    # Remove the user (if not upgrading)
    if [ "${SYNOPKG_PKG_STATUS}" != "UPGRADE" ]; then
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
    chown -R ${USER}:root ${INSTALL_DIR}/var
    rm -fr ${TMP_DIR}/${PACKAGE}

    exit 0
}
