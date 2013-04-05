#!/bin/sh

# Package
PACKAGE="git"
DNAME="Git"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PID_FILE="${INSTALL_DIR}/var/run/git-daemon.pid"
LOG_FILE="${INSTALL_DIR}/var/log/git-daemon.log"
BASE_PATH="${INSTALL_DIR}/var/repositories"
SSS="/var/packages/${PACKAGE}/scripts/start-stop-status"
USER="git"
GROUP="users"

preinst ()
{
    exit 0
}

postinst ()
{
    # Link
    ln -s ${SYNOPKG_PKGDEST} ${INSTALL_DIR}
    ln -s ${SYNOPKG_PKGDEST}/bin/git /usr/bin/
    ln -s ${SYNOPKG_PKGDEST}/bin/git /usr/bin/git-receive-pack
    ln -s ${SYNOPKG_PKGDEST}/bin/git-upload-pack /usr/bin/

    # Install busybox stuff
    ${INSTALL_DIR}/bin/busybox --install ${INSTALL_DIR}/bin

    # Create user
    ${INSTALL_DIR}/bin/adduser -h ${BASE_PATH} -g "${DNAME} User" -G ${GROUP} -s /bin/sh -S -D ${USER}

    # Symlink to serve via http
    mkdir -p ${BASE_PATH}
    ln -s ${BASE_PATH} /var/services/web/git

    # Correct the files ownership
    chown -R ${USER}:root ${SYNOPKG_PKGDEST}
    chmod -R 775 ${SYNOPKG_PKGDEST}

    exit 0
}

preuninst ()
{
    # Stop the package
    ${SSS} stop > /dev/null

    # Remove the user (if not upgrading)
    if [ "${SYNOPKG_PKG_STATUS}" != "UPGRADE" ]; then
        ${INSTALL_DIR}/bin/delgroup ${USER} ${GROUP}
        ${INSTALL_DIR}/bin/deluser ${USER}
    fi

    exit 0
}

postuninst ()
{
    # Remove link
    rm -f ${INSTALL_DIR}
    rm -f /usr/bin/git
    rm -f /usr/bin/git-upload-pack
    rm -f /usr/bin/git-receive-pack
    rm -f /var/services/web/git

    exit 0
}

preupgrade ()
{
    exit 0
}

postupgrade ()
{
    exit 0
}
