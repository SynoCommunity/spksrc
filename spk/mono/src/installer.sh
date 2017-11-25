#!/bin/sh

# Package
PACKAGE="mono"
DNAME="Mono"

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

    exit 0
}

preuninst ()
{
    # Remove link
    rm -f ${INSTALL_DIR}

    exit 0
}

postuninst ()
{
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
