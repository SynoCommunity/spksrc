#!/bin/sh

# Package
PACKAGE="git-server"
DNAME="Git Server"

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
    ${INSTALL_DIR}/bin/adduser -h ${BASE_PATH} -g "${DNAME} User" -G ${GROUP} -s /bin/ash -S -D ${USER}

    # Set PATH and create authorized_keys file
    mkdir -p ${BASE_PATH}/.ssh/
    touch ${BASE_PATH}/.ssh/environment
    touch ${BASE_PATH}/.ssh/authorized_keys
    echo "export PATH=${INSTALL_DIR}/bin:$PATH" >> ${BASE_PATH}/.profile
    echo "PATH=${INSTALL_DIR}/bin:$PATH" >> ${BASE_PATH}/.ssh/environment

    # Symlink to serve via http
    ln -s ${BASE_PATH} /var/services/web/git

    # Correct the files ownership
    chown -R ${USER}:root ${SYNOPKG_PKGDEST}
    chmod -R 775 ${SYNOPKG_PKGDEST}
    chmod -R 700 ${BASE_PATH}/.ssh/

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
    # Remove links
    rm -f ${INSTALL_DIR}
    rm -f /var/services/web/git
    rm -f /usr/bin/git
    rm -f /usr/bin/git-upload-pack
    rm -f /usr/bin/git-receive-pack

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
