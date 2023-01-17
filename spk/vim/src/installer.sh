#!/bin/sh

# Package
PACKAGE="vim"
DNAME="Vim"

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
    ln -s ${INSTALL_DIR}/bin/vim-utf8 /usr/local/bin/vim

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
    rm -f /usr/local/bin/vim

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
