#!/bin/sh

# Package
PACKAGE="bc"
DNAME="bc"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PATH="${INSTALL_DIR}/bin:${PATH}"


preinst ()
{
    exit 0
}

postinst ()
{
    # Link
    ln -s ${SYNOPKG_PKGDEST} ${INSTALL_DIR}

    # Put bc in the PATH
    mkdir -p /usr/local/bin
    ln -s ${INSTALL_DIR}/bin/bc /usr/local/bin/bc

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
    rm -f /usr/local/bin/bc

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
