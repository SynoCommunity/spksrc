#!/bin/sh

# Package
PACKAGE="nzbdrone"
DNAME="NzbDrone"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
SSS="/var/packages/${PACKAGE}/scripts/start-stop-status"
PATH="${INSTALL_DIR}/bin:/usr/local/bin:/bin:/usr/bin:/usr/syno/bin"
USER="nzbdrone"
GROUP="users"
TMP_DIR="${SYNOPKG_PKGDEST}/../../@tmp"
PID_FILE="${INSTALL_DIR}/var/nzbdrone.pid"


preinst ()
{
    exit 0
}

postinst ()
{
    # Link
    ln -s ${SYNOPKG_PKGDEST} ${INSTALL_DIR}

    # Download & Extract NzbDrone
#    wget -P ${TMP_DIR} http://update.nzbdrone.com/v2/master/mono/NzbDrone.master.2.0.0.1236.mono.tar.gz
#    tar xvf ${TMP_DIR}/NzbDrone.master.2.0.0.1236.mono.tar.gz -C ${INSTALL_DIR}

    # Add sqlite class library
#    wget -P ${TMP_DIR} http://dl.dropboxusercontent.com/u/300345/libsqlite3.tar.gz
#    tar xvf ${TMP_DIR}/libsqlite3.tar.gz -C ${INSTALL_DIR}/NzbDrone

    # Install busybox stuff
    ${INSTALL_DIR}/bin/busybox --install ${INSTALL_DIR}/bin

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
