#!/bin/sh

# Package
PACKAGE="exfat"
DNAME="exfat"

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
    
    # Put exfat & fusermount in the PATH
    mkdir -p /usr/local/bin
    ln -s ${INSTALL_DIR}/sbin/mount.exfat-fuse /usr/local/bin/mount.exfat
    ln -s ${INSTALL_DIR}/sbin/mount.exfat-fuse /usr/local/bin/mount.exfat-fuse
    ln -s ${INSTALL_DIR}/sbin/dumpexfat /usr/local/bin/dumpexfat
    ln -s ${INSTALL_DIR}/sbin/exfatfsck /usr/local/bin/exfatfsck
    ln -s ${INSTALL_DIR}/sbin/exfatlabel /usr/local/bin/exfatlabel
	ln -s ${INSTALL_DIR}/sbin/exfatfsck /usr/local/bin/fsck.exfat
	ln -s ${INSTALL_DIR}/sbin/mkexfatfs /usr/local/bin/mkexfatfs
	ln -s ${INSTALL_DIR}/sbin/mkexfatfs /usr/local/bin/mkfs.exfat

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
	rm -f /usr/local/bin/dumpexfat
	rm -f /usr/local/bin/exfatfsck
	rm -f /usr/local/bin/exfatlabel
	rm -f /usr/local/bin/fsck.exfat
	rm -f /usr/local/bin/mkexfatfs
	rm -f /usr/local/bin/mkfs.exfat
	
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

