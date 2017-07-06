#!/bin/sh

# Package
PACKAGE="fdupes"
DNAME="Fdupes"

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

    # Put fdupes in the PATH
    mkdir -p /usr/local/bin
    ln -s ${INSTALL_DIR}/bin/fdupes /usr/local/bin/fdupes

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
    rm -f /usr/local/bin/fdupes

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
