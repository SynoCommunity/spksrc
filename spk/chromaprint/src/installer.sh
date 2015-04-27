#!/bin/sh

# Package
PACKAGE="chromaprint"
DNAME="Chromaprint"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
SSS="/var/packages/${PACKAGE}/scripts/start-stop-status"
PATH="${INSTALL_DIR}/bin:${PATH}"
GROUP="users"
TMP_DIR="${SYNOPKG_PKGDEST}/../../@tmp"
TARGET_LINK="/usr/local/bin/fpcalc"

preinst ()
{
    exit 0
}

postinst ()
{
    # Link
    ln -s ${SYNOPKG_PKGDEST} ${INSTALL_DIR}
    if [ ! -e "$TARGET_LINK" ]; then
        mkdir -p /usr/local/bin
        ln -s ${INSTALL_DIR}/bin/fpcalc ${TARGET_LINK}
    fi
    exit 0
}

preuninst ()
{
    # Stop the package
    ${SSS} stop > /dev/null

    exit 0
}

postuninst ()
{
    # Remove link
    rm -f ${INSTALL_DIR}
    rm -f ${TARGET_LINK}

    exit 0
}

preupgrade ()
{
    # Stop the package
    ${SSS} stop > /dev/null

    exit 0
}

postupgrade ()
{
    exit 0
}
