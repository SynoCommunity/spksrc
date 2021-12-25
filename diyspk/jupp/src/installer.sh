#!/bin/sh

# Package
PACKAGE="jupp"
DNAME="jupp"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
BINS="jmacs  joe  jpico  jstar  jupp  rjoe  termidx"

preinst ()
{
    exit 0
}

postinst ()
{
    # Link
    ln -s ${SYNOPKG_PKGDEST} ${INSTALL_DIR}

    # Create symlinks for all binaries in the PATH
    mkdir -p /usr/local/bin
    for bin in $BINS; do
        ln -s ${INSTALL_DIR}/bin/$bin /usr/local/bin/$bin
    done

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
    for bin in $BINS; do
        rm -f /usr/local/bin/$bin
    done
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
