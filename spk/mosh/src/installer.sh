#!/bin/sh

# Package
PACKAGE="mosh"
DNAME="mosh"

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

    # Put mosh in the PATH
    mkdir -p /usr/local/bin
    ln -s ${INSTALL_DIR}/bin/mosh /usr/local/bin/mosh
    ln -s ${INSTALL_DIR}/bin/mosh-client /usr/local/bin/mosh-client
    ln -s ${INSTALL_DIR}/bin/mosh-server /usr/local/bin/mosh-server

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
    rm -f /usr/local/bin/mosh
    rm -f /usr/local/bin/mosh-client
    rm -f /usr/local/bin/mosh-server

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
