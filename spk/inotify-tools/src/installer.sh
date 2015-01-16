#!/bin/sh

# Package
PACKAGE="inotify-tools"

WAIT_TARGET="/usr/bin/inotifywait"
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
    if [ ! -e "$WAIT_TARGET" ]; then
        ln -s ${INSTALL_DIR}/bin/inotifywait ${WAIT_TARGET}
        ln -s ${INSTALL_DIR}/bin/inotifywatch ${WAIT_TARGET}
    fi
    exit 0
}

preuninst ()
{
    rm -f ${WAIT_TARGET}
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

