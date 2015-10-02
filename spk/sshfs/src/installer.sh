#!/bin/sh

# Package
PACKAGE="sshfs"
DNAME="sshfs"

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
    
    # Put sshfs & fusermount in the PATH
    mkdir -p /usr/local/bin
    ln -s ${INSTALL_DIR}/bin/sshfs /usr/local/bin/sshfs
	ln -s ${INSTALL_DIR}/bin/fusermount /usr/local/bin/fusermount

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
    rm -f /usr/local/bin/sshfs
	rm -f /usr/local/bin/fusermount
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

