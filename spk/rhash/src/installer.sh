#!/bin/sh

# Package
PACKAGE="rhash"
DNAME="rhash"

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
    
    # Put nano in the PATH
    mkdir -p /usr/local/bin
    ln -s ${INSTALL_DIR}/bin/rhash /usr/local/bin/rhash

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
    rm -f /usr/local/bin/rhash

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
