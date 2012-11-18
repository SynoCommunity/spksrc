#!/bin/sh

# Package
PACKAGE="gateone"
DNAME="GateOne"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
SSS="/var/packages/${PACKAGE}/scripts/start-stop-status"
PYTHON_DIR="/usr/local/python"
PATH="${INSTALL_DIR}/bin:${INSTALL_DIR}/env/bin:${PYTHON_DIR}/bin:/usr/local/bin:/bin:/usr/bin:/usr/syno/bin"
PYTHON="${INSTALL_DIR}/env/bin/python"
VIRTUALENV="${PYTHON_DIR}/bin/virtualenv"
TMP_DIR="${SYNOPKG_PKGDEST}/../../@tmp"
RUNAS="gateone"


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
    adduser -h ${INSTALL_DIR}/var -g "${DNAME} User" -G users -s /bin/sh -S -D ${RUNAS}

    # Create a Python virtualenv
    ${VIRTUALENV} --system-site-packages ${INSTALL_DIR}/env > /dev/null

    # Install the bundle
    ${INSTALL_DIR}/env/bin/pip install -U -b ${INSTALL_DIR}/var/build ${INSTALL_DIR}/share/requirements.pybundle > /dev/null
    rm -fr ${INSTALL_DIR}/var/build

    # Install GateOne
    ${PYTHON} ${INSTALL_DIR}/share/GateOne/setup.py install --prefix=${INSTALL_DIR}

    # Correct the files ownership
    chown -R ${RUNAS}:root ${SYNOPKG_PKGDEST}

    exit 0
}

preuninst ()
{
    # Remove the user (if not upgrading)
    if [ "${SYNOPKG_PKG_STATUS}" != "UPGRADE" ]; then
        deluser ${RUNAS}
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
    chown -R ${RUNAS}:root ${INSTALL_DIR}/var
    rm -fr ${TMP_DIR}/${PACKAGE}

    exit 0
}
