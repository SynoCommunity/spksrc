#!/bin/sh

# Package
PACKAGE="gateone"
DNAME="GateOne"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
APP_ENV="${INSTALL_DIR}/env"
SSS="/var/packages/${PACKAGE}/scripts/start-stop-status"
PYTHON_DIR="/usr/local/python"
PATH="${INSTALL_DIR}/bin:${APP_ENV}/bin:${PYTHON_DIR}/bin:${PATH}"
USER="gateone"
GROUP="nobody"
PYTHON="${APP_ENV}/bin/python"
VIRTUALENV="${PYTHON_DIR}/bin/virtualenv"
TMP_DIR="${SYNOPKG_PKGDEST}/../../@tmp"

SERVICETOOL="/usr/syno/bin/servicetool"
FWPORTS="/var/packages/${PACKAGE}/scripts/${PACKAGE}.sc"

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

    # Create a Python virtualenv
    ${VIRTUALENV} --system-site-packages ${APP_ENV} > /dev/null

    # Install the bundle
    ${APP_ENV}/bin/pip install --no-index -U ${INSTALL_DIR}/share/requirements.pybundle > /dev/null

    # Install GateOne
    PYTHONPATH="${APP_ENV}/lib/python2.7/site-packages/:${PYTHONPATH}" ${PYTHON} ${INSTALL_DIR}/share/GateOne/setup.py install --prefix=${APP_ENV} --skip_init_scripts > /dev/null

    # Correct the files ownership
    chown -R ${USER}:root ${SYNOPKG_PKGDEST}

    # Add firewall config
    ${SERVICETOOL} --install-configure-file --package ${FWPORTS} >> /dev/null

    exit 0
}

preuninst ()
{
    # Stop the package
    ${SSS} stop > /dev/null

    # Remove the user
    if [ "${SYNOPKG_PKG_STATUS}" == "UNINSTALL" ]; then
        delgroup ${USER} ${GROUP}
        deluser ${USER}
    fi

    # Remove firewall config
    if [ "${SYNOPKG_PKG_STATUS}" == "UNINSTALL" ]; then
        ${SERVICETOOL} --remove-configure-file --package ${PACKAGE}.sc >> /dev/null
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
