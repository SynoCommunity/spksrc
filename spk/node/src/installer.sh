#!/bin/sh

# Package
PACKAGE="node"
DNAME="Node.js"

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

    # Correct the files ownership
    chown -R ${USER}:root ${SYNOPKG_PKGDEST}

    # Put symlinks in the PATH
    mkdir -p /usr/local/bin
    ln -s ${INSTALL_DIR}/bin/node /usr/local/bin/node
    ln -s ${INSTALL_DIR}/bin/npm /usr/local/bin/npm

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
    rm -f /usr/local/bin/node
    rm -f /usr/local/bin/npm

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
