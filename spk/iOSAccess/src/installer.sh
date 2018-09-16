#!/bin/sh

PACKAGE="iOSAccess"
INSTALL_DIR="/usr/local/${PACKAGE}"
VOLUME_DIR="${INSTALL_DIR}/volume"

preinst ()
{
    exit 0
}

postinst ()
{
    easy_install lockfile
    # Link
    ln -s ${SYNOPKG_PKGDEST} ${INSTALL_DIR}
    ln -s ${SYNOPKG_PKGDEST_VOL} ${VOLUME_DIR}
    exit 0
}

preuninst ()
{
    exit 0
}

postuninst ()
{
    # Remove link
    rm -f ${VOLUME_DIR}
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
