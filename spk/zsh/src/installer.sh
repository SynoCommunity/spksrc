#!/bin/sh

# Package
PACKAGE="zsh"
DNAME="Zsh"

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

    # Set the permissions
    chown -hR root:root ${SYNOPKG_PKGDEST}
    chmod -R go-w ${SYNOPKG_PKGDEST}

    # Put zsh in the PATH
    mkdir -p /usr/local/bin
    ln -s ${INSTALL_DIR}/bin/zsh /usr/local/bin/zsh

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
    rm -f /usr/local/bin/zsh

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
