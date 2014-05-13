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
    
    # Put vim in the PATH
    mkdir -p /usr/local/bin
    ln -s ${INSTALL_DIR}/bin/vim-utf8 /usr/local/bin/vim
    ln -s ${INSTALL_DIR}/bin/vimdiff /usr/local/bin/vimdiff

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
    rm -f /usr/local/bin/vimdiff

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
