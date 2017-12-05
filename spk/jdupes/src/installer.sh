#!/bin/sh

# Package
PACKAGE="jdupes"
DNAME="jdupes"

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

    # Put jdupes in the PATH
    mkdir -p /usr/local/bin
    ln -s ${INSTALL_DIR}/bin/jdupes /usr/local/bin/jdupes

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
    rm -f /usr/local/bin/jdupes

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
