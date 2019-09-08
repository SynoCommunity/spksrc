#!/bin/sh

# Package
PACKAGE="tree"
DNAME="Tree"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PATH="${INSTALL_DIR}/bin:/usr/local/bin:/bin:/usr/bin:/usr/syno/bin"


preinst ()
{
    exit 0
}

postinst ()
{
    # Link
    ln -s ${SYNOPKG_PKGDEST} ${INSTALL_DIR}
    
    # Put tree in the PATH
    mkdir -p /usr/local/bin
    ln -s ${INSTALL_DIR}/bin/tree /usr/local/bin/tree

    exit 0
}

preuninst ()
{
    exit 0
}

postuninst ()
{
    # Remove link
    rm -f ${INSTALL_DIR}
    rm -f /usr/local/bin/tree

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
