#!/bin/sh

# Package
PACKAGE="davfs2"
DNAME="davfs2"

DAVUSER="davfs2"
DAVGROUP="davfs2"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"

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

    # Add symlink
    mkdir -p /usr/local/bin
    ln -s ${INSTALL_DIR}/sbin/mount.davfs /usr/local/bin/mount.davfs
    ln -s ${INSTALL_DIR}/sbin/umount.davfs /usr/local/bin/umount.davfs
    
    ${INSTALL_DIR}/bin/addgroup ${DAVGROUP}
    ${INSTALL_DIR}/bin/adduser -h /var/cache/davfs2/ -s /sbin/nologin -G ${DAVGROUP} -D ${DAVUSER}


    # Correct the files ownership
    chown -R ${USER}:root ${SYNOPKG_PKGDEST}

    exit 0
}

preuninst ()
{
    # Remove the user (if not upgrading)
    if [ "${SYNOPKG_PKG_STATUS}" != "UPGRADE" ]; then
        ${INSTALL_DIR}/bin/delgroup ${DAVUSER} ${DAVGROUP}
        ${INSTALL_DIR}/bin/deluser ${DAVUSER}
    fi

    exit 0
}

postuninst ()
{
    # Remove link
    rm -f ${INSTALL_DIR}
    rm -f /usr/local/bin/mount.davfs
    rm -f /usr/local/bin/umount.davfs
    
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
