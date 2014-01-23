#!/bin/sh

# Package
PACKAGE="inotify-tools"
DNAME="inotify-tools"

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

    # Link in binary directory
    mkdir -p /usr/local/bin
    ln -s ${INSTALL_DIR}/bin/inotifywait /usr/local/bin/inotifywait
    ln -s ${INSTALL_DIR}/bin/inotifywatch /usr/local/bin/inotifywatch

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
    rm -f /usr/local/bin/inotifywait
    rm -f /usr/local/bin/inotifywatch

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
