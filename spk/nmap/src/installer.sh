#!/bin/sh

# Package
PACKAGE="nmap"
DNAME="nmap"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PROGS="nmap nping"


preinst ()
{
    exit 0
}

postinst ()
{
    # Links
    ln -s ${SYNOPKG_PKGDEST} ${INSTALL_DIR}
    for f in $PROGS; do ln -s ${INSTALL_DIR}/bin/$f /usr/local/bin/$f; done
    
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
    for f in $PROGS; do rm -f /usr/local/bin/$f; done

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
