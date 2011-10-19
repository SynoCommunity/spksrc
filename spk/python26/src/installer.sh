#!/bin/sh

#Set PATH to avoid ipkg stuff
PATH=/bin:/usr/bin

INSTALL_PREFIX=/usr/local/python26

preinst ()
{
    exit 0
}

postinst ()
{
    # Installation directory
    mkdir -p ${INSTALL_PREFIX}

    # Extract the files to the installation ditectory
    ${SYNOPKG_PKGDEST}/sbin/xzdec -c ${SYNOPKG_PKGDEST}/package.txz | \
        tar xpf - -C ${INSTALL_PREFIX}
    # Remove the installer archive to save space
    rm ${SYNOPKG_PKGDEST}/package.txz

    # Install xzdec for the companion tools installation
    cp ${SYNOPKG_PKGDEST}/sbin/xzdec ${INSTALL_PREFIX}/bin/xzdec

    # Byte-compile the python distribution
    ${INSTALL_PREFIX}/bin/python -m compileall -q -f ${INSTALL_PREFIX}/lib/python2.6
    ${INSTALL_PREFIX}/bin/python -OO -m compileall -q -f ${INSTALL_PREFIX}/lib/python2.6

    exit 0
}

preuninst ()
{
    exit 0
}

postuninst ()
{
    # Remove the installation directory
    rm -fr ${INSTALL_PREFIX}

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
