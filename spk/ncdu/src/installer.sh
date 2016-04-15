#!/bin/sh

# Package
PACKAGE="ncdu"
DNAME="ncdu"

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

    # Put the binary in the PATH
    mkdir -p /usr/local/bin
    ln -s ${INSTALL_DIR}/bin/${PACKAGE} /usr/local/bin/${PACKAGE}
    
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
