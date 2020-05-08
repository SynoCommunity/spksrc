#!/bin/sh

# Package
PACKAGE="rar2fs"
DNAME="rar2fs"

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

    # Put rar2fs & mount.rar2fs in the PATH
    mkdir -p /usr/local/bin
    ln -s ${INSTALL_DIR}/bin/rar2fs /usr/local/bin/rar2fs
    ln -s ${INSTALL_DIR}/sbin/mount.rar2fs /usr/local/sbin/mount.rar2fs

    exit 0
}

preuninst ()
{
    exit 0
}

postuninst ()
{
    # Remove links
    rm -f ${INSTALL_DIR}
    rm -f /usr/local/bin/rar2fs
    rm -f /usr/local/sbin/mount.rar2fs
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

