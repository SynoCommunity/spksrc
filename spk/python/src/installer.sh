#!/bin/sh

# Package
PACKAGE="python"
DNAME="Python"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PATH="${INSTALL_DIR}/bin:/usr/local/bin:/bin:/usr/bin:/usr/syno/bin"


preinst ()
{
    exit 0
}

postinst ()
{
    # Link
    ln -s ${SYNOPKG_PKGDEST} ${INSTALL_DIR}

    # Install busybox stuff
    ${INSTALL_DIR}/bin/busybox --install ${INSTALL_DIR}/bin

    # Byte-compile
    ${INSTALL_DIR}/bin/python -m compileall -q -f ${INSTALL_DIR}/lib/python2.7
    ${INSTALL_DIR}/bin/python -OO -m compileall -q -f ${INSTALL_DIR}/lib/python2.7

    # Save some information about the newly installed package
    ${INSTALL_DIR}/bin/python --version > ${SYNOPKG_PKGDEST}/output.log 2>&1
    echo >> ${SYNOPKG_PKGDEST}/output.log
    echo System installed modules: >> ${SYNOPKG_PKGDEST}/output.log
    ${INSTALL_DIR}/bin/pip freeze >> ${SYNOPKG_PKGDEST}/output.log

    echo "NOTE - Ignore that last sentence. This package does *not* start and stop like other packages. "
    echo "Python is correctly installed if you can see the version number "
    echo "and module information in the package Log tab."

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

