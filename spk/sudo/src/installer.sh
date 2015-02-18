#!/bin/sh

# Package
PACKAGE="sudo"
DNAME="sudo"

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
    
    # Put mc in the PATH
    mkdir -p /usr/local/bin
    ln -s ${INSTALL_DIR}/bin/sudo /usr/local/bin/sudo

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
    rm -f /usr/local/bin/sudo

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
