#!/bin/sh

#########################################
# A few variables to make things readable

# Package specific variables
PACKAGE="python27"
DNAME="Python 2.7"

# Common variables
INSTALL_DIR="/usr/local/${PACKAGE}"
PATH="${INSTALL_DIR}/bin:/bin:/usr/bin:/usr/syno/sbin" # Avoid ipkg commands

#########################################
# DSM package manager functions

preinst ()
{
    exit 0
}

postinst ()
{
    # Installation directory
    mkdir -p ${INSTALL_DIR}
    mkdir -p /usr/local/bin

    # Extract the files to the installation ditectory
    ${SYNOPKG_PKGDEST}/sbin/xzdec -c ${SYNOPKG_PKGDEST}/package.txz | \
        tar xpf - -C ${INSTALL_DIR}
    # Remove the installer archive to save space
    rm ${SYNOPKG_PKGDEST}/package.txz

    # Install xzdec for the companion tools installation
    cp ${SYNOPKG_PKGDEST}/sbin/xzdec ${INSTALL_DIR}/bin/xzdec

    # Install the adduser and deluser hardlinks
    ${INSTALL_DIR}/bin/busybox --install ${INSTALL_DIR}/bin

    # Byte-compile the python distribution
    ${INSTALL_DIR}/bin/python -m compileall -q -f ${INSTALL_DIR}/lib/python2.7
    ${INSTALL_DIR}/bin/python -OO -m compileall -q -f ${INSTALL_DIR}/lib/python2.7

    exit 0
}

preuninst ()
{
    exit 0
}

postuninst ()
{
    # Remove the installation directory
    rm -fr ${INSTALL_DIR}

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
