#!/bin/sh

# Package
PACKAGE="bacula"
DNAME="Bacula File Daemon"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
SSS="/var/packages/${PACKAGE}/scripts/start-stop-status"
PATH="${INSTALL_DIR}/bin:${PATH}"
USER="bacula"
GROUP="bacula"
CFG_FILE="${INSTALL_DIR}/etc/bacula-fd.conf"
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

    # Create group
    #addgroup ${GROUP}

    # Create user
    #adduser -h ${INSTALL_DIR}/var -g "${DNAME} User" -G ${GROUP} -s /bin/sh -S -D ${USER}

    # Create working directory
    mkdir ${INSTALL_DIR}/working

    # Set ownership
    chown -h -R root:root ${INSTALL_DIR}/*
    #chown -R ${USER}:root ${INSTALL_DIR}/*

    # Add firewall config
    ${SERVICETOOL} --install-configure-file --package ${FWPORTS} >> /dev/null

    exit 0
}

preuninst ()
{
    # Stop the package
    ${SSS} stop > /dev/null

    # Remove the user (if not upgrading)
    #if [ "${SYNOPKG_PKG_STATUS}" != "UPGRADE" ]; then
    #    delgroup ${USER} ${GROUP}
    #    deluser ${USER}
    #fi

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
    mkdir -p ${TMP_DIR}/${PACKAGE}/etc
    mv ${INSTALL_DIR}/var ${TMP_DIR}/${PACKAGE}/
    cp ${INSTALL_DIR}/etc/*.conf ${TMP_DIR}/${PACKAGE}/etc

    exit 0
}

postupgrade ()
{
    # Restore some stuff
    rm -fr ${INSTALL_DIR}/var
    mv ${TMP_DIR}/${PACKAGE}/var ${INSTALL_DIR}/
    cp ${TMP_DIR}/${PACKAGE}/etc/*.conf ${INSTALL_DIR}/etc
    rm -fr ${TMP_DIR}/${PACKAGE}

    exit 0
}
