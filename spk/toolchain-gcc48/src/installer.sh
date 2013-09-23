#!/bin/sh

# Package
PACKAGE="toolchain-gcc48"
DNAME="Gcc 4.8 / Glibc 2.18 toolchain"

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
    
    # Put it in the PATH
    mkdir -p /usr/local/bin
#    ln -s ${INSTALL_DIR}/bin/xx /usr/local/bin/xx

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
#    rm -f /usr/local/bin/xx

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
