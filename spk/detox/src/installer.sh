#!/bin/sh

# Package
PACKAGE="detox"
DNAME="Detox"

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
    ln -s /usr/local/detox/bin/detox /usr/local/bin/detoxln -s /usr/local/detox/bin/detox /usr/local/bin/detox
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
    rm -f /usr/local/bin/detox

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
