#!/bin/sh

# Package
PACKAGE="librsync"
DNAME="librsync"

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

    #Put mc in the PATH
    mkdir -p /usr/local/bin
     ln -s ${INSTALL_DIR}/bin/rdiff /usr/local/bin/rdiff

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
    rm -f /usr/local/bin/rdiff

    exit 0
}

preupgrade ()
{
    exit 0
}

postupgrade ()
{
    exit 0
