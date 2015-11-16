#!/bin/sh

# Package
PACKAGE="exfat"
DNAME="exFAT"

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
    
    # Put fuse-exfat & exfat-utils in the PATH
    mkdir -p /usr/local/bin
    ln -s ${INSTALL_DIR}/sbin/mount.exfat-fuse /usr/local/bin/mount.exfat
    ln -s ${INSTALL_DIR}/sbin/mount.exfat-fuse /usr/local/bin/mount.exfat-fuse

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
    rm -f /usr/local/bin/mount.exfat
    rm -f /usr/local/bin/mount.exfat-fuse
	
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

