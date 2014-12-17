#!/bin/sh

# Package
PACKAGE="monit"
DNAME="monit"
USER="root"
INSTALL_DIR="/usr/local/${PACKAGE}"

PATH="${INSTALL_DIR}/bin:/usr/local/bin:/bin:/usr/bin:/usr/syno/bin"

CFG_FILE="${INSTALL_DIR}/var/monitrc"
PID_FILE="${INSTALL_DIR}/var/monit.pid"
LOG_FILE="${INSTALL_DIR}/var/monit.log"

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

    # Edit the configuration according to the wizard
    sed -i -e "s/@control_username@/${wizard_control_username:=nzbget}/g" \
           -e "s/@control_password@/${wizard_control_password:=nzbget}/g" \
           ${CFG_FILE}

    # Add firewall config
    ${SERVICETOOL} --install-configure-file --package ${FWPORTS} >> /dev/null

    # Correct the files ownership
    chown -R ${USER}:root ${SYNOPKG_PKGDEST}
    exit 0
}

preuninst ()
{
    ${SSS} stop > /dev/null

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

