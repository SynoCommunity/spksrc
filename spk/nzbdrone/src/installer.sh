#!/bin/sh

# Package
PACKAGE="nzbdrone"
DNAME="NzbDrone"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
INSTALL_LOG="${INSTALL_DIR}/var/install.log"
SSS="/var/packages/${PACKAGE}/scripts/start-stop-status"
PATH="${INSTALL_DIR}/bin:${PATH}"
USER="${PACKAGE}"
GROUP="users"
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

    # Correct the files ownership
    chown -R ${USER}:root ${SYNOPKG_PKGDEST}

    # Log
    echo " -- || Package Install Complete - $(date) || -- " >> ${INSTALL_LOG} 2>&1

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
    # Log Upgrade
    echo " -- || Beginning package upgrade - $(date) || -- " >> ${INSTALL_LOG} 2>&1
    # Stop the package
    ${SSS} stop > /dev/null

    # Save some stuff
    rm -fr ${TMP_DIR}/${PACKAGE} >> ${INSTALL_LOG} 2>&1
    mkdir -p ${TMP_DIR}/${PACKAGE} >> ${INSTALL_LOG} 2>&1
    mv ${INSTALL_DIR}/var ${TMP_DIR}/${PACKAGE}/ >> ${INSTALL_LOG} 2>&1

    exit 0
}

postupgrade ()
{
    # Restore some stuff
    rm -fr ${INSTALL_DIR}/var >> ${TMP_DIR}/${PACKAGE}/var/install.log 2>&1
    mv ${TMP_DIR}/${PACKAGE}/var ${INSTALL_DIR}/ >> ${TMP_DIR}/${PACKAGE}/var/install.log 2>&1
    rm -fr ${TMP_DIR}/${PACKAGE} >> ${INSTALL_LOG} 2>&1

    # Finish Logging
    echo " -- || Finished package upgrade - $(date) || -- " >> ${INSTALL_LOG} 2>&1

    exit 0
}
