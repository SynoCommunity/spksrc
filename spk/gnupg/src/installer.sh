#!/bin/sh

# Package
PACKAGE="gnupg"
DNAME="GnuPG"

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

    # Add symlink
    mkdir -p /usr/local/bin
    ln -s ${INSTALL_DIR}/bin/gpg-agent /usr/local/bin/gpg-agent

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
    rm -f /usr/local/bin/gpg-agent

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
