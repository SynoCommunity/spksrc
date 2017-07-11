#!/bin/sh

# Package
PACKAGE="less"
DNAME="less"

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
    
    # Put less in the PATH
    mkdir -p /usr/local/bin
    ln -s ${INSTALL_DIR}/bin/less /usr/local/bin/less
    ln -s ${INSTALL_DIR}/bin/lessecho /usr/local/bin/lessecho
    ln -s ${INSTALL_DIR}/bin/lesskey /usr/local/bin/lesskey

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
    rm -f /usr/local/bin/less
    rm -f /usr/local/bin/lessecho
    rm -f /usr/local/bin/lesskey

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
